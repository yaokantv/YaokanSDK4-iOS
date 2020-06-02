//
//  YKMatchRFKeyTableViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 6/8/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchRFKeyTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKDevice.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"
#import "YKCollectionViewCell.h"
#import <AudioToolbox/AudioServices.h>

@interface YKMatchRFKeyTableViewController () <UIGestureRecognizerDelegate>
{
    NSArray *keys;
    YKRemoteMatchDevice *matchDevice;
    BOOL isLearning;
}
@end

@implementation YKMatchRFKeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keys = @[];
    
    self.title = @"匹配按键";
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
    
    CGFloat SCREEN_WIDTH = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat width = (SCREEN_WIDTH - 40 - 3*(1.f/[[UIScreen mainScreen] scale]) - 10)/3.f;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width/2);
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView reloadData];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak __typeof(self)weakSelf = self;
//   YaokanSDK fetchRF
    [YaokanSDK fetchRFRemoteDeviceWithYKCId:[YKCenterCommon sharedInstance].currentYKCId remoteDeviceTypeId:_tid remoteDeviceBrand:_brand completion:^(YKRemoteMatchDevice * mDevice, NSArray<YKRemoteMatchDeviceKey *> * matchKeys, NSError * error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        keys = matchKeys;
        matchDevice = mDevice;
        [weakSelf updateUI];
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isLearning) {
        [YaokanSDK learnStopWithMatchRemote:matchDevice];
        isLearning = NO;
    }
}

- (void)updateUI{
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ( ((YKRemoteMatchDeviceKey *)obj1).standard) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return keys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YKRemoteCellIdentifier"
                                                                           forIndexPath:indexPath];
    
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    cell.keyLabel.text = key.key;
    cell.nameLabel.text = key.kn;
    cell.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.layer.borderWidth = 1.0;
    cell.layer.cornerRadius = 4.0f;
    
    if (key.standard) {
        cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
                                               green:242.0/255.0
                                                blue:253.0/255.0
                                               alpha:1];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
//       isLearning = YES;
       [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
//           isLearning = NO;
       }];
    
}

- (IBAction)save:(id)sender {
    //保存
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
//    [YaokanSDK saveRFRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice
//                                completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
//        if (remote && error == nil) {
//            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
}

- (void)showMessage:(NSString *)msg {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"确认"
                               style:UIAlertActionStyleCancel
                               handler:nil];
    
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        if (isLearning) {
            return;
        }
        [self showMessage:@"进入学习，请对准设备发码"];
        isLearning = YES;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        YKRemoteMatchDeviceKey *key = keys[indexPath.row];

        [YaokanSDK learnRFWithMatchRemote:matchDevice key:key.key completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
            
            isLearning = NO;
            NSLog(@"RF rid :%ld",matchDevice.typeId);
            
            if (error) {
                [self showMessage:error.localizedDescription];
            }
            else {
                [self showMessage:@"学习完成"];
            }
        }];
    }
}


@end

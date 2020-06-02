//
//  YKRemoteViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/19.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRemoteViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "YKCollectionViewCell.h"
#import <AudioToolbox/AudioServices.h>
#import "MBProgressHUD.h"

@interface YKRemoteViewController () <UIGestureRecognizerDelegate>
{
    NSArray *keys;
    BOOL isLearning;
    
    //记录是否有学习成功过的
    BOOL hadLearnRF;
}
@end

@implementation YKRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLearning = NO;
    self.title = self.remote.name;

    keys = [self.remote.keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ( ((YKRemoteDeviceKey *)obj1).standard) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStyleDone target:self action:@selector(exportAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isLearning) {
        [YaokanSDK learnStopWithRemote:_remote];
        isLearning = NO;
    }
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
        YKRemoteDeviceKey *key = keys[indexPath.row];

        [YaokanSDK learnWithRemote:_remote key:key.key
                         completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error)
        {
            isLearning = NO;
            if ([YKRemoteDeviceType isRF:(NSInteger)_remote.typeId] ) {
                NSLog(@"RF rid :%@",ridNew);
            }else{
                NSLog(@"IR rid :%@",ridNew);
            }
            
            if (error) {
                [self showMessage:error.localizedDescription];
            }
            else {
                [self showMessage:@"学习完成"];
                if (!hadLearnRF) {
                    if ([YKRemoteDeviceType isRF:(NSInteger)_remote.typeId] ) {
                        [self changeBackAction];
                        hadLearnRF = YES;
                    }
                }
            }
        }];
    }
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

#pragma mark - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return keys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YKRemoteCellIdentifier"
                                                                           forIndexPath:indexPath];
    YKRemoteDeviceKey *key = keys[indexPath.row];
    cell.keyLabel.text = key.key;
    cell.nameLabel.text = key.name;
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
    YKRemoteDeviceKey *key = keys[indexPath.row];
    
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDevice:self.remote cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}


- (void)changeBackAction{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:
              [UIImage imageNamed:@"LeftArrow"]
                                              style:(UIBarButtonItemStylePlain)
                                             target:self
                                             action:@selector(back)]
    animated:TRUE];
}

- (void)back{
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [YaokanSDK updateAudioControlWithRemoteDevice:self.remote completion:^(BOOL result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)exportAction{
    NSDictionary *rcDict = [self.remote toJsonObject];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导出结果" message:rcDict.description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end

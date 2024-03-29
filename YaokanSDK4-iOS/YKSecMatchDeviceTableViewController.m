//
//  YKSecMatchDeviceTableViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 25/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKSecMatchDeviceTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"
#import "YKCollectionViewCell.h"

@interface YKSecMatchDeviceTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *keys;
    NSInteger curIdx;
}

@property (nonatomic, strong) NSArray<YKRemoteMatchDevice *> *matchList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YKSecMatchDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二级匹配";
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YaokanSDK requestSecondMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_tid remoteDeviceBrandId:_bid group:_gid completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        strongSelf.matchList = mathes;
        if (mathes.count > 0) {
            curIdx = 0;
            _lb.text = [NSString stringWithFormat:@"1/%ld",strongSelf.matchList.count];
            [strongSelf requestMatchKey:mathes[curIdx]];
        }
        
    }];

}

- (void)requestMatchKey:(YKRemoteMatchDevice *)matchDevice {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK requestRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:matchDevice.typeId remoteDeviceId:matchDevice.rid completion:^(NSArray * _Nonnull matchKeys, NSError * _Nonnull error) {

        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD  hideHUDForView:strongSelf.view animated:YES];
        keys = [matchKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ( ((YKRemoteMatchDeviceKey *)obj1).standard) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        [strongSelf.collectionView reloadData];
    }];
    
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
    YKRemoteDeviceKey *key = keys[indexPath.row];
    
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    
    [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"
                                                            forIndexPath:indexPath];
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    cell.textLabel.text = key.key;
    cell.detailTextLabel.text = key.kn;
    
    
    if (key.standard) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    
     YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    
    [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
    
}

- (IBAction)pre:(id)sender{
    if (curIdx > 0) {
        curIdx--;
    }
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    [self requestMatchKey:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,self.matchList.count];
}

- (IBAction)next:(id)sender{
    if (curIdx <_matchList.count-1) {
        curIdx++;
    }
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    [self requestMatchKey:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,self.matchList.count];
}

- (IBAction)save:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    //保存
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end

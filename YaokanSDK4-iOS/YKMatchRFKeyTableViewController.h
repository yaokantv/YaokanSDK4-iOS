//
//  YKMatchRFKeyTableViewController.h
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 6/8/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YaokanSDK/YKRemoteDeviceBrand.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKMatchRFKeyTableViewController : UICollectionViewController

@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, strong) YKRemoteDeviceBrand *brand;

@end

NS_ASSUME_NONNULL_END

//
//  YKRemoteViewController.h
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/19.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKRemoteDevice;

@interface YKRemoteViewController : UICollectionViewController
@property (nonatomic, strong) YKRemoteDevice *remote;
@end

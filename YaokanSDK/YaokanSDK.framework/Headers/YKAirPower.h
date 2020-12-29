//
//  YKAirPower.h
//  YaokanSDK
//
//  Created by yaokan on 2020/12/25.
//  Copyright © 2020 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKAirPower : NSObject

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *value;     // 常用品牌标识    1: 常用 ， 0： 不常用
@property (nonatomic, copy) NSString * createdAt;        // brand id

@end

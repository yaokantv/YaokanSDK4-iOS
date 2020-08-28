//
//  YaokanSDK.h
//  YaokanSDK
//
//  Created by Don on 2019/4/15.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YaokanSDK/YaokanSDKHeader.h>
#import "YKDevice.h"
#import "YKSetboxCarrier.h"
#import "YKArea.h"
#import "YKRemoteDeviceType.h"
#import "YKRemoteDeviceBrand.h"

@class YKDevice;


NS_ASSUME_NONNULL_BEGIN

@interface YaokanSDK : NSObject

@property (nonatomic,readonly) BOOL isSDKRegist;

//! Project version number for YaokanSDK.
FOUNDATION_EXPORT double YaokanSDKVersionNumber;

//! Project version string for YaokanSDK.
FOUNDATION_EXPORT const unsigned char YaokanSDKVersionString[];

- (instancetype)init NS_UNAVAILABLE;

/*
 获取 YaokanSDK 单例的实例
 
 @return 返回初始化后 SDK 唯一的实例。SDK 不管有没有初始化，都会返回一个有效的值。
 */
+ (instancetype)sharedInstance;


/**
 注册并初始化 SDK，有注册结果回调方法。
 
 注意：此接口调用成功后，其他接口的功能才可以正常使用。
 
 @param appId 应用 ID 是在遥看开发者中心注册。
@param secret 应用 secret 是在遥看开发者中心获得。
 @param completion 注册成功回调。
 */
+ (void)registApp:(NSString *)appId secret:(NSString *)secret completion:(void (^ __nullable)(NSError *error))completion;




/**
 绑定遥控中心 YKC，完成后使用 block 回调返回结果。配网过程中切出现Wi-Fi 请引导用户按确定，否则会导致配网
 @param ssid Wi-Fi 的 SSID 名称
 @param password Wi-Fi 的密码
 @param deviceType 要入网的设备产品
 @param completion 绑定遥控中心设备完成的回调。如果绑定出错，返回 error 对象；如果有连接成功，error 为空，返回新入网的设备device 对象。
 */
+ (void)bindYKCV2WithSSID:(NSString *)ssid
                 password:(nullable NSString *)password
               deviceType:(ConfigDeviceType)deviceType
               configType:(ConfigType)configType
               completion:(void (^__nullable)(NSError * _Nullable error, YKDevice * _Nullable  device))completion;


/// 停止入网(如果配网成功或60秒内没配网的 均会自动停止。 若有 bindYKCV2WithSSID 回调前人为终止配网的需求，可用此方法)
- (void)stopBind;

/**
 获取设备列表

 @param completion 返回YKDevice 数组
 */
+ (void)fetchBoundYKC:(void (^)(NSArray<YKDevice *> * _Nullable, NSError *error))completion;




/**
 获取遥控码的设备类型

 @param ykcId       遥控中心 id
 @param completion  返回遥控码的设备类型列表
 */
+ (void)fetchRemoteDeviceTypeWithYKCId:(NSString *)ykcId
                            completion:(void (^__nullable)(NSArray<YKRemoteDeviceType *> *types, NSError *error))completion;


/**
 获取遥控码的设备品牌

 @param ykcId       遥控中心 id
 @param typeId      遥控码的设备类型 id
 @param completion  返回遥控码的设备品牌列表
 */
+ (void)fetchRemoteDeviceBrandWithYKCId:(NSString *)ykcId
                     remoteDeviceTypeId:(NSUInteger)typeId
                             completion:(void (^__nullable)(NSArray<YKRemoteDeviceBrand*> *brands, NSError *error))completion;



/**
 射频对码列表
 
 @param ykcId 遥控中心 id
 @param typeId 遥控码的设备类型 id
 @param brand 品牌(YKRemoteDeviceBrand)
 @param completion 返回遥控码的匹配设备列表
 */
+ (void)fetchRFRemoteDeviceWithYKCId:(NSString *)ykcId
                  remoteDeviceTypeId:(NSUInteger)typeId
                   remoteDeviceBrand:(YKRemoteDeviceBrand *)brand
                          completion:(void (^)(YKRemoteMatchDevice *, NSArray<YKRemoteMatchDeviceKey *> *,NSError *))completion;

/**
 获取遥控码的匹配设备列表，每个遥控码设备只返回几个匹配用的按键（逐个匹配）

 @param ykcId 遥控中心 id
 @param typeId 遥控码的设备类型 id
 @param brandId 遥控码的品牌 id
 @param completion 返回遥控码的匹配设备列表
 */
+ (void)fetchMatchRemoteDeviceWithYKCId:(NSString *)ykcId
                     remoteDeviceTypeId:(NSUInteger)typeId
                    remoteDeviceBrandId:(NSUInteger)brandId
                             completion:(void (^__nullable)(NSArray<YKRemoteMatchDevice*> *mathes, NSError *error))completion;


/**
 一级匹配遥控器列表 每个遥控码设备只返回特定匹配用的按键（遥控码）
 
 @param ykcId 遥控中心 id
 @param typeId 遥控码的设备类型 id
 @param brandId 遥控码的品牌 id
 @param completion 返回遥控码的匹配设备列表
 */
+ (void)requestFirstMatchRemoteDeviceWithYKCId:(NSString *)ykcId
                     remoteDeviceTypeId:(NSUInteger)typeId
                    remoteDeviceBrandId:(NSUInteger)brandId
                             completion:(void (^__nullable)(NSArray<YKRemoteMatchDevice*> *mathes, NSError *error))completion;



/**
 二级匹配遥控器列表
 
 @param ykcId 遥控中心 id
 @param typeId 遥控码的设备类型 id
 @param brandId 遥控码的品牌 id
 @param completion 返回YKRemoteMatchDevice列表
 */
+ (void)requestSecondMatchRemoteDeviceWithYKCId:(NSString *)ykcId
                            remoteDeviceTypeId:(NSUInteger)typeId
                           remoteDeviceBrandId:(NSUInteger)brandId
                                          group:(NSInteger)gid
                                    completion:(void (^__nullable)(NSArray<YKRemoteMatchDevice*> *mathes, NSError *error))completion;


/**
 发送一级匹配的
 
 @param ykcId 遥控中心 id
 @param remote YKRemoteMatchDevice对象数组
 @param completion 发码结果回调
 */
+ (void)sendFirstMatchRemoteWithYKCId:(NSString *)ykcId
                          matchRemote:(YKRemoteMatchDevice *)remote
                           completion:(void (^__nullable)(BOOL result, NSError *error))completion;



/**
 已有遥控器发码
 
 @param mac  遥控中心 id
 @param remoteDevice  YKRemoteDevice 已创建的遥控器
 @param cmdKey 按键名
 @param completion 回调
 */
+ (void)sendRemoteWithYkcId:(NSString *)mac
               remoteDevice:(YKRemoteDevice *)remoteDevice
                     cmdkey:(NSString *)cmdKey
                 completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 匹配阶段遥控器发码
 
 @param mac  遥控中心 id
 @param matchDevice YKRemoteMatchDevice 类型
 @param completion 回调
 */
+ (void)sendRemoteMatchingWithYkcId:(NSString *)mac
                matchDevice:(YKRemoteMatchDevice *)matchDevice
                     cmdkey:(NSString *)cmdKey
                 completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 请求遥控器详情

 @param ykcId 硬件mac地址
 @param typeId 遥控器类型
 @param remoteDeviceId 遥控器id
 @param completion 回调
 */
+ (void)requestRemoteDeivceWithYKCId:(NSString *)ykcId
                  remoteDeviceTypeId:(NSUInteger)typeId
                      remoteDeviceId:(NSString *)remoteDeviceId
                          completion:(void (^__nullable)(NSArray *matchKeys, NSError *error))completion;


/**
 请求空调匹配数据

 @param ykcId 硬件mac地址
 @param typeId 电器类型
 @param remoteDeviceId 遥控器id
 @param completion 回调
 */
+ (void)requestACDetailWithYKCId:(NSString *)ykcId
               remoteDeviceTypeId:(NSUInteger)typeId
                   remoteDeviceId:(NSString *)remoteDeviceId
                       completion:(void (^__nullable)(YKRemoteMatchDevice *remote, NSError *error))completion;


/**
 匹配空调发码
 
 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendMatchACWithYKCId:(NSString *)ykcId
                remoteDevice:(YKRemoteMatchDevice *)remoteDevice
                    withMode:(NSString *)mode
                        temp:(NSUInteger)temp
                       speed:(NSUInteger)speed
                       windU:(NSUInteger)windU
                       windL:(NSUInteger)windL
                  completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 匹配空调上下扫风发码
 
 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendMatchAcWindUDWithYKCId:(NSString *)ykcId
                      remoteDevice:(YKRemoteMatchDevice *)remoteDevice
                          withMode:(NSString *)mode
                              temp:(NSUInteger)temp
                             speed:(NSUInteger)speed
                             windU:(NSUInteger)windU
                             windL:(NSUInteger)windL
                        completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
匹配空调左右扫风发码
 
 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendMatchAcWindLRWithYKCId:(NSString *)ykcId
                      remoteDevice:(YKRemoteMatchDevice *)remoteDevice
                          withMode:(NSString *)mode
                              temp:(NSUInteger)temp
                             speed:(NSUInteger)speed
                             windU:(NSUInteger)windU
                             windL:(NSUInteger)windL
                        completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 发空调码给摇控中心

 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendACWithYKCId:(NSString *)ykcId
          remoteDevice:(YKRemoteDevice *)remoteDevice
              withMode:(NSString *)mode
                  temp:(NSUInteger)temp
                 speed:(NSUInteger)speed
                 windU:(NSUInteger)windU
                 windL:(NSUInteger)windL
            completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 发空调码左右扫风
 
 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendAcWindUDWithYKCId:(NSString *)ykcId
                 remoteDevice:(YKRemoteDevice *)remoteDevice
                     withMode:(NSString *)mode
                         temp:(NSUInteger)temp
                        speed:(NSUInteger)speed
                        windU:(NSUInteger)windU
                        windL:(NSUInteger)windL
                   completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 发空调码左右扫风
 
 @param ykcId 遥控中心 id
 @param remoteDevice 遥控器对象
 @param mode 空调模式
 @param temp 温度
 @param speed 风速
 @param windU 上下扫风级别
 @param windL 左右扫风级别
 @param completion 发码结果回调
 */
+ (void)sendAcWindLRWithYKCId:(NSString *)ykcId
                 remoteDevice:(YKRemoteDevice *)remoteDevice
                     withMode:(NSString *)mode
                         temp:(NSUInteger)temp
                        speed:(NSUInteger)speed
                        windU:(NSUInteger)windU
                        windL:(NSUInteger)windL
                   completion:(void (^__nullable)(BOOL result, NSError *error))completion;


/**
 保存遥控器

 @param ykcId 硬件mac地址
 @param matchDevice YKRemoteMatchDevice类型
 @param completion 回调
 */

+ (void)saveRemoteDeivceWithYKCId:(NSString *)ykcId
                      matchDevice:(YKRemoteMatchDevice *)matchDevice
                       completion:(void (^__nullable)(YKRemoteDevice *remote, NSError *error))completion;

/**
 获取省份列表
 
 @param ykcId 硬件mac地址
 @param completion 回调
 */
+ (void)requestProvincesWithYKCId:(NSString *)ykcId
                       completion:(void (^__nullable)(NSArray<YKArea*> *areas, NSError *error))completion;



/**
 获取城市列表

 @param ykcId 硬件mac地址
 @param pId 省份Id
 @param completion 回调
 */
+ (void)requestCitiesWithYKCId:(NSString *)ykcId
                    provinceId:(NSInteger)pId
                    completion:(void (^__nullable)(NSArray<YKArea*> *cities, NSError *error))completion;
    


/**
 获取运营商列表

 @param ykcId 硬件mac地址
 @param aId 地区Id
 @param completion 回调
 */
+ (void)requestSetboxCarrierWithYKCId:(NSString *)ykcId
                               areaId:(NSInteger)aId
                           completion:(void (^__nullable)(NSArray<YKSetboxCarrier*> *setboxCarriers, NSError *error))completion;

/**
 删除遥控器

 @param ykcId 硬件mac地址
 @param remote YKRemoteDevice 对象
 @param completion 回调
 */
+ (void)removeRemoteDeivceWithYKCId:(NSString *)ykcId
                             remote:(YKRemoteDevice *)remote
                         completion:(void (^__nullable)(NSError *error))completion;


/**
 变更遥控器名字
 
 @param name 遥控器名称
 */
+ (BOOL)updateRemoteDeivceNameWithName:(NSString *)name
                                remote:(YKRemoteDevice *)remote;

/**
 切换遥控中心LED灯开关
 
 @param ykcId 硬件mac地址
 */
+ (void)toogleLEDWithYKCId:(NSString *)ykcId;

/**
打开硬件LED灯开关
 
 @param ykcId 硬件mac地址
 */
+ (void)turnOnLEDWithYKCId:(NSString *)ykcId;

/**
关闭硬件LED灯开关
 
 @param ykcId 硬件mac地址
 */
+ (void)turnOffLEDWithYKCId:(NSString *)ykcId;


/**
 硬件复位(复位 后是 SmartConfig)
 
 @param ykcId 硬件mac地址
 */
+ (void)restoreWithYKCId:(NSString *)ykcId;


/**
硬件复位(复位后 处于 SoftAP配网模式)

@param ykcId 硬件mac地址
*/
+ (void)restoreToApWithYKCId:(NSString *)ykcId;


/**
 遥控器学习(基于已创建的)
 @param remote YKRemoteDevice 对象
 @param keyName 键名
 @param completion 回调
 */
+ (void)learnWithRemote:(YKRemoteDevice *)remote
                    key:(NSString *)keyName
             completion:(void (^__nullable)(NSString *ridNew,NSError *error))completion;


/**
 射频遥控器学习(对码阶段)
 
 @param mathchRemote YKRemoteMatchDevice 对象
 @param keyName 键名
 @param completion 回调
 */
+ (void)learnRFWithMatchRemote:(YKRemoteMatchDevice *)mathchRemote
                                   key:(NSString *)keyName
                            completion:(void (^__nullable)(NSString *ridNew,NSError *error))completion;





/**
 停止学习(基于已创建的遥控器)
 
 @param remote YKRemoteDevice 对象

 */
+ (void)learnStopWithRemote:(YKRemoteDevice *)remote;


/**
 停止学习(匹配阶段的射频遥控器)
 
 @param matchRemote YKRemoteMatchDevice 对象

 */
+ (void)learnStopWithMatchRemote:(YKRemoteMatchDevice *)matchRemote;

/**
 获取硬件版本

 @param ykcId 遥看小苹果mac地址
 @param completion 回调version 为当前版本 otaVersion为最新版本
 */
+ (void)checkDeviceVersion:(NSString *)ykcId completion:(void (^__nullable)(NSString *version,NSString *otaVersion,NSError *error))completion;


/**
 更新硬件固件版本

 @param ykcId 遥看小苹果mac地址
 @param progress 配网进度
 @param completion 回调 flag 判断是否升级成功。
 */
+ (void)updateDeviceVersion:(NSString *)ykcId progress:(void (^__nullable)(float progressNum))progress completion:(void (^__nullable)(BOOL flag,NSError *error))completion;


/// 查询设备信息
/// @param ykcId 设备Mac地址
/// @param completion 回调(字典类型)
+ (void)deviceInfo:(NSString *)ykcId completion:(void (^__nullable)(BOOL flag,NSDictionary *info))completion;


/// 查询设备存储的遥控列列表
/// @param ykcId 设备Mac地址
/// @param completion 回调 list 为而二维数据组 ，子数组只有两个，第一个为遥控器rid,第二个为遥控器类型id
+ (void)remoteListInDevice:(NSString *)ykcId completion:(void (^__nullable)(BOOL flag,NSArray *list))completion;

/**
更新本地语音射频遥控器(红外无需此操作)
@param remoteDevice 遥控器
@param completion 回调 result 判断更新成功
*/
+ (void)updateAudioControlWithRemoteDevice:(YKRemoteDevice *)remoteDevice
                                completion:(void (^__nullable)(BOOL result))completion;



/// 获取房间名出列表
/// @param completion 回调（result 为NSString 类型的数组）
+ (void)placeListCompletion:(void (^__nullable)(NSArray *result,NSError *e))completion;


/// 获取设备别名列表
/// @param tid 遥控器tid
/// @param completion 回调（result 为字典类型的数组）
+ (void)aliasList:(NSInteger)tid completion:(void (^__nullable)(NSArray *result,NSError *e))completion;


/// 更新语音遥控器别名(仅限于带语音功能设备)
/// @param remoteDevice 已创建好的遥控器
/// @param completion 回调
+(void)updateAudioControlAlias:(YKRemoteDevice *)remoteDevice completion:(void (^__nullable)(BOOL flag,NSError *e))completion;


/**
射频对码列表(需要綁定电器自身的mac地址)

@param ykcId 遥控中心 id
@param typeId 遥控码的设备类型 id
@param deviceId 电器自身的Mac地址
@param brand 品牌(YKRemoteDeviceBrand)
@param completion 返回遥控码的匹配设备列表
*/
+ (void)fetchRFRemoteDeviceWithYKCId:(NSString *)ykcId
                  remoteDeviceTypeId:(NSUInteger)typeId
                              subMac:(NSString *)deviceId
                   remoteDeviceBrand:(YKRemoteDeviceBrand *)brand
                          completion:(void (^)(YKRemoteMatchDevice *, NSArray<YKRemoteMatchDeviceKey *> *,NSError *))completion;


/// 绑定美亚设备
/// @param mac 遥控中心 mac地址
/// @param suffix 内部分类头
/// @param completion 回调
+(void)mpeBind:(NSString *)mac catSuffix:(NSString *)suffix completion:(void (^__nullable)(BOOL flag,NSString * __nullable mac,NSString * __nullable subMac))completion;

/// 查询美亚设备上报
/// @param remoteDevice 已创建的遥控器
/// @param completion 回调
+(void)mpeStatus:(YKRemoteDevice *)remoteDevice handler:(void (^__nullable)(BOOL flag,NSString * __nullable mac,NSString * __nullable subMac,NSDictionary * __nullable mpeInfo))completion;

/**
 导出遥控小苹果列表

 @return json字符串
 */
+ (NSString *)exportYKDevice;

/**
导入小苹果列表（）
@param jsonStr 符合格式的json字符串
*/
+(void)importYKDevce:(NSString *)jsonStr;
/**
 获取 SDK 版本号

 @return SDK 版本号
 */
+ (NSString *)sdkVersion;


@end

NS_ASSUME_NONNULL_END

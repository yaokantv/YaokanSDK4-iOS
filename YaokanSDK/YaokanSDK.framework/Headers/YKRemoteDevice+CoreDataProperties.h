//
//  YKRemoteDevice+CoreDataProperties.h
//  YKCenterSDK
//
//  Created by Don on 2017/2/21.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "YKRemoteDevice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YKRemoteDevice (CoreDataProperties)

+ (NSFetchRequest<YKRemoteDevice *> *)fetchRequest;

@property (nonatomic) int64_t brandId;
@property (nonatomic) int64_t codeset;
@property (nullable, nonatomic, copy) NSString *controllerModel;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *device_id;
@property (nullable, nonatomic, copy) NSString *localId;
@property (nullable, nonatomic, copy) NSString *modelName;

/// 遥控器名称
@property (nullable, nonatomic, copy) NSString *name;


/// 遥控器rid
@property (nullable, nonatomic, copy) NSString *remoteId;
@property (nullable, nonatomic, copy) NSString *rf_body;

/// 遥控器显示名称(roomName+name)
@property (nullable, nonatomic, copy) NSString *showName;
@property (nullable, nonatomic, copy) NSString *rc_command;
@property (nullable, nonatomic, copy) NSString *study_Id;
@property (nonatomic) int64_t typeId;
@property (nullable, nonatomic, copy) NSDate *updateTime;
@property (nonatomic) int16_t version;

/// 遥控器绑定的设备(小苹果的mac地址)
@property (nullable, nonatomic, copy) NSString *ykcId;
@property (nonatomic) int16_t zip;
@property (nullable, nonatomic, retain) NSOrderedSet<YKRemoteDeviceKey *> *keys;

/// 房间名
@property (nullable, nonatomic, copy) NSString *roomName;
@end

@interface YKRemoteDevice (CoreDataGeneratedAccessors)

- (void)insertObject:(YKRemoteDeviceKey *)value inKeysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromKeysAtIndex:(NSUInteger)idx;
- (void)insertKeys:(NSArray<YKRemoteDeviceKey *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeKeysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInKeysAtIndex:(NSUInteger)idx withObject:(YKRemoteDeviceKey *)value;
- (void)replaceKeysAtIndexes:(NSIndexSet *)indexes withKeys:(NSArray<YKRemoteDeviceKey *> *)values;
- (void)addKeysObject:(YKRemoteDeviceKey *)value;
- (void)removeKeysObject:(YKRemoteDeviceKey *)value;
- (void)addKeys:(NSOrderedSet<YKRemoteDeviceKey *> *)values;
- (void)removeKeys:(NSOrderedSet<YKRemoteDeviceKey *> *)values;

@end

NS_ASSUME_NONNULL_END

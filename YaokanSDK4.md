# Yaokan SDK4 iOS 说明文档


  文件编号：YAOKANSDK4IOS
  版本：v1.0.8

  深圳遥看科技有限公司
  （版权所有，切勿拷贝）



| 版本 | 说明 | 备注 | 日期 |
| --- | --- | --- | --- |
| v1 | 新建 | yaokan | 20200527 |
| v1.0.1 | 扩展其他产品配网 | yaokan | 20200617 |
| v1.0.3 | 支持美亚床椅 | yaokan | 20200813 |
| v1.0.4 | 增加手机热点配网 | yaokan | 20200828 |
| v1.0.5 | 增加参数配网 | yaokan | 20200903 |
| v1.0.6 | 添加设置设备音量 | yaokan | 20210831 |
| v1.0.7 | 支持控制设备麦克风启用/禁用 | alex | 20220121 |
| v1.0.8 | 更新SDK,修复iOS SmartConfig 配网失败问题 | alex | 20221216 |

## 1. 概述
YaokanSDK4 提供设备配网，设备管理，遥控器管理功能，实现与App对接的目的。

![image](https://github.com/yaokantv/YaokanSDK3-Android/raw/master/img/net_config.png)

![image](https://github.com/yaokantv/YaokanSDK3-Android/raw/master/img/create_rc.png)

![image](https://github.com/yaokantv/YaokanSDK3-Android/raw/master/img/create_stb.png)


## 2. 文档阅读对象
使用 YaokanSDK4 iOS 版的开发者

## 3. 接入

需要先向商务申请 `APP_ID`

### 3.1 集成
  打开终端,执行pod install,打开YaokanSDK4-iOS.xcworkspace即可

  需要在info里添加
```objc
<key>NSLocalNetworkUsageDescription</key>
<string>APP将使用到你的本地网络来进行设备配网</string>
<key>NSBonjourServices</key>
<array>
    <string>_yklink._tcp.</string>
</array>
```

  ~~1. 打开 `[your_project].xcodeproj`, 选择 Target `[your_target_name]` 打开 General 标签项。~~

  ~~2. 在 `Embedded Binaries` 中点击 `+` 号，点击 `Add Other..` 打开 `YaokanSDK` 目录选择 `YaokanSDK.framework` 和 `CocoaAsyncSocket.framework` `MQTTClient.framework` `SocketRocket.framework` 。
    直接将这4个文件拖进 `Embedded Binaries` 一样可以。~~

  本SDK 最低支持版本为 iOS 11.0 
## 4. API 列表

### 4.1 初始化接口

  1. 注册SDK
      ```objc  
      [YaokanSDK registApp:YOUR_APP_ID secret:YOUR_APP_SEC completion:^(NSError * _Nonnull error) {

      }];
      ```

### 4.2 设备接口    

1. 配置入网<br>
      在  `[your_project].xcodeproj`, 选择 Target `[your_target_name]` <br>打开 Capabilities  标签项 打开<br>Acces WiFi Information <br> Hotspot Configuration<br> 
       
      注意： iOS 13起获取SSID之前需要定位权限。<br>softAP 配网过程会出现两次切换Wi-Fi的弹框(这是iOS系统弹出的),<br>为确保配网顺利,必须告知用户
      按 "加入" 
      ```objc   
      [YaokanSDK bindYKCV2WithSSID:@"2.4G-WIFI-SSID" password:@"wifipassword" deviceType:ConfigDeviceLA configType:ConfigTypeAP completion:^(NSError * _Nullable error, YKDevice * _Nullable device) {

        }];
      
      /*
      deviceType传参说明：
        接入产品为 遥控大师小苹果  传 枚举常量 ConfigDeviceLA
                 遥控大师大苹果  传 枚举常量 ConfigDeviceBA
                 遥控大师空调伴侣 传 枚举常量 ConfigDeviceAC
      configType：
        softAP配网 传枚举常量 ConfigTypeAP
        SmartConfig配网  传枚举常量 ConfigTypeSmart
        
        
        *手机热点配网  传枚举常量 ConfigTypeMobileAP
            此时 SSID和password 可以不传或传空字符串
            
            如果手机开启热点后一段时间没设备连接上的，iPhone 会自动关闭热点Wi-Fi。重新进入 "设置-个人热点"，将再次开启。
            配网程序和手机热点必须是同一台手机，不支持跨手机。
        
            *手机热点配网功能仅 仅限个别产品，更多详情与本公司联系。
            您的手机能否开启 个人热点 功能取决于您使用的运营商，
            如没有 或是开启后没无法上网的请与您使用的运营商联系。
        
       参数配网  传枚举常量 ConfigTypeMobileParam 
            此时 SSID和password 可以不传或传空字符串
            如需对接此功能请与本公司联系。
      */
      ```

1. 获取设备列表

    ```objc
    [YaokanSDK fetchBoundYKC:^(NSArray<YKDevice *> * _Nonnull devices, NSError *error) {


    }];
    ```
1. 导入设备列表

    ```objc
    [YaokanSDK importYKDevce:@"[{\"did\":\"A64D184C35EAB091\",\"rf\":\"1\",\"mac\":\"BCDDC289CCE2\",\"type\":\"YKK_1011-RF\",\"version\":\"1.1.6\"},{\"did\":\"23C81FD441D21AB8\",\"rf\":\"0\",\"mac\":\"DC4F22529F13\",\"type\":\"YKK_1011\",\"version\":\"1.1.6\"}]"];   
    ```
1. 导出设备列表

    ```objc
    //返回json字符串
    [YaokanSDK exportYKDevice];
    ```
1. 设备测试

    ```objc
    [YaokanSDK toogleLEDWithYKCId:@"targetMacAddr"];
    ```
1. 获取设备信息

    ```objc
    [YaokanSDK deviceInfo:@"INPUTYOURMAC" completion:^(BOOL flag, NSDictionary * _Nonnull info) {
        
    }];

    ```
1. 停止学习(已创建的遥控器 传 YKRemoteDevice 类型)

    ```objc
    [YaokanSDK learnStopWithRemote:(YKRemoteDevice *)remote];
    
    ```
    
1. 停止学习(匹配对码阶段 传 YKRemoteMatchDevice 类型)

    ```objc
    [YaokanSDK learnStopWithMatchRemote:(YKRemoteMatchDevice *)matchRemote];
    
    ```
    
1. 设备开灯、关灯

    ```objc
    [YaokanSDK turnOnLEDWithYKCId:@"targetMacAddr"];
    [YaokanSDK turnOffLEDWithYKCId:@"targetMacAddr"];
    ```

1. 设备设置音量

    ```objc
    /** 
     * voice 音量,取值0-20
     * Mac 要设置的设备mac  
     */
    [YaokanSDK setVoice:voice WithYKCId:mac];
    ```
1. 设备启用麦克风

     ```objc
    [YaokanSDK enableMicWithYKCId:mac];
    ```
1. 设备禁用麦克风

     ```objc
    [YaokanSDK disableMicWithYKCId:mac];
    ```
1. 硬件升级OTA

    ```objc
    [YaokanSDK firmwareUpdateWithYKCId:@"targetMacAddr"];
    ```

1. 获取硬件版本

    ```objc
    [YaokanSDK checkDeviceVersion:(NSString *)ykcId
        completion:(void (^__nullable)(NSString *version,NSString *otaVersion,NSError *error)){

    }];
    ```

1. 设备复位

    ```objc
    // 复位后进入 SmartConfig
    [YaokanSDK restoreWithYKCId:@"targetMacAddr"];
    
    // 复位后进入SoftAP 
    [YaokanSDK restoreWithYKCId:@"targetMacAddr"];
    
    ```

### 4.2 遥控器接口
1. 获取被遥控设备类型列表

    ```objc
    [YaokanSDK fetchRemoteDeviceTypeWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] completion:^(NSArray<YKRemoteDeviceType *> * _Nonnull types, NSError * _Nonnull error) {

    }];
    
    
    /* 
      YKRemoteDeviceType 的tid 说明 参考  
      <YaokanSDK/YaokanSDKHeader.h> 
      枚举常量 RemoteDeviceType 
    */
    ```

    
1. 获取设备品牌

    ```objc
    [YaokanSDK fetchRemoteDeviceBrandWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
              remoteDeviceTypeId:self.deviceType.tid.integerValue
                 completion:^(NSArray<YKRemoteDeviceBrand *> * _Nonnull brands,
                        NSError * _Nonnull error)
    {
    }];
    ```

1. 进入一级匹配(非空调)

    ```objc
    [YaokanSDK requestFirstMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
        remoteDeviceTypeId:tid
        remoteDeviceBrandId:self.deviceBrand.bid
        completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
     }];
    ```

1. 进入二级匹配(非空调)

    ```objc
    [YaokanSDK requestSecondMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
        remoteDeviceTypeId:_tid
        remoteDeviceBrandId:_bid group:_gid
        completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        if (mathes.count > 0) {
        }
    }];
    ```
1. 逐个匹配
    ```objc
    [YaokanSDK fetchMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
            remoteDeviceTypeId:_deviceType.tid.integerValue
            remoteDeviceBrandId:_deviceBrand.bid
            completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error)
            {

    }];
    
    ```
1. 已有遥控器发码(不适用于空调)

    ```objc
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remoteDevice  cmdkey:@"按键名"
          completion:^(BOOL result, NSError * _Nonnull error) {


    }];
    ```
    
1. 匹配阶段发码(不适用于空调)

    ```objc
    [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remoteDevice  cmdkey:@"按键名"
          completion:^(BOOL result, NSError * _Nonnull error) {


    }];
    ```
1. 空调发码( 如果是操控 扫风功能的需求请其他的API )

    ```objc
    [YaokanSDK sendACWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```

1. 空调上下扫风发码

    ```objc
    [YaokanSDK sendAcWindUDWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```

1. 空调左右扫风发码

    ```objc
    [YaokanSDK sendAcWindUDWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```

1. 学习红外和射频(已创建遥控器 传 YKRemoteDevice  类型对象)

    ```objc
    [YaokanSDK learnWithRemote:YKRemoteDevice key:@"yourLearnKey"
        completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {

    }];
    
    ```
    
1. 对码阶段学习射频(传 YKRemoteMatchDevice 类型)

    ```objc
    [YaokanSDK learnRFWithMatchRemote:YKRemoteMatchDevice key:@"yourLearnKey"    
        completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
            
    }];
    
    ```

1. 匹配阶段空调发码
    ```objc
    [YaokanSDK sendMatchACWithYKCId:ykcId
                    remoteDevice:remoteDevice
                        withMode:mode
                            temp:temp
                           speed:speed
                           windU:windU
                           windL:windL
                      completion:(BOOL result, NSError *error))completion{
            {
    }];
    
    ```
1. 匹配阶段空调上下风
    ```objc
    [YaokanSDK sendMatchAcWindUDWithYKCId:ykcId
            remoteDevice:matchDevice
                withMode:mode
                    temp:temp
                   speed:speed
                   windU:windU
                   windL:windL
              completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```
1. 匹配阶段空调左右风
    ```objc
    [YaokanSDK sendMatchAcWindLRWithYKCId:ykcId
            remoteDevice:matchDevice
                withMode:mode
                    temp:temp
                   speed:speed
                   windU:windU
                   windL:windL
              completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    
    ```
1. 保存遥控器

    ```objc
     [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]  
    matchDevice:matchDevice completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {

    }];
    
    ```

1. 删除遥控器

    ```objc
    + (void)removeRemoteDeivceWithYKCId:(NSString *)ykcId
      remote:(YKRemoteDevice *)remote
      completion:(void (^__nullable)(NSError *error))completion;
      
    ```

1. 获取遥控器详情

    ```objc
    + (void)requestRemoteDeivceWithYKCId:(NSString *)ykcId
             remoteDeviceTypeId:(NSUInteger)typeId
               remoteDeviceId:(NSString *)remoteDeviceId
                completion:(void (^__nullable)(NSArray *matchKeys, NSError *error))completion;
                
    ```

1. 获取遥控器列表

    ```objc
    [YKRemoteDevice modelsWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]];
    ```

1. 导出单个遥控器JSON数据

    ```objc
        YKRemoteDevice 实例方法
    - (NSDictionary *)toJsonObject;
    ```
1. 导入遥控器( dict为 NSDictionary类型 ,json 必须通过 上面的导出方法的数据或是 获取遥控器详情 的API拿到)

    ```objc
     NSString * remoteJson = @"[{\"name\":\"艾美特 Airmate风扇 FSW62R\",\"rid\":\"20150908160034\",\"rmodel\":\"FSW62R\",\"be_rmodel\":\"FSW62R\",\"be_rc_type\":6,\"bid\":1445,\"mac\":\"DC4F22529F13\",\"rf\":\"0\",\"rf_body\":\"\",\"rc_command_type\":1,\"study_id\":\"0\",\"rc_command\":{\"mode\":{\"name\":\"模式\",\"value\":\"mode\",\"stand_key\":1,\"order_no\":1},\"timer\":{\"name\":\"定时\",\"value\":\"timer\",\"stand_key\":1,\"order_no\":1},\"fanspeed\":{\"name\":\"风速\",\"value\":\"fanspeed\",\"stand_key\":1,\"order_no\":1},\"oscillation\":{\"name\":\"摇头\",\"value\":\"oscillation\",\"stand_key\":1,\"order_no\":1},\"power\":{\"name\":\"电源\",\"value\":\"power\",\"stand_key\":1,\"order_no\":1},\"fanspeed-\":{\"name\":\"风速-\",\"value\":\"fanspeed-\",\"stand_key\":0,\"order_no\":1},\"timer-\":{\"name\":\"定时-\",\"value\":\"timer-\",\"stand_key\":0,\"order_no\":1},\"timer+\":{\"name\":\"定时+\",\"value\":\"timer+\",\"stand_key\":0,\"order_no\":1},\"fanspeed+\":{\"name\":\"风速+\",\"value\":\"fanspeed+\",\"stand_key\":0,\"order_no\":1}}}]";
    [YKRemoteDevice importRemotes:remoteJson];
    ```

1. 导出遥控器列表

    ```objc
    //返回JSON数组字符串
    [YKRemoteDevice exportRemotes];
    ```

1. 电量统计

    ```objc
    + (void)fetchPowerQueryWithYKCId:(NSString *)ykcId
                         unit:(NSString *)unit
                           timeBegin:(NSString *)timeBegin
                           timeEnd:(NSString *)timeEnd
                          completion:(void (^__nullable)(NSArray<YKAirPower *> *brands, NSError *error))completion;
    ```
    
### 4.3    SDK错误码表
主要列出了调用SDK的时候，SDK回调返回的错误码信息

| 值 | 代码 | 说明 |
| --- | --- | --- |
| 0 | YKSDK_SUCC | 操作成功 |
| 1001 | YKSDK_APPID_INVALID | APPID无效 |
| 1002 | YKSDK_SMARTCONFIG_TIMEOUT  | 设备配置超时 |
| 1003 | YKSDK_CONFIG_TIMEOUT  | 配网超时 |
| 1004 | YKSDK_DEVICE_REG_TIMEOUT  | 注册设备超时 |
| 1005 | YKSDK_DEVICE_CONFIG_MOBILEAP_NOT_FOUND_ERROR  | 热点配网失败，手机热点未开启 |
| 1006 | YKSDK_DEVICE_GET_PARAM_ERROR  | 参数配网失败 |

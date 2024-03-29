//
//  YKConfigWaitingController.m
//  YKCenterDemo
//
//  Created by Don on 2017/1/16.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKConfigWaitingController.h"
#import "UAProgressView.h"
#import "YKCenterCommon.h"
#import <YaokanSDK/YaokanSDK.h>

#import <NetworkExtension/NEHotspotConfigurationManager.h>

#define CONFIG_TIMEOUT      60

@interface YKConfigWaitingController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timeout;

@property (weak, nonatomic) IBOutlet UILabel *textTips;
@property (weak, nonatomic) IBOutlet UILabel *textTimeoutTips;

@property (weak, nonatomic) IBOutlet UAProgressView *progressView;

@end

@implementation YKConfigWaitingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.progressView.centralView = label;
    self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    [self.progressView setProgress:0.1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timeout = CONFIG_TIMEOUT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    YKCenterCommon *dataCommon = [YKCenterCommon sharedInstance];
    
    if (ConfigTypeParam == _configType) {
        [YaokanSDK bindYKWithParameterHander:^(NSString * _Nullable registInfo, NSError * _Nullable ret) {
            //获取注册data 
            NSLog(@"%@",registInfo);
            
        } completion:^(NSError * _Nullable error, YKDevice * _Nullable device) {
            if (device  && error == nil) {
                [self onConfigSucceed:nil];
            }else{
                [self showAlert:error.userInfo.description];
            }
        }];
        return;
    }
    
    if (YKGetCurrentSSID().length >= 0) {
        NSString *key = [dataCommon getPasswrodFromSSID:dataCommon.ssid];

        [YaokanSDK bindYKCV2WithSSID:dataCommon.ssid password:key deviceType:_deviceType configType:_configType completion:^(NSError * _Nullable error, YKDevice * _Nullable device) {
            NSLog(@"33-%@", error.userInfo.description);

            if (device && error == nil) {
                [self onConfigSucceed:nil];
            }else{
                [self showAlert:error.userInfo.description];
            }
        }];
        

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            usleep(500000);//0.5s
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"Device is not connected to Wi-Fi, can not configure", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//                [self onPushToSoftapFailed];
            });
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [GizWifiSDK sharedInstance].delegate = nil;
    [self.timer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimeout:(NSInteger)timeout {
    
    _timeout = timeout;
    
    float timeNow = (CONFIG_TIMEOUT-timeout);
    float secOffset = (1.0f * timeNow)/CONFIG_TIMEOUT;
    [self.progressView setProgress:secOffset animated:YES];
//    [self.progressView setProgress:(CONFIG_TIMEOUT-timeout)/((float)(CONFIG_TIMEOUT)) animated:YES];

    NSInteger elapsed = CONFIG_TIMEOUT-timeout;
    if (elapsed >= 1 && elapsed <= 8) {
        self.textTips.text = NSLocalizedString(@"Searching for devices", nil);
    } else if (elapsed >= 9 && elapsed <= 10) {
        self.textTips.text = NSLocalizedString(@"Searched to device", nil);
    } else if (elapsed >= 11 && elapsed <= CONFIG_TIMEOUT) {
        self.textTips.text = NSLocalizedString(@"Trying to connect with the device", nil);
        
        if (elapsed == (CONFIG_TIMEOUT - 1)) {
            __block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Bad network, switch to manual connection", nil) delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertView show];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self cancel];
                });
            });
        }
    } else {
        self.textTips.text = NSLocalizedString(@"Search for and connect the device", nil);
    }
    self.textTimeoutTips.text = [NSString stringWithFormat:@"%@ %i %@", NSLocalizedString(@"It is expected to need", nil), (int)timeout, NSLocalizedString(@"seconds", nil)];
}

- (void)onTimer {
    self.timeout--;
    if (0 == self.timeout) {
        [self.timer invalidate];
    }
}


- (void)onConfigSucceed:(YKDevice *)device {
    [self.timer invalidate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancel];
        });
    });
}

- (void)onConfigFailed {
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
//    [[GosCommon sharedInstance] cancelAlertViewDismiss];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Bad network, switch to manual connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//    [alertView show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancel];
        });
    });

}

- (void)onWillEnterForeground {
//    [self onConfigFailed];
}

static inline void SHOW_ALERT_CANCEL_CONFIG(id delegate) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"Discard your configuration?", nil) delegate:delegate cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
}

- (IBAction)onCancel:(id)sender {
    SHOW_ALERT_CANCEL_CONFIG(self);

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self cancel];
    }
}

- (void)cancel {
    [[YaokanSDK sharedInstance] stopBind];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"配网失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //        textField.placeholder = @"username";
    //        NSLog(@"username==%@",textField.text);
    //        textField.delegate = self;
    //    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cancel];
        NSLog(@"OK");
    }];
    
//    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}



@end

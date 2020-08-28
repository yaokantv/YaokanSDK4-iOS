//
//  YKConfigTipsController.m
//  YKCenterDemo
//
//  Created by Don on 2017/1/16.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKConfigTipsController.h"
#import "UIImageView+PlayGIF.h"
#import "YKConfigWaitingController.h"

@interface YKConfigTipsController ()

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIImageView *imgAirlink;

@property (weak, nonatomic) IBOutlet UILabel *lb;

@end

@implementation YKConfigTipsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.imgAirlink.gifPath = [[NSBundle mainBundle] pathForResource:@"02-airlink" ofType:@"gif"];
    if (ConfigTypeAP == _configType) {
        self.imgAirlink.gifPath = [[NSBundle mainBundle] pathForResource:@"AP" ofType:@"gif"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.imgAirlink startGIF];
    
    if (ConfigTypeSmart == _configType) {
       _lb.text = @"确保设备通电 并处于快闪状态";
        
    }else if (ConfigTypeMobileAP == _configType) {
       _lb.text = @"1.确保设备通电 并处于快闪状态 \n  2.确保 此手机已开启个人热点 \n *如果手机热点不是本台手机 将配网失败";
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.imgAirlink stopGIF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRadioButtonTouched:(UIButton *)sender {
    if (sender.isSelected) {
        if (self.btnNext.enabled) {
            sender.selected = NO;
            self.btnNext.enabled = NO;
            self.btnNext.backgroundColor = [UIColor lightGrayColor];
        } else {
            self.btnNext.enabled = YES;
            self.btnNext.backgroundColor = [UIColor blueColor];
        }
    }
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:@"showConfigSearch" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[YKConfigWaitingController class]]) {
        YKConfigWaitingController *vc = segue.destinationViewController;
        vc.deviceType = _deviceType;
        vc.configType = _configType;
    }
}

@end

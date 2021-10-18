//
//  YKViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/12.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKDeviceListViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKDevice.h>
#import "MBProgressHUD.h"
#import "YKDeviceListCell.h"

#import "YKCenterCommon.h"

@interface YKDeviceListViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *deviceListArray;

@end

@implementation YKDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getBoundDevice];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NotificationDeviceListUpdate
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NotificationDeviceListUpdate object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshBtnPressed:nil];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NotificationDeviceListUpdate
                                                      object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBtnPressed:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self getBoundDevice];
}

- (IBAction)actionSheet:(id)sender {
    UIActionSheet *actionSheet = nil;
    NSString *appVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Program Version", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sdkVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SDK Version", nil), [YaokanSDK sdkVersion]];
    

        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:[appVersion stringByAppendingFormat:@"-%@", sdkVersion]
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:
                       NSLocalizedString(@"Add Device", nil),
                       NSLocalizedString(@"Export Device List", nil),
                       NSLocalizedString(@"import Device List", nil),
                       NSLocalizedString(@"导入遥控器列表", nil),
                       NSLocalizedString(@"导出遥控器列表", nil),
                        nil];
    
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


- (void)getBoundDevice {
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK fetchBoundYKC:^(NSArray<YKDevice *> * _Nonnull devices, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.navigationController.view animated:YES];
        if (error) {
            NSLog(@"error:%@", error.localizedDescription);
            return;
        }

        strongSelf.deviceListArray = devices;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger offset = 0;
    //    if (![GizCommon sharedInstance].isLogin) {
    //        offset = -1;
    //    }
    if (buttonIndex == offset) {
         [self toAirLink:nil];
    }
    else if (buttonIndex == offset+1) {
        NSString *json =  [YaokanSDK exportYKDevice];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Export List Result", nil) message:json preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
        }];
        [alert addAction:ok];
        NSLog(@"%@",json);
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (buttonIndex == offset+2) {
//        NSString *json =  [YaokanSDK exportYKDevice];
//        NSLog(@"%@",json);
//        json = @"[{\"did\":\"8FAF4A06AC965CCE\",\"mac\":\"84F3EB1A0793\",\"type\":\"YKK-1013-RF\",\"rf\":\"1\"}]";
        NSString *json = @"[{\"did\":\"EE901971B8744FAC\",\"mac\":\"DC4F22529F13\",\"name\":\"YKK-1011\",\"rf\":\"0\"},{\"did\":\"6D65F33EBF1862C6\",\"mac\":\"84F3EB1A0793\",\"name\":\"YKK-1013-RF\",\"rf\":\"0\"}]";
        [YaokanSDK importYKDevce:json];

    }else if (buttonIndex == offset+3) {//导入遥控器
        NSString * remoteJson = @"[{\"name\":\"艾美特 Airmate风扇 FSW62R\",\"rid\":\"20150908160034\",\"rmodel\":\"FSW62R\",\"be_rmodel\":\"FSW62R\",\"be_rc_type\":6,\"bid\":1445,\"mac\":\"DC4F22529F13\",\"rf\":\"0\",\"rf_body\":\"\",\"rc_command_type\":1,\"study_id\":\"0\",\"rc_command\":{\"mode\":{\"name\":\"模式\",\"value\":\"mode\",\"stand_key\":1,\"order_no\":1},\"timer\":{\"name\":\"定时\",\"value\":\"timer\",\"stand_key\":1,\"order_no\":1},\"fanspeed\":{\"name\":\"风速\",\"value\":\"fanspeed\",\"stand_key\":1,\"order_no\":1},\"oscillation\":{\"name\":\"摇头\",\"value\":\"oscillation\",\"stand_key\":1,\"order_no\":1},\"power\":{\"name\":\"电源\",\"value\":\"power\",\"stand_key\":1,\"order_no\":1},\"fanspeed-\":{\"name\":\"风速-\",\"value\":\"fanspeed-\",\"stand_key\":0,\"order_no\":1},\"timer-\":{\"name\":\"定时-\",\"value\":\"timer-\",\"stand_key\":0,\"order_no\":1},\"timer+\":{\"name\":\"定时+\",\"value\":\"timer+\",\"stand_key\":0,\"order_no\":1},\"fanspeed+\":{\"name\":\"风速+\",\"value\":\"fanspeed+\",\"stand_key\":0,\"order_no\":1}}},{\"name\":\"艾科瑞 Aikerui电视盒子 a_1\",\"rid\":\"2019070409142462\",\"rmodel\":\"a_1\",\"be_rmodel\":\"a_1\",\"be_rc_type\":10,\"bid\":3189,\"mac\":\"84F3EB1A0793\",\"rf\":\"0\",\"rf_body\":\"\",\"rc_command_type\":1,\"study_id\":\"0\",\"rc_command\":{\"left\":{\"name\":\"左\",\"value\":\"left\",\"stand_key\":1,\"order_no\":1},\"power\":{\"name\":\"电源\",\"value\":\"power\",\"stand_key\":1,\"order_no\":1},\"up\":{\"name\":\"上\",\"value\":\"up\",\"stand_key\":1,\"order_no\":1},\"right\":{\"name\":\"右\",\"value\":\"right\",\"stand_key\":1,\"order_no\":1},\"boot\":{\"name\":\"主页\",\"value\":\"boot\",\"stand_key\":1,\"order_no\":1},\"menu\":{\"name\":\"菜单\",\"value\":\"menu\",\"stand_key\":1,\"order_no\":1},\"ok\":{\"name\":\"OK\",\"value\":\"ok\",\"stand_key\":1,\"order_no\":1},\"down\":{\"name\":\"下\",\"value\":\"down\",\"stand_key\":1,\"order_no\":1},\"vol-\":{\"name\":\"音量-\",\"value\":\"vol-\",\"stand_key\":1,\"order_no\":1},\"vol+\":{\"name\":\"音量+\",\"value\":\"vol+\",\"stand_key\":1,\"order_no\":1}}}]";


        BOOL result =  [YKRemoteDevice importRemotes:remoteJson];
        NSLog(@"1%d",result);

    }else if (buttonIndex == offset+4) {
        NSString *remotes =  [YKRemoteDevice exportRemotes];
        NSLog(@"1-%@",remotes);
    }
}

- (IBAction)toAirLink:(id)sender {
    [self performSegueWithIdentifier:@"toAirLink" sender:nil];
}

- (void)showAbout {
//    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"GosSettings" bundle:nil] instantiateInitialViewController];
//    GosSettingsViewController *settingsVC = nav.viewControllers.firstObject;
//    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[self.deviceListArray objectAtIndex:indexPath.section] count] == 0) {
//        return 60;
//    }
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceListArray.count;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) return NSLocalizedString(@"Bound devices", nil);
//    else if (section == 1) return NSLocalizedString(@"Discovery of new devices", nil);
//    else return NSLocalizedString(@"Offline devices", nil);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKDeviceListCell" owner:self options:nil] lastObject];
                UILabel *lanLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 110, 0, 74, 80)];
                lanLabel.textAlignment = NSTextAlignmentRight;
                lanLabel.tag = 99;
                [cell addSubview:lanLabel];
    }
    
    NSArray *devArr = self.deviceListArray;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    if ([devArr count] > 0) {
        YKDevice *dev = [devArr objectAtIndex:indexPath.row];
//        NSString *devName = dev.alias;
//        if (devName == nil || devName.length == 0) {
//            devName = dev.productName;
//        }
        cell.title.text = dev.productName;
        [self customCell:cell device:dev];
        cell.imageView.hidden = NO;
        cell.textLabel.text = @"";
    }
    else {
        cell.textLabel.text = NSLocalizedString(@"No device", nil);
        cell.mac.text = @"";
        cell.lan.text = @"";
        [cell.imageView setImage:nil];
    }
    return cell;
}

- (void)customCell:(YKDeviceListCell *)cell device:(YKDevice *)dev {
    // 添加左边的图片
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"08-icon-Device"]];
    CGRect frame = subImageView.frame;
    
    //将图片居中
    frame.origin = CGPointMake(4, 9);
    subImageView.frame = frame;
    
    [cell.imageView addSubview:subImageView];
    cell.imageView.image = blankImage;
    cell.imageView.layer.cornerRadius = 10;
    
    cell.mac.text = dev.macAddress;
    
    if (dev.netStatus == 1 || dev.netStatus == 2) {
        cell.imageView.backgroundColor = [UIColor brownColor];
        
        cell.lan.text = @"在线";
    }
    else {
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
        cell.lan.text = @"离线";
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    YKDevice *dev = self.deviceListArray[indexPath.row];
    [YaokanSDK toogleLEDWithYKCId:dev.macAddress];
//    [YaokanSDK firmwareCheckWithYKCId:dev.macAddress];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YKDevice *dev = self.deviceListArray[indexPath.row];
    [YKCenterCommon sharedInstance].currentYKCId = dev.macAddress;
    
    [self performSegueWithIdentifier:@"YKRemoteList" sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YKDevice *dev = self.deviceListArray[indexPath.row];
        __weak __typeof(self)weakSelf = self;
        
        //复位后进入 SoftAp 配网
        [YaokanSDK restoreToApWithYKCId:dev.macAddress];
        
        
        //复位后进入SmartConfig
//        [YaokanSDK restoreWithYKCId:dev.macAddress];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf refreshBtnPressed:nil];
        });
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Reset", nil);
}


@end

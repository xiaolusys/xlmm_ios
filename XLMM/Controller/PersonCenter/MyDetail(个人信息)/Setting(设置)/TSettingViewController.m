//
//  TSettingViewController.m
//  XLMM
//
//  Created by zhang on 16/4/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TSettingViewController.h"
#import "VersionController.h"
#import "MMClass.h"
#import "MiPushSDK.h"

@interface TSettingViewController ()<MiPushSDKDelegate>

@end

@implementation TSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"TSettingViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"TSettingViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavigationBarWithTitle:@"设置" selecotr:@selector(backClicked:)];
    
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.deleteButton.layer.cornerRadius = 13;
    
    [self setcacheSize];
    [self setAppInfo];
    
    [self pushOn];
}
- (void)pushOn {
    
    UILabel *pushMessage = [UILabel new];
    [self.pushOnView addSubview:pushMessage];
    pushMessage.font = [UIFont systemFontOfSize:14.];
    pushMessage.text = @"接收推送通知";
    pushMessage.textColor = [UIColor buttonTitleColor];
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [self.pushOnView addSubview:switchButton];
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kIsReceivePushTZ];
    if ([string isEqualToString:@"1"] || string == nil) {
        switchButton.on = YES;
    }else {
        switchButton.on = NO;
    }
    [switchButton addTarget:self action:@selector(pushMessageOn:) forControlEvents:UIControlEventValueChanged];
//    if ([self isAllowedNotification]) {
//        [switchButton addTarget:self action:@selector(pushMessageOn:) forControlEvents:UIControlEventValueChanged];
//    }else {
//        [MiPushSDK unregisterMiPush];
//    }

    kWeakSelf
    [pushMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.pushOnView).offset(15);
        make.centerY.equalTo(weakSelf.pushOnView.mas_centerY);
    }];
    
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.pushOnView).offset(-15);
        make.centerY.equalTo(weakSelf.pushOnView.mas_centerY);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@30);
    }];

}

- (void)pushMessageOn:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kIsReceivePushTZ];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [MiPushSDK registerMiPush:self type:0 connect:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openPushMessageSwitch" object:nil];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kIsReceivePushTZ];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MiPushSDK unregisterMiPush];
    }

    
}

- (void)setcacheSize{
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"path = %@", path);
    
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog(@"file size = %@",[dict objectForKey:NSFileSize]);
    float sizeValue = [[dict objectForKey:NSFileSize] integerValue]/200.0f;
    if (sizeValue < 1.0) {
        sizeValue = 0.0f;
    }
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM", sizeValue];
}

// 获取当前版本号。。。。。。。 与appStore 版本号比较 自动更新。。。。
- (void)setAppInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    MMLOG(infoDictionary);
    // app名称
    __unused NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    MMLOG(app_Name);
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    MMLOG(app_Version);
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    MMLOG(app_build);
    NSString *versionString = [NSString stringWithFormat:@"V%@.%@", app_Version, app_build];
    self.versionLabel.text = versionString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)versionButtonClicked:(id)sender {
    VersionController *versionVC = [[VersionController alloc] initWithNibName:@"VersionController" bundle:nil];
    versionVC.versionString = self.versionLabel.text;
    [self.navigationController pushViewController:versionVC animated:YES];
}

- (IBAction)deleteButtonClicked:(id)sender {
    NSLog(@"清除缓存");
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alterView.tag = 222;
    alterView.delegate = self;
    
    [alterView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 222) {
        if (buttonIndex == 1) {
            [self clearTmpPics];
            [self performSelector:@selector(alterMessage) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(setcacheSize) withObject:nil afterDelay:2.0f];
            
        }
    }
}
- (void)alterMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"缓存清理完成！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)isAllowedNotification {
    if ([self isSystemVersioniOS8]) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
        
    }else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != type) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSystemVersioniOS8 {
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}




































@end










































































































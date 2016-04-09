//
//  SettingViewController.m
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SettingViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "AddressViewController.h"
#import "UIImageView+WebCache.h"
#import "ChangeNicknameViewController.h"
#import "SetPasswordViewController.h"
#import "ModifyPhoneController.h"
#import "VerifyPhoneViewController.h"
#import "VersionController.h"
#import "WXLoginController.h"
#import "ThirdAccountViewController.h"
#import "TSettingViewController.h"




@interface SettingViewController ()<UIAlertViewDelegate>{
    
    NSString *phoneNumber;
    NSString *mobile;
    
}

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"个人信息" selecotr:@selector(backClicked:)];
    
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.borderWidth = 1;
    
    [self setUserInfo];
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUserInfo{
   // http://m.xiaolu.so/rest/v1/users
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/users.json", Root_URL];
    NSLog(@"urlStr = %@", urlStr);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    NSDictionary *result = [[dic objectForKey:@"results"] firstObject];
    NSString *nick = [result objectForKey:@"nick"];
    phoneNumber = [result objectForKey:@"mobile"];
    
    NSMutableString * mutablePhoneNumber = [phoneNumber mutableCopy];
    NSRange range = {3,4};
    if (mutablePhoneNumber.length == 11) {
    [mutablePhoneNumber replaceCharactersInRange:range withString:@"****"];
    }
    
    NSLog(@"nicknaem -> %@", nick);
    NSLog(@"phoneNumber = %@", phoneNumber);
    
    self.nameLabel.text = nick;
    self.phoneLabel.text = mutablePhoneNumber;
    
    //头像信息
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[result objectForKey:@"thumbnail"]]];
    
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nickButtonClicked:(id)sender {
    ChangeNicknameViewController *changeNicknameView = [[ChangeNicknameViewController alloc] initWithNibName:@"ChangeNicknameViewController" bundle:nil];
    changeNicknameView.nickNameText = self.nameLabel.text;
    
    [self.navigationController pushViewController:changeNicknameView animated:YES];

    //NSLog(@"用户昵称");
}

- (void)ishavemobel{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    mobile = [dic objectForKey:@"mobile"];
    NSLog(@"mobel = %@", mobile);
    
}

- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"手机号");
    //return;
     
    [self ishavemobel];
    if ([mobile isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginMethod] isEqualToString:kWeiXinLogin]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
        ;
        NSLog(@"请绑定手机");
        WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
        wxloginVC.userInfo = dic;
        [self.navigationController pushViewController:wxloginVC animated:YES];
    }
    
 }

- (IBAction)modifyButtonClicked:(id)sender {
    NSLog(@"修改密码");
//    SetPasswordViewController *setPasswordVC = [[SetPasswordViewController alloc] init];
//    [self.navigationController pushViewController:setPasswordVC animated:YES];
    NSLog(@"忘记密码");
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
    verifyVC.config = @{@"title":@"请验证手机",@"isUpdateMobile":@YES};
    [self.navigationController pushViewController:verifyVC animated:YES];
    
}

- (IBAction)addressButtonClicked:(id)sender {
    NSLog(@"地址管理");
    AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    addressVC.isSelected = NO;
    [self.navigationController pushViewController:addressVC animated:YES];
    
}


- (IBAction)thirdAccountBind:(id)sender {
    ThirdAccountViewController *third = [[ThirdAccountViewController alloc] initWithNibName:@"ThirdAccountViewController" bundle:nil];
    [self.navigationController pushViewController:third animated:YES];
}

- (IBAction)settingBtnClick:(id)sender {
    TSettingViewController *set = [[TSettingViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

- (IBAction)quitBtnAction:(id)sender {
    //退出
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"login"];
    [userDefaults setObject:@"unlogin" forKey:kLoginMethod];
    
    [userDefaults setBool:NO forKey:@"isXLMM"];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    
    //   http://m.xiaolu.so/rest/v1/users/customer_logout
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
    // NSLog(@"urlString = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    __unused NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    //发送通知修改NewLeft中的用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"quit" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:@{@"alterView":alterView} repeats:NO];
    
    [alterView show];

}

-(void) performDismiss:(NSTimer *)timer
{
    UIAlertView *Alert = [timer.userInfo objectForKey:@"alterView"];
    [Alert dismissWithClickedButtonIndex:0 animated:NO];
}


+ (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
+ (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}


@end

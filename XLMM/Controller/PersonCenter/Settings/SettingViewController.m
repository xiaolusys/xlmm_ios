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
    [self createNavigationBarWithTitle:@"设置" selecotr:@selector(backClicked:)];
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.deleteButton.layer.cornerRadius = 13;

    [self setcacheSize];
    [self setUserInfo];
    
    [self setAppInfo];
    
    
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
    
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
}



- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (IBAction)versionButtonClicked:(id)sender {
    NSLog(@"版本号");
    
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

- (IBAction)thirdAccountBind:(id)sender {
    ThirdAccountViewController *third = [[ThirdAccountViewController alloc] initWithNibName:@"ThirdAccountViewController" bundle:nil];
    [self.navigationController pushViewController:third animated:YES];
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

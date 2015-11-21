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
#import "ModifyPasswordViewController.h"
#import "ModifyPhoneController.h"
#import "UIImageView+WebCache.h"
#import "ChangeNicknameViewController.h"

@interface SettingViewController (){
    
    NSString *phoneNumber;
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
    self.deleteButton.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    self.deleteButton.layer.cornerRadius = 13;

    
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"path = %@", path);
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog(@"%@",[dict objectForKey:NSFileSize]);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        
     
        
        
        NSLog(@"%llu",  [[manager attributesOfItemAtPath:cachesDir error:nil] fileSize]);
    }

    NSLog(@"caches = %@", cachesDir);
    //清空缓存
   // [self clearTmpPics];
    
    [self setUserInfo];
    
}

- (void)setUserInfo{
   // http://m.xiaolu.so/rest/v1/users
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/users.json", Root_URL];
    NSLog(@"urlStr = %@", urlStr);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    NSDictionary *result = [[dic objectForKey:@"results"] firstObject];
    NSString *nick = [result objectForKey:@"nick"];
    phoneNumber = [result objectForKey:@"mobile"];
    
    NSMutableString * mutablePhoneNumber = [phoneNumber mutableCopy];
    NSRange range = {3,4};
    [mutablePhoneNumber replaceCharactersInRange:range withString:@"****"];
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

- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"手机号");
    ModifyPhoneController *modifyVC = [[ModifyPhoneController alloc] initWithNibName:@"ModifyPhoneController" bundle:nil];
    modifyVC.numberString = phoneNumber;
    [self.navigationController pushViewController:modifyVC animated:YES];
}

- (IBAction)modifyButtonClicked:(id)sender {
    NSLog(@"修改密码");
    ModifyPasswordViewController *modifyVC = [[ModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyVC animated:YES];
    
    
}

- (IBAction)addressButtonClicked:(id)sender {
    NSLog(@"地址管理");
    AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

- (IBAction)versionButtonClicked:(id)sender {
    NSLog(@"版本号");
}

- (IBAction)deleteButtonClicked:(id)sender {
    NSLog(@"清除缓存");
    [self clearTmpPics];
}


@end

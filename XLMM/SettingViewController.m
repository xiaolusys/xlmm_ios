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


@interface SettingViewController ()

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
    self.deleteButton.layer.cornerRadius = 16;
    self.quitBUtton.layer.cornerRadius = 20;
    self.quitBUtton.layer.borderWidth = 1;
    self.quitBUtton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    
    
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
    NSLog(@"用户昵称");
}

- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"手机号");

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
}

- (IBAction)quitButtonClicked:(id)sender {
    NSLog(@"退出");
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

//
//  ThirdAccountViewController.m
//  XLMM
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ThirdAccountViewController.h"

@interface ThirdAccountViewController ()

@end

@implementation ThirdAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ThirdAccount"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"ThirdAccount"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self createNavigationBarWithTitle:@"第三方账户绑定" selecotr:@selector(backBtnClicked:)];
    [self setdisableButton:self.bindWX];
    [self setdisableButton:self.qqbutton];
    [self setdisableButton:self.weibobutton];
    [self setdisableButton:self.zhifubaobutton];
    
}

- (void)setdisableButton:(UIButton *)button{
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bindWXAction:(id)sender {
    //实现微信授权
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该功能暂未开放，请等待。。。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
//    if (0) {
//        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要解除绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alterView.tag = 222;
//        alterView.delegate = self;
//        
//        [alterView show];
//    }
}
@end

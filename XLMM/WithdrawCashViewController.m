//
//  WithdrawCashViewController.m
//  XLMM
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "WithdrawCashViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"

@interface WithdrawCashViewController ()

@end

@implementation WithdrawCashViewController
{
    UIView *emptyView;
    UIView *withdrawalsIsOk;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backBtnClicked:)];
    
//    [self createEmptyView];
    [self createWithdrawalsIsOk];
}


- (void)createEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrawalsEmpty" owner:nil options:nil];
    emptyView = views[0];
    
    emptyView.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
    
    UIButton *button = (UIButton *)[emptyView viewWithTag:102];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:emptyView];
    //    emptyView.hidden = YES;
}

- (void)createWithdrawalsIsOk{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrawalsIsOk" owner:nil options:nil];
    withdrawalsIsOk = views[0];
    
    withdrawalsIsOk.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
    
//    UIButton *button = (UIButton *)[withdrawalsIsOk viewWithTag:102];
//    button.layer.cornerRadius = 15;
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
//    [button addTarget:self action:@selector(gotoShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:withdrawalsIsOk];
    //    emptyView.hidden = YES;
}

- (void)gotoShopping:(UIButton *)btn {
    
}

- (void)backBtnClicked:(UIButton *)button{
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

@end

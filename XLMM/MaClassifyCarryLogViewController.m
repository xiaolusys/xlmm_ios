//
//  MaClassifyCarryLogViewController.m
//  XLMM
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaClassifyCarryLogViewController.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "UIViewController+NavigationBar.h"
#import "AFNetworking.h"
#import "MMClass.h"

@interface MaClassifyCarryLogViewController ()

@end

@implementation MaClassifyCarryLogViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBarWithTitle:@"收益记录" selecotr:@selector(backClickAction)];
}

- (void)backClickAction {
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

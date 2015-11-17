//
//  WuliuViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/17.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WuliuViewController.h"
#import "UIViewController+NavigationBar.h"

@interface WuliuViewController ()

@end

@implementation WuliuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(goback)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback{
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

@end

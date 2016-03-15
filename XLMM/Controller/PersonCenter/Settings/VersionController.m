//
//  VersionController.m
//  XLMM
//
//  Created by younishijie on 15/12/4.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "VersionController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "UIColor+RGBColor.h"


@interface VersionController ()

@end

@implementation VersionController


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
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"关于小鹿美美" selecotr:@selector(backClicked:)];
    
    [self createInfo];
    
    
}

- (void)createInfo{
    //创建关于小鹿美美的界面。。。。。。
    self.versionLabel.text = self.versionString;
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

@end

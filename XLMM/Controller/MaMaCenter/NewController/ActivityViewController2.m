//
//  ActivityViewController2.m
//  XLMM
//
//  Created by younishijie on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ActivityViewController2.h"
#import "UIViewController+NavigationBar.h"


@interface ActivityViewController2 ()

@end

@implementation ActivityViewController2

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
    [self createNavigationBarWithTitle:@"活动中心" selecotr:@selector(backClicked:)];

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

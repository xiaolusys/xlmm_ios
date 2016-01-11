//
//  TixianSucceedViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianSucceedViewController.h"
#import "UIViewController+NavigationBar.h"
#import "PublishNewPdtViewController.h"


#define RGBCOLOR(a, b, c) [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1]

@interface TixianSucceedViewController ()

@end

@implementation TixianSucceedViewController

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
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    self.fabuButton.layer.cornerRadius = 15;
    self.fabuButton.layer.borderWidth = 1;
    self.fabuButton.layer.borderColor = RGBCOLOR(245, 266, 35).CGColor;
    
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

- (IBAction)fabuClicked:(id)sender {
    
    NSLog(@"发布产品");
    
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}
@end

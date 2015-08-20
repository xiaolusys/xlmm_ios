//
//  YouHuiQuanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "YouHuiQuanViewController.h"
#import "AddYouhuiquanViewController.h"

@interface YouHuiQuanViewController ()

@end

@implementation YouHuiQuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createInfo];
}

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"优惠券";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia.png"]];
    imageView2.frame = CGRectMake(8, 8, 30, 30);
    [button2 addSubview:imageView2];
    [button2 addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)addBtnClicked:(UIButton *)button{
    NSLog(@"获得优惠券");
    AddYouhuiquanViewController *addVC = [[AddYouhuiquanViewController alloc] initWithNibName:@"AddYouhuiquanViewController" bundle:nil];
    [self.navigationController pushViewController:addVC animated:YES];
    
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

//
//  TiaoKuanViewController.m
//  XLMM
//
//  Created by younishijie on 15/12/2.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "TiaoKuanViewController.h"


@interface TiaoKuanViewController ()<UIWebViewDelegate>

@end



@implementation TiaoKuanViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"小鹿美美服务条款" selecotr:@selector(backClicked:)];
    self.myWebView.frame = [[UIScreen mainScreen]applicationFrame];
    self.myWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:self.myWebView];
    
    NSURL* url = [NSURL URLWithString:@"https://m.xiaolu.so/contact.html"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.myWebView loadRequest:request];//加载
    
}
- (void)backClicked:(id)button{
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

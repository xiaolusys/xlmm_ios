//
//  AboutFansViewController.m
//  XLMM
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "AboutFansViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"

@interface AboutFansViewController ()

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation AboutFansViewController

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
    [self createNavigationBarWithTitle:@"关于粉丝" selecotr:@selector(backClicked:)];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSString *loadString = [NSString stringWithFormat:@"https://www.baidu.com"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadString]]];
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

//
//  ShopPreviousViewController.m
//  XLMM
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ShopPreviousViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"

@interface ShopPreviousViewController ()
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation ShopPreviousViewController
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
    [self createNavigationBarWithTitle:@"店铺预览" selecotr:@selector(backClickAction)];
   
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.webView scalesPageToFit];

    [self.view addSubview:self.webView];
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

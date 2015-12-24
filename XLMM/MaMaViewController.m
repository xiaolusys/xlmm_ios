//
//  MaMaViewController.m
//  XLMM
//
//  Created by 张迎 on 15/12/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MaMaViewController.h"

@interface MaMaViewController ()

@end

@implementation MaMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    NSString *str = @"http://xiaolu.so/m/m/?debug=123&code=3445&uopenid=oMt59uGYVCQy4gb4e0Iz6QVJ676w&sunionid=o29cQsxMBKSS1eh31-xMHVEUVYNA";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *resuqest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:resuqest];
    
    [self.view addSubview:webView];
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

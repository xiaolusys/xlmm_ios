//
//  JMSocialActivityController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSocialActivityController.h"
#import "MMClass.h"
#import "WebViewController.h"
#import "NJKWebViewProgressView.h"

@interface JMSocialActivityController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)UITableView *tableView;

//@property (nonatomic ,strong) IMYWebView *baseWebView;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@end

@implementation JMSocialActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createTableView];
    [self createWebView];
    
}
- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if ([urlString isKindOfClass:[NSNull class]] || urlString == nil || [urlString isEqual:@""]) {
        [MBProgressHUD showError:@"加载失败~"];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
    
    

}
- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 108)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    [self.view addSubview:self.webView];

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showLoading:@"小鹿努力加载中~" ToView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showError:@"加载失败~"];
//    [self backClickAction];
}
- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 108) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"------------222222 ";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}














@end











































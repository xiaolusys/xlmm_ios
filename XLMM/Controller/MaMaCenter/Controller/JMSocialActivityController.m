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

@interface JMSocialActivityController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic ,strong) IMYWebView *baseWebView;

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
    
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}
- (void)createWebView {
    kWeakSelf
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 108) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.progressBlock = ^(double estimatedProgress) {
        [weakSelf.progressView setProgress:estimatedProgress animated:YES];
    };
    [self.view addSubview:self.baseWebView];

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











































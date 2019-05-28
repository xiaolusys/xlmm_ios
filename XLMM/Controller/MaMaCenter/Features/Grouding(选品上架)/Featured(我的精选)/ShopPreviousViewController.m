//
//  ShopPreviousViewController.m
//  XLMM
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ShopPreviousViewController.h"
#import "UMSocial.h"
#import "WeiboSDK.h"
#import "SendMessageToWeibo.h"
#import "JMShareModel.h"
#import "JMShareViewController.h"


@interface ShopPreviousViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, copy) NSString *shopShareLink;
@property (nonatomic, copy) NSString *shopShareName;
@property (nonatomic, strong) UIImage *shopShareImage;
@property (nonatomic, copy) NSString *shopDesc;

@property (nonatomic, copy) NSString *webViewUrl;
@property (nonatomic,strong) JMShareModel *share_model;
@property (nonatomic,strong) JMShareViewController *shareViewContro;

@end

@implementation ShopPreviousViewController

- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}
- (JMShareViewController*)shareViewContro {
    if (!_shareViewContro) {
        _shareViewContro = [[JMShareViewController alloc] init];
    }
    return _shareViewContro;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ShopPreviousViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD hideHUDForView:self.view];
    [MobClick endLogPageView:@"ShopPreviousViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBarWithTitle:@"小鹿妈妈de精选集" selecotr:@selector(backClickAction)];
    
    NSString *shareString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushop/customer_shop", Root_URL];
    NSLog(@"url = %@", shareString);
    [self downLoadWithURLString:shareString andSelector:@selector(fetchedShareData:)];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;

    [self.view addSubview:self.webView];
    
    [self createrightItem];

    [self createbutton];

}

- (void)createbutton{
    
    UIButton *button0 = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    NSString *imageName0 = nil;
    imageName0 = @"wodejingxuanfanhui.png";
    
    UIImageView *imageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName0]];
    imageView0.frame = CGRectMake(2, 2, 40, 40);
    [button0 addSubview:imageView0];
    [button0 addTarget:self action:@selector(backClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button0 aboveSubview:self.webView];
    
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 44 - 8, 20, 44, 44)];
    NSString *imageName1 = nil;
    imageName1 = @"wodejingxuanfenxiang.png";
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName1]];
    imageView1.frame = CGRectMake(2, 2, 40, 40);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(sharedMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button1 aboveSubview:self.webView];
    
}

- (void)createrightItem{
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    NSString *imageName = nil;
    imageName = @"shareIconImage2.png";
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView1.frame = CGRectMake(20, 10, 20, 20);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(sharedMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)sharedMethod{
    NSLog(@"分享");
    [MobClick event:@"MaMaShop_share"];
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.shareViewContro WithBlock:^(UIView *maskView) {
    }];
    self.shareViewContro.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };

}
- (void)fetchedShareData:(NSData *)data{
    
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSLog(@"dic = %@", dic);
    if ([[dic objectForKey:@"shop_info"] class] == [NSNull class]) {
        
        NSLog(@"shop_info = null");
        return;
    }
    NSDictionary *shopInfo = dic[@"shop_info"];
    [self createNavigationBarWithTitle:shopInfo[@"name"] selecotr:@selector(backClickAction)];
    self.share_model.share_type = @"link";
    self.share_model.share_img = [shopInfo objectForKey:@"thumbnail"]; //图片
    self.share_model.desc = [shopInfo objectForKey:@"desc"]; // 文字详情
    self.share_model.title = [shopInfo objectForKey:@"name"]; //标题
    self.share_model.share_link = [shopInfo objectForKey:@"shop_link"];

    self.shareViewContro.model = self.share_model;
    
    self.webViewUrl = [[dic objectForKey:@"shop_info"] objectForKey:@"preview_shop_link"];
    if(self.webViewUrl != nil){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewUrl]]];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showLoading:@"小鹿努力加载中~" ToView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view];
    [self backClickAction];
}


- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
























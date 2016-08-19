//
//  ShopPreviousViewController.m
//  XLMM
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ShopPreviousViewController.h"
#import "MMClass.h"
#import "MamaShareView.h"
#import "UMSocial.h"
#import "WeiboSDK.h"
#import "SendMessageToWeibo.h"

@interface ShopPreviousViewController ()
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, copy) NSString *shopShareLink;
@property (nonatomic, copy) NSString *shopShareName;
@property (nonatomic, strong) UIImage *shopShareImage;
@property (nonatomic, copy) NSString *shopDesc;

@property (nonatomic, copy) NSString *webViewUrl;

@end

@implementation ShopPreviousViewController{
    MamaShareView *shareView;
    UIView *backView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ShopPreviousViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
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
   
    self.webView.scalesPageToFit = YES;

    [self.view addSubview:self.webView];
    
    [self createrightItem];

    [self createBackView];
    
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
    
    shareView = [MamaShareView new];
    
    
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MamaShareView" owner:shareView options:nil];
    shareView = array[0];
    shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    //    NSLog(@"shareView  = %@", shareView.subviews);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = self.view.bounds;
    }];
    backView.hidden = NO;
    [self.view addSubview:shareView];
    
    
    
    
    
    
    [self createShareButtonTarget];
}
- (void)createShareButtonTarget{
    UIView *view = (UIView *)[shareView.subviews objectAtIndex:0];
    view.layer.cornerRadius = 20;
    // shareView.cancleBtn.layer.masksToBounds = YES;
    shareView.cancleBtn.layer.cornerRadius = 20;
    shareView.cancleBtn.layer.borderWidth = 1;
    shareView.cancleBtn.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    
    [shareView.cancleBtn addTarget:self action:@selector(cancleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    shareView.weixinBtn.tag = 100;
    [shareView.weixinBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    shareView.friendBtn.tag = 101;
    shareView.qqBtn.tag = 102;
    shareView.spaceBtn.tag = 103;
    shareView.weiboBtn.tag = 104;
    shareView.fuzhiBtn.tag = 105;
    shareView.wxkuaizhaoBtn.tag = 106;
    shareView.wxkuaizhaoBtn.hidden = YES;
    shareView.friendkuaizhaoBtn.tag = 107;
    shareView.friendkuaizhaoBtn.hidden = YES;
    
    [shareView.weixinBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.friendBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.qqBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.spaceBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.weiboBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.fuzhiBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.wxkuaizhaoBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.friendkuaizhaoBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
}

- (void)shareClicked:(UIButton *)button{
    
    if (self.shopShareImage == nil) {
        self.shopShareImage = [UIImage imageNamed:@"logo.png"];
    }
    if (self.shopShareLink == nil) {
        [self cancleBtnClicked:nil];
        return;
    }
    switch (button.tag) {
        case 100:{
            //            NSLog(@"微信");
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shopDesc image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            
            [self cancleBtnClicked:nil];
            break;
        }
        case 101:{
            NSString *title = [NSString stringWithFormat:@"%@", self.shopDesc];
            
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shopDesc image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            
            
            [self cancleBtnClicked:nil];
            break;
        }
        case 102:{
            
            [UMSocialData defaultData].extConfig.qqData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.qqData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shopDesc image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            [self cancleBtnClicked:nil];
            
            break;
        }
        case 103:{
            [UMSocialData defaultData].extConfig.qzoneData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.qzoneData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.shopDesc image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            [self cancleBtnClicked:nil];
            
            break;
        }
        case 104:{
            
            //            NSLog(@"微博");
            NSData *data = UIImagePNGRepresentation(self.shopShareImage);
            
            NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.shopDesc, self.shopShareLink];
            
            [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:data];
            
            [self cancleBtnClicked:nil];
            
            break;
        }
        case 105:{
            
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *str = self.shopShareLink;
            [pab setString:str];
            if (pab == nil) {
                [SVProgressHUD showErrorWithStatus:@"请重新复制"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"已复制"];
            }
            [self cancleBtnClicked:nil];
            
            //            NSLog(@"复制");
            
            
            [self cancleBtnClicked:nil];
            
            //            NSLog(@"复制");
            break;
        }
        case 106:{
            //            NSLog(@"微信快照");
            break;
        }
        case 107:{
            //            NSLog(@"朋友圈快照");
            break;
        }
        default:{
            //            NSLog(@"其他");
            break;
        }
            
    }
}
- (void)cancleBtnClicked:(UIButton *)button{
    NSLog(@"quxiao");
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        
        backView.hidden = YES;
    }];

}


- (void)createBackView{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.alpha = 0.3;
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    backView.hidden = YES;
    
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
    NSDictionary *shopInfoDict = dic[@"shop_info"];
    self.shopShareName = shopInfoDict[@"name"];
    
    NSString *urlString = shopInfoDict[@"thumbnail"];
    if(urlString != nil){
        self.shopShareImage = [UIImage imagewithURLString:[urlString imageShareCompression]];
    }
    if ([dic[@"shop_info"][@"name"] class] == [NSNull class]) {
        self.shopShareName = @"小鹿妈妈";
    }
    
    self.shopShareLink = [dic[@"shop_info"] objectForKey:@"shop_link"];
    self.shopDesc = [dic[@"shop_info"] objectForKey:@"desc"];
    
    self.webViewUrl = [[dic objectForKey:@"shop_info"] objectForKey:@"preview_shop_link"];
    NSLog(@"web url = %@", self.webViewUrl);
    
    if(self.webViewUrl != nil){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewUrl]]];
    }
    self.title = [NSString stringWithFormat:@"%@de精选集", self.shopShareName];
    
    [self createNavigationBarWithTitle:[NSString stringWithFormat:@"%@de精选集", self.shopShareName] selecotr:@selector(backClickAction)];

    

    
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
























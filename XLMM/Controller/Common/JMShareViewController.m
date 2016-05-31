//
//  JMShareViewController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareViewController.h"
#import "Masonry.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "MMClass.h"
#import "JMShareButtonView.h"
#import "JMShareView.h"
#import "JMShareModel.h"
#import "MJExtension.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "YoumengShare.h"
#import "UUID.h"
#import "SSKeychain.h"
#import "SendMessageToWeibo.h"
#import "SVProgressHUD.h"
#import "JMPopView.h"
#import "AFNetworking.h"

@interface JMShareViewController ()<JMShareButtonViewDelegate>

@property (nonatomic,strong) JMSelecterButton *canelButton;

@property (nonatomic,strong) JMShareButtonView *shareButton;

@property (nonatomic,strong) UIView *shareBackView;

@property (nonatomic, strong)NSDictionary *nativeShare;


@end

@implementation JMShareViewController {
    BOOL _isPic;
    NSString *_imageUrlString;
    NSString *_content;
    NSString *_urlResource;
    NSString *_titleStr;
    NSString *_url;
    NSString *_kuaizhaoLink;
    UIImage *_imageData;
    UIImage *_kuaiZhaoImage;
    BOOL _isWeixin;
    BOOL _isWeixinFriends;
    BOOL _isCopy;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, 230);
    [self createShareButtom];
    [self loadData];
//    [self createData];
    
}



- (void)createShareButtom {

    JMShareButtonView *shareButton = [[JMShareButtonView alloc] init];
    self.shareButton = shareButton;
    self.shareButton.delegate = self;
    self.shareButton.layer.cornerRadius = 20;
    [self.view addSubview:self.shareButton];
    self.shareButton.backgroundColor = [[UIColor shareViewBackgroundColor]colorWithAlphaComponent:1.0];
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.canelButton = cancelButton;
    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:13. CornerRadius:15];
    self.canelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.canelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.canelButton];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(180);
    }];
    
    [self.canelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.shareButton.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(40);
    }];
    

    
    
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}
- (void)setActiveID:(NSString *)activeID {
    _activeID = activeID;
}

//- (void)setModel:(JMShareModel *)model {
//    _model = model;
//}
//
//- (void)setOtherDict:(NSMutableDictionary *)otherDict {
//    _otherDict = otherDict;
//}
- (void)loadData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        
        [self createData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


- (void)createData:(NSDictionary *)dic {
//    NSDictionary *dic = _model.mj_keyValues;
    
    if ([_activeID isEqualToString:@"myInvite"] || [_activeID isEqualToString:@"active"]) {
        NSString *type = dic[@"share_type"];
        if ([type isEqualToString:@"link"]) {
            _isPic = NO;
        }else {
            _isPic = YES;
        }
        _imageUrlString = [dic objectForKey:@"share_icon"]; //图片
        _content = [dic objectForKey:@"active_dec"]; // 文字详情
    }else {
        _content = [dic objectForKey:@"desc"]; //分享的文字详情
        _imageUrlString = dic[@"share_img"];   //图片
        _urlResource = dic[@"desc"]; //分享的链接等
    }
    _titleStr = [dic objectForKey:@"title"]; //标题
    _url = [dic objectForKey:@"share_link"];
    _kuaizhaoLink = [dic objectForKey:@"share_link"];
    
    _imageData = [UIImage imagewithURLString:_imageUrlString];
    _kuaiZhaoImage = [UIImage imagewithURLString:_kuaizhaoLink];
}

- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index {

    if (index == 0) {
        //微信分享
        if (_url == nil) {
            [self createPrompt];
            return ;
        }
        if (_isPic) {
            _isWeixin = YES;
            [self cancelBtnClick];
        }else {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;

            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                [self hiddenNavigationView];
            }];

            
        }
        [self cancelBtnClick];
    }else if (index == 1) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        if (_isPic) {
            //图片
            _isWeixinFriends = YES;
            //        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
//            [self createKuaiZhaoImage];
            //        [self createKuaiZhaoImage];
            [self cancelBtnClick];
        }else {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleStr;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
            [self cancelBtnClick];
        }
    }else if (index == 2) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qqData.url = _url;
        [UMSocialData defaultData].extConfig.qqData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        
        [self cancelBtnClick];
    }else if (index == 3) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qzoneData.url = _url;
        [UMSocialData defaultData].extConfig.qzoneData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            [self hiddenNavigationView];
        }];
        [self cancelBtnClick];

    }else if (index == 4) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        NSString *sina_content = [NSString stringWithFormat:@"%@%@",_titleStr, _url];
        [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_imageData)];
        [self cancelBtnClick];

    }else if (index == 5) {
        _isCopy = YES;
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        NSString *str = _url;
        [pab setString:str];
        if (pab == nil) {
            [SVProgressHUD showErrorWithStatus:@"请重新复制"];
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"已复制"];
        }
        //    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
        
        [self cancelBtnClick];

    }else { // 6
        NSLog(@"分享按钮被点击了 ===== index == 6");

    }
}

- (void)cancelBtnClick {
    
    [JMShareView hide];
    
    [JMPopView hide];
    
    [SVProgressHUD dismiss];
}

//提示分享失败
- (void)createPrompt {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不好，分享失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end




































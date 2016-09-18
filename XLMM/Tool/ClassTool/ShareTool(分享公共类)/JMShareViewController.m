//
//  JMShareViewController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareViewController.h"
#import "JMSelecterButton.h"
#import "MMClass.h"
#import "JMShareButtonView.h"
#import "JMShareView.h"
#import "JMShareModel.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "YoumengShare.h"
#import "UUID.h"
#import "SSKeychain.h"
#import "SendMessageToWeibo.h"
#import "JMPopView.h"

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
    
    NSString *_titleUrlString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, 230);
    [self createShareButtom];
    [self createData];
    
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

//- (void)setUrlStr:(NSString *)urlStr {
//    _urlStr = urlStr;
//}
//- (void)setActiveID:(NSString *)activeID {
//    _activeID = activeID;
//}

- (void)setModel:(JMShareModel *)model {
    _model = model;
}

//- (void)setOtherDict:(NSMutableDictionary *)otherDict {
//    _otherDict = otherDict;
//}
//- (void)loadData {
//    
//    NSLog(@"Shareview _urlStr=%@ _activeID=%@", _urlStr, _activeID);
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:_urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (!responseObject) return;
//        
//        [self createData:responseObject];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//
//}


- (void)createData {
//    NSDictionary *dic = _model.mj_keyValues;
//    NSLog(@"Share para=%@",dic);
    if(_model == nil) return;
    
    BOOL tpyeB = ([_model.share_type isEqual:@"link"] || [_model.share_type isEqual:@"0"]);
    if (tpyeB) {
        _isPic = NO;
    }else {
        _isPic = YES;
    }
    
    _titleStr = _model.title;
    _content = _model.desc;
    _imageUrlString = _model.share_img;
    _url = _model.share_link;
    _kuaizhaoLink = _url;
//    _imageData = [UIImage imagewithURLString:[_imageUrlString imageShareCompression]];
    _imageData = [UIImage imagewithURLString:_imageUrlString];
    _kuaiZhaoImage = [UIImage imagewithURLString:[_kuaizhaoLink imageShareCompression]];
    
    _titleUrlString = [NSString stringWithFormat:@"%@ %@",_content,_url];
    
    NSLog(@"Share _isPic=%d _imageUrlString=%@",_isPic, _imageUrlString);
}

- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index {
    NSLog(@"composeShareBtn Index=%ld", index);
    if (index == 100) {
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
//            UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:_url];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                [self hiddenNavigationView];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功");
                }
            }];

        }
        [self cancelBtnClick];
    }else if (index == 101) {
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
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleUrlString;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
            [self cancelBtnClick];
        }
    }else if (index == 102) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qqData.url = _url;
        [UMSocialData defaultData].extConfig.qqData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        
        [self cancelBtnClick];
    }else if (index == 103) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qzoneData.url = _url;
        [UMSocialData defaultData].extConfig.qzoneData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            [self hiddenNavigationView];
        }];
        [self cancelBtnClick];

    }else if (index == 104) {
        if (_url == nil) {
            [self createPrompt];
            return;
        }
        NSString *sina_content = [NSString stringWithFormat:@"%@%@",_content, _url];
        [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_imageData)];
        [self cancelBtnClick];

    }else if (index == 105) {
        _isCopy = YES;
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        if ([_url isKindOfClass:[NSNull class]] || _url == nil || [_url isEqual:@""]) {
            [MBProgressHUD showMessage:@"复制失败"];
        }else {
            [pab setString:_url];
            if (pab == nil) {
                [MBProgressHUD showMessage:@"请重新复制"];
            }else
            {
                [MBProgressHUD showMessage:@"已复制"];
            }
        }
        //    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
        [self cancelBtnClick];

    }else { // 6
        NSLog(@"分享按钮被点击了 ===== index == 6");

    }
}

- (void)cancelBtnClick {
    NSLog(@"cancelBtnClick");
    
    [JMShareView hide];
    
    [JMPopView hide];

}

//提示分享失败
- (void)createPrompt {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享数据获取不全，可能网络不稳定，请重新分享" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end





































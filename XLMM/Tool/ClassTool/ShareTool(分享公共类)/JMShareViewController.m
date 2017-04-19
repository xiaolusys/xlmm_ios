//
//  JMShareViewController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareViewController.h"
#import "JMSelecterButton.h"
#import "JMShareButtonView.h"
#import "JMShareModel.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UUID.h"
#import "SSKeychain.h"
#import "SendMessageToWeibo.h"
#import "JMRichTextTool.h"


@interface JMShareViewController ()<JMShareButtonViewDelegate>

@property (nonatomic,strong) JMSelecterButton *canelButton;
@property (nonatomic,strong) JMShareButtonView *shareButton;
@property (nonatomic, strong) UILabel *earningLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic,strong) UIView *shareBackView;
@property (nonatomic, strong) UIView *headerView;

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
    
    
}


- (void)createShareButtom {
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.layer.masksToBounds = YES;
//    headerView.layer.borderColor = [UIColor lineGrayColor].CGColor;
//    headerView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(100);
    }];
    UILabel *valueLabel = [UILabel new];
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel.font = [UIFont systemFontOfSize:24.f];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    UILabel *earningLabel = [UILabel new];
    earningLabel.numberOfLines = 0;
    earningLabel.textColor = [UIColor buttonTitleColor];
    earningLabel.font = [UIFont systemFontOfSize:12.f];
    earningLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:earningLabel];
    self.earningLabel = earningLabel;
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView).offset(20);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
    
    [self.earningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(valueLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
    
    JMShareButtonView *shareButton = [[JMShareButtonView alloc] init];
    self.shareButton = shareButton;
    self.shareButton.delegate = self;
    self.shareButton.layer.cornerRadius = 20;
    [self.view addSubview:self.shareButton];
    self.shareButton.backgroundColor = [[UIColor shareViewBackgroundColor]colorWithAlphaComponent:1.0];
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.canelButton = cancelButton;
    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:15. CornerRadius:20];
    self.canelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.canelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.canelButton];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(180);
    }];
    
    [self.canelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).offset(15);
        make.centerX.equalTo(self.shareButton.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(40);
    }];
    
    [self upDataWithModeProfit:self.model.profit];

}
- (void)upDataWithModeProfit:(NSDictionary *)profitDic {
    if (profitDic != nil) {
        if (!self.headerView) {
            return ;
        }
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
        }];
        NSString *minValue = [NSString stringWithFormat:@"%.2f",[profitDic[@"min"] floatValue]];
        NSString *allStr = [NSString stringWithFormat:@"只要你的好友通过你的链接购买此商品,你就能得到至少%@元的利润哦~",minValue];
        self.headerView.hidden = NO;
        self.valueLabel.text = [NSString stringWithFormat:@"赚 ¥%.2f ~ ¥%.2f",[profitDic[@"min"] floatValue],[profitDic[@"max"] floatValue]];
        self.earningLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:13.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allStr SubStringArray:@[minValue]];
    }else {
        if (!self.headerView) {
            return ;
        }
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
        self.headerView.hidden = YES;
    }
}
- (void)setModel:(JMShareModel *)model {
    _model = model;
    [self upDataWithModeProfit:model.profit];
    [self createData];
}
- (void)createData {
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
//    _kuaizhaoLink = _url;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _imageData = [UIImage imagewithURLString:_imageUrlString];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!_imageData) {
                _imageData = [UIImage imageNamed:@"icon-xiaolu.png"];
            }
        });
    });
    _titleUrlString = [NSString stringWithFormat:@"%@",_content];
}

- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index {
    NSLog(@"composeShareBtn Index=%ld", index);
    if (index == 100) {
        //微信分享
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return ;
        }
        if (_isPic) {
            _isWeixin = YES;
            [self cancelBtnClick:nil];
        }else {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;
//            UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:_imageUrlString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                [self hiddenNavigationView];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功");
                }
            }];

        }
        [self cancelBtnClick:nil];
    }else if (index == 101) {
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return;
        }
        if (_isPic) {
            //图片
            _isWeixinFriends = YES;
            //        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
//            [self createKuaiZhaoImage];
            //        [self createKuaiZhaoImage];
            [self cancelBtnClick:nil];
        }else {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleUrlString;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
            [self cancelBtnClick:nil];
        }
    }else if (index == 102) {
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qqData.url = _url;
        [UMSocialData defaultData].extConfig.qqData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        }];
        
        [self cancelBtnClick:nil];
    }else if (index == 103) {
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return;
        }
        [UMSocialData defaultData].extConfig.qzoneData.url = _url;
        [UMSocialData defaultData].extConfig.qzoneData.title = _titleStr;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            [self hiddenNavigationView];
        }];
        [self cancelBtnClick:nil];

    }else if (index == 104) {
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return;
        }
        NSString *sina_content = [NSString stringWithFormat:@"%@%@",_content, _url];
        [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_imageData)];
        [self cancelBtnClick:nil];

    }else if (index == 105) {
        _isCopy = YES;
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        if ([NSString isStringEmpty:_url]) {
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
        [self cancelBtnClick:nil];

    }else { // 6
        NSLog(@"分享按钮被点击了 ===== index == 6");

    }
}

- (void)cancelBtnClick:(UIButton *)button {
    NSLog(@"cancelBtnClick");
    if (self.blcok) {
        self.blcok(button);
    }
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





































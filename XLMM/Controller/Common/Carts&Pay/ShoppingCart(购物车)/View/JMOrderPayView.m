//
//  JMOrderPayView.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderPayView.h"

@interface JMOrderPayView ()

@property (nonatomic,strong) UIImageView *leftButton;

@property (nonatomic,strong) UILabel *moneyL;

@property (nonatomic,strong) UIView *firstLineV;

@property (nonatomic,strong) UIView *secondLineV;

@property (nonatomic,strong) UIImageView *iconWechatImage;

@property (nonatomic,strong) UIImageView *iconAliPayImage;

@property (nonatomic,strong) UILabel *wechatL;

@property (nonatomic,strong) UILabel *aliPayL;

@property (nonatomic,strong) UIView *wechatButton;

@property (nonatomic,strong) UIView *aliPayButton;

@end

@implementation JMOrderPayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self prepareUI];
    }
    return self;
}
- (void)initUI {
    UIImageView *leftButton = [UIImageView new];
    [self addSubview:leftButton];
    self.leftButton = leftButton;
//    self.leftButton.tag = 100;
//    [self.leftButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"leftArrowIcon"] forState:UIControlStateNormal];
    self.leftButton.image = [UIImage imageNamed:@"leftArrowIcon"];
    self.leftButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTapClick:)];
    [self.leftButton addGestureRecognizer:leftTap];
    UIView *leftView = [leftTap view];
    leftView.tag = 100;
    leftTap.numberOfTapsRequired = 1;
    
    
    UIView *wechatButton = [UIView new];
    [self addSubview:wechatButton];
    self.wechatButton = wechatButton;
//    self.wechatButton.tag = 101;
//    [self.wechatButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *wechatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTapClick:)];
    [self.wechatButton addGestureRecognizer:wechatTap];
    UIView *weChatView = [wechatTap view];
    weChatView.tag = 101;
    wechatTap.numberOfTapsRequired = 1;
    
    
    UIView *aliPayButton = [UIView new];
    [self addSubview:aliPayButton];
    self.aliPayButton = aliPayButton;
//    self.aliPayButton.tag = 102;
//    [self.aliPayButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *aliPayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTapClick:)];
    [self.aliPayButton addGestureRecognizer:aliPayTap];
    UIView *aliPayView = [aliPayTap view];
    aliPayView.tag = 102;
    aliPayTap.numberOfTapsRequired = 1;
    
    
    UILabel *moneyL = [UILabel new];
    [self addSubview:moneyL];
    self.moneyL = moneyL;
    self.moneyL.font = [UIFont systemFontOfSize:13.];
    self.moneyL.text = @"应付金额";
    
    UILabel *wechatL = [UILabel new];
    [self.wechatButton addSubview:wechatL];
    self.wechatL = wechatL;
    self.wechatL.font = [UIFont systemFontOfSize:13.];
    self.wechatL.text = @"微信支付";
    
    UILabel *aliPayL = [UILabel new];
    [self.aliPayButton addSubview:aliPayL];
    self.aliPayL = aliPayL;
    self.aliPayL.font = [UIFont systemFontOfSize:13.];
    self.aliPayL.text = @"支付宝支付";
    
    UIImageView *iconWechatImage = [UIImageView new];
    [self.wechatButton addSubview:iconWechatImage];
    self.iconWechatImage = iconWechatImage;
    self.iconWechatImage.image = [UIImage imageNamed:@"weixinzhifu"];
    
    UIImageView *iconAliPayImage = [UIImageView new];
    [self.aliPayButton addSubview:iconAliPayImage];
    self.iconAliPayImage = iconAliPayImage;
    self.iconAliPayImage.image = [UIImage imageNamed:@"zhifubao"];

    
    UIView *firstLineV = [UIView new];
    [self addSubview:firstLineV];
    self.firstLineV = firstLineV;
    self.firstLineV.backgroundColor = [UIColor titleDarkGrayColor];
    
    UIView *secondLineV = [UIView new];
    [self addSubview:secondLineV];
    self.secondLineV = secondLineV;
    self.secondLineV.backgroundColor = [UIColor titleDarkGrayColor];
    

}
- (void)prepareUI {
    kWeakSelf
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(19);
        make.width.height.mas_equalTo(@22);
    }];
    
    [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
    }];
    
    [self.firstLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(60);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@1);
    }];
    
    [self.secondLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstLineV).offset(60);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@1);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstLineV);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.aliPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.wechatButton.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.iconWechatImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.wechatButton).offset(18);
        make.left.equalTo(weakSelf.wechatButton).offset(18);
        make.width.height.mas_equalTo(@23);
    }];
    
    [self.wechatL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconWechatImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.iconWechatImage.mas_centerY);
    }];

    [self.iconAliPayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.aliPayButton).offset(18);
        make.left.equalTo(weakSelf.aliPayButton).offset(18);
        make.width.height.mas_equalTo(@23);
    }];
    
    [self.aliPayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconAliPayImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.iconAliPayImage.mas_centerY);
    }];
    
    
    
}
- (void)setPayMent:(NSString *)payMent {
    _payMent = payMent;
    self.moneyL.text = [NSString stringWithFormat:@"应付金额 %@",payMent];
}
- (void)payTapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    if (_delegate && [_delegate respondsToSelector:@selector(composePayButton:didClick:)]) {
        [_delegate composePayButton:self didClick:tapView.tag];
    }
}



@end









































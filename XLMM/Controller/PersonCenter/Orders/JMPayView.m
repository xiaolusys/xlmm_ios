//
//  JMPayView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayView.h"
#import "JMPayModel.h"
#import "MMClass.h"
#import "Masonry.h"


@interface JMPayView ()

@property (nonatomic,strong) UILabel *goodsMoneyLabel;

@property (nonatomic,strong) UILabel *couponLabel;

@property (nonatomic,strong) UILabel *appPayLabel;

@property (nonatomic,strong) UILabel *freightLabel;

@property (nonatomic,strong) UILabel *paymentLabel;


@end


@implementation JMPayView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    return self;
}

- (void)createUI {
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    
    UILabel *goodsMoney = [[UILabel alloc] init];
    [self addSubview:goodsMoney];
    
    UILabel *coupon = [[UILabel alloc] init];
    [self addSubview:coupon];
    
    UILabel *appPay = [[UILabel alloc] init];
    [self addSubview:appPay];
    
    UILabel *freight = [[UILabel alloc] init];
    [self addSubview:freight];
    
    UILabel *payment = [[UILabel alloc] init];
    [self addSubview:payment];
    
    UILabel *goodsMoneyLabel = [[UILabel alloc] init];
    [self addSubview:goodsMoneyLabel];
    self.goodsMoneyLabel = goodsMoneyLabel;
    
    UILabel *couponLabel = [[UILabel alloc] init];
    [self addSubview:couponLabel];
    self.couponLabel = couponLabel;
    
    UILabel *appPayLabel = [[UILabel alloc] init];
    [self addSubview:appPayLabel];
    self.appPayLabel = appPayLabel;
    
    UILabel *freightLabel = [[UILabel alloc] init];
    [self addSubview:freightLabel];
    self.freightLabel = freightLabel;
    
    UILabel *paymentLabel = [[UILabel alloc] init];
    [self addSubview:paymentLabel];
    self.paymentLabel = paymentLabel;
    
    kWeakSelf
    [goodsMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(weakSelf).offset(10);
    }];
    
    [coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(goodsMoney.mas_bottom).offset(10);
    }];
    
    [appPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(coupon.mas_bottom).offset(10);
    }];
    
    [freight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(appPay.mas_bottom).offset(10);
    }];
    
    [payment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(freight.mas_bottom).offset(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(freight);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREENWIDTH - 15);
    }];
    
    [self.goodsMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-10);
        make.centerY.equalTo(goodsMoney.mas_centerY);
    }];
    
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.goodsMoneyLabel);
        make.centerY.equalTo(goodsMoney.mas_centerY);
    }];
    
    [self.appPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.goodsMoneyLabel);
        make.centerY.equalTo(goodsMoney.mas_centerY);
    }];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.goodsMoneyLabel);
        make.centerY.equalTo(goodsMoney.mas_centerY);
    }];
    
    [self.paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.goodsMoneyLabel);
        make.centerY.equalTo(goodsMoney.mas_centerY);
    }];
    
    
}




- (void)setModel:(JMPayModel *)model {
    _model = model;
    
    self.goodsMoneyLabel.text = model.payment;
    self.couponLabel.text = model.coupon;
    self.appPayLabel.text = model.appPay;
    self.freightLabel.text = model.freight;
    self.paymentLabel.text = model.lastPayment;
    
}


@end



































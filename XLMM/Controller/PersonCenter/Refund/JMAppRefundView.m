//
//  JMAppRefundView.m
//  XLMM
//
//  Created by zhang on 16/6/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAppRefundView.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMAppForRefundModel.h"
#import "MJExtension.h"

@interface JMAppRefundView ()

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIButton *leftButton;

@property (nonatomic,strong) UIView *firstLineV;

@property (nonatomic,strong) UIView *secondLineV;

@property (nonatomic,strong) UIButton *speedRefund;

@property (nonatomic,strong) UIButton *alipayRefund;

@property (nonatomic,strong) UILabel *speedL;

@property (nonatomic,strong) UILabel *alipayL;

@property (nonatomic,assign) BOOL isRefund;

@end

@implementation JMAppRefundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self prepareUI];
    }
    return self;
}
- (void)initUI {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftButton];
    self.leftButton = leftButton;
    self.leftButton.tag = 100;
    [self.leftButton addTarget:self action:@selector(refundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"leftArrowIcon"] forState:UIControlStateNormal];
    
    UIButton *speedRefund = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:speedRefund];
    self.speedRefund = speedRefund;
    self.speedRefund.tag = 101;
    [self.speedRefund addTarget:self action:@selector(refundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *alipayRefund = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:alipayRefund];
    self.alipayRefund = alipayRefund;
    if (_payMentArr.count == 1) {
        self.alipayRefund.hidden = YES;
    }else {
        self.alipayRefund.tag = 102;
        [self.alipayRefund addTarget:self action:@selector(refundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UILabel *speedL = [UILabel new];
    [self.speedRefund addSubview:speedL];
    self.speedL = speedL;
    self.speedL.font = [UIFont systemFontOfSize:13.];
    self.speedL.text = @"极速退款";
    
    UILabel *alipayL = [UILabel new];
    [self.alipayRefund addSubview:alipayL];
    self.alipayL = alipayL;
    self.alipayL.font = [UIFont systemFontOfSize:13.];
    self.alipayL.text = @"退款到支付宝";
    
    
    
}
- (void)setPayMentArr:(NSMutableArray *)payMentArr {
    _payMentArr = payMentArr;
}

- (void)prepareUI {
    kWeakSelf
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(19);
        make.width.height.mas_equalTo(@22);
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
    
    [self.speedRefund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstLineV);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.alipayRefund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.speedRefund.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.speedL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf.speedRefund.mas_centerY);
    }];
    
    [self.alipayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf.alipayRefund.mas_centerY);
    }];
    
    
    
}

- (void)refundBtnClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeRefundButton:didClick:)]) {
        [_delegate composeRefundButton:self didClick:button.tag];
    }
}


@end







































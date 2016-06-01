//
//  JMOrderPayView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderPayView.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "Masonry.h"
#import "MMClass.h"

@interface JMOrderPayView ()

@property (nonatomic,strong) JMSelecterButton *payButton;

@property (nonatomic,strong) JMSelecterButton *cancelButton;

@end

@implementation JMOrderPayView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    JMSelecterButton *payButton = [[JMSelecterButton alloc] init];
    [self addSubview:payButton];
    self.payButton = payButton;
    [self.payButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"立即支付" TitleFont:13. CornerRadius:5];
    self.payButton.tag = 100;
    [self.payButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    [self.cancelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"取消订单" TitleFont:13. CornerRadius:5];
    self.cancelButton.tag = 101;
    [self.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *surplusL = [[UILabel alloc] init];
    [self addSubview:surplusL];
    
    UILabel *surTime = [[UILabel alloc] init];
    [self addSubview:surTime];
    kWeakSelf
    [surplusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(10);
    }];
    
    [surTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(surplusL.mas_bottom).offset(5);
        make.left.equalTo(surplusL);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf).offset(-10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@40);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.payButton.mas_left).offset(-10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    
}

- (void)btnClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composePayBtn:didClickBtn:)]) {
        [_delegate composePayBtn:self didClickBtn:button.tag];
    }
}










@end









































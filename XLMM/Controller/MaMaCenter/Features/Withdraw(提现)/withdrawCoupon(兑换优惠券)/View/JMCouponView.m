//
//  JMCouponView.m
//  XLMM
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponView.h"

@interface JMCouponView ()

@property (nonatomic, strong) UIButton *twentyButton;

@property (nonatomic, strong) UIButton *fiftyButton;

@property (nonatomic, strong) UILabel *moneyLabel;



@end

@implementation JMCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}
- (void)setMyCouponBlance:(CGFloat)myCouponBlance {
    _myCouponBlance = myCouponBlance;
    
    
    if (self.myCouponBlance >= 50) {
        [self.twentyButton setImage:[UIImage imageNamed:@"noUsed_coupon"] forState:UIControlStateNormal];
        [self.twentyButton setImage:[UIImage imageNamed:@"used_nomalcoupon"] forState:UIControlStateSelected];
        [self.fiftyButton setImage:[UIImage imageNamed:@"noUsed_coupon"] forState:UIControlStateNormal];
        [self.fiftyButton setImage:[UIImage imageNamed:@"used_nomalcoupon"] forState:UIControlStateSelected];
    }else if (self.myCouponBlance >= 20 && self.myCouponBlance < 50) {
        self.twentyButton.enabled = YES;
        self.fiftyButton.enabled = NO;
        [self.twentyButton setImage:[UIImage imageNamed:@"noUsed_coupon"] forState:UIControlStateNormal];
        [self.twentyButton setImage:[UIImage imageNamed:@"used_nomalcoupon"] forState:UIControlStateSelected];
        [self.fiftyButton setImage:[UIImage imageNamed:@"newyouhuiquanbukeyongbg"] forState:UIControlStateNormal];
        [self.fiftyButton setImage:[UIImage imageNamed:@"used_nomalcoupon"] forState:UIControlStateSelected];
    }else if (self.myCouponBlance < 20) {
        self.twentyButton.enabled = NO;
        self.fiftyButton.enabled = NO;
        [self.twentyButton setImage:[UIImage imageNamed:@"newyouhuiquanbukeyongbg"] forState:UIControlStateNormal];
        [self.fiftyButton setImage:[UIImage imageNamed:@"newyouhuiquanbukeyongbg"] forState:UIControlStateNormal];
    }


}
- (void)createUI {
  
    
    [self setUpButtonWithImage:nil highImage:nil Title:nil target:self action:@selector(btnClick:)];

    [self setUpButtonWithImage:nil highImage:nil Title:nil target:self action:@selector(btnClick:)];
    
}
- (void)setUpButtonWithImage:(UIImage *)image highImage:(UIImage *)highImage Title:(NSString *)title target:(id)target action:(SEL)action {
 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
    btn.tag = self.subviews.count + 1;
//    self.twentyButton = btn;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateSelected];
    
    UILabel *moneyLabel = [UILabel new];
    [btn addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    self.moneyLabel.font = [UIFont systemFontOfSize:60.];
    
    self.moneyLabel.textColor = [UIColor redColor];
    if (btn.tag == 1) {
        self.moneyLabel.text = @"¥20";
        self.twentyButton = btn;
    }else {
        self.moneyLabel.text = @"¥50";
        self.fiftyButton = btn;
    }
    
    
    
    UILabel *goforLabel = [UILabel new];
    [btn addSubview:goforLabel];
    goforLabel.text = @"全场通用";
    goforLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *timeLabel = [UILabel new];
    [btn addSubview:timeLabel];
    timeLabel.text = @"使用期限：一个月";
    timeLabel.font = [UIFont systemFontOfSize:12.];
    timeLabel.textColor = [UIColor timeLabelColor];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn).offset(60);
        make.top.equalTo(btn);
    }];
    
    [goforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLabel.mas_right).offset(10);
        make.top.equalTo(btn).offset(40);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLabel);
        make.bottom.equalTo(btn).offset(-5);
    }];
    
    [self addSubview:btn];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat width = self.frame.size.width;
    CGFloat X = 5;
    CGFloat Y = 0;
    CGFloat W = width - 10;
    CGFloat H = 100;
    
    for (int i = 0 ; i < count; i++) {
        
        UIButton *btn = self.subviews[i];
        Y = i * H + 5 * (i + 1);
        btn.frame = CGRectMake(X, Y, W, H);
        
        
    }
}
- (void)btnClick:(UIButton *)button {
    //点击工具条的时候
    if (_delegate && [_delegate respondsToSelector:@selector(composeCouponBtn:Button:didClickBtn:)]) {
        [_delegate composeCouponBtn:self Button:button didClickBtn:button.tag];
    }
    
}


@end























































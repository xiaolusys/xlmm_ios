//
//  JMSharePackView.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSharePackView.h"
#import "MMClass.h"
#import "Masonry.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"

@interface JMSharePackView ()

@property (nonatomic, strong) UIImageView *payShareImage;

@property (nonatomic, strong) JMSelecterButton *shareGetpack;


@end


@implementation JMSharePackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *payShareImage = [UIImageView new];
    [self addSubview:payShareImage];
    self.payShareImage = payShareImage;
    self.payShareImage.image = [UIImage imageNamed:@"hongbao_back"];
    
    UIImageView *getRedpake = [UIImageView new];
    [self.payShareImage addSubview:getRedpake];
    getRedpake.image = [UIImage imageNamed:@""];
    
    UILabel *deductionPayMoneyL = [UILabel new];
    [self.payShareImage addSubview:deductionPayMoneyL];
    deductionPayMoneyL.font = [UIFont systemFontOfSize:14.];
    deductionPayMoneyL.textColor = [UIColor buttonEnabledBackgroundColor];
    deductionPayMoneyL.text = @"分享红包给好友可抵扣在线支付金额";
    
    JMSelecterButton *shareGetpack = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.payShareImage addSubview:shareGetpack];
    [shareGetpack setSureBackgroundColor:[UIColor buttonEnabledBackgroundColor] CornerRadius:20];
    shareGetpack.titleLabel.text = @"分享领取红包";
    shareGetpack.titleLabel.textColor = [UIColor whiteColor];
    
    kWeakSelf
    [self.payShareImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@230);
    }];
    
    [getRedpake mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.payShareImage).offset(100);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
    }];
    
    [deductionPayMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getRedpake.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
    }];
    
    [self.shareGetpack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deductionPayMoneyL.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
}


@end



















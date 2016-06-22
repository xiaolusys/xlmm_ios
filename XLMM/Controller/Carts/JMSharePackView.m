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

#define JMSHAREPROPORTION 0.62

@interface JMSharePackView ()

@property (nonatomic, strong) UIImageView *payShareImage;

@property (nonatomic, strong) JMSelecterButton *shareGetpack;


@end


@implementation JMSharePackView

+ (instancetype)enterHeaderView {
    JMSharePackView *headView = [[JMSharePackView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * JMSHAREPROPORTION)];
    headView.backgroundColor = [UIColor orangeColor];
    return headView;
}

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
    
    
    CGFloat PayW = SCREENWIDTH * JMSHAREPROPORTION;
    
    UIImageView *getRedpake = [UIImageView new];
    [self.payShareImage addSubview:getRedpake];
    getRedpake.image = [UIImage imageNamed:@"get_fivteen_redpack"];
    
    UILabel *deductionPayMoneyL = [UILabel new];
    [self.payShareImage addSubview:deductionPayMoneyL];
    deductionPayMoneyL.font = [UIFont systemFontOfSize:14.];
    deductionPayMoneyL.textColor = [UIColor buttonEnabledBackgroundColor];
    deductionPayMoneyL.text = @"分享红包给好友可抵扣在线支付金额";
    
    JMSelecterButton *shareGetpack = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.payShareImage addSubview:shareGetpack];
    [shareGetpack setSureBackgroundColor:[UIColor buttonEnabledBackgroundColor] CornerRadius:20];
    [shareGetpack setTitle:@"分享领取红包" forState:UIControlStateNormal];
    [shareGetpack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareGetpack = shareGetpack;
    kWeakSelf
    [self.payShareImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(PayW);
    }];
    
    [getRedpake mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.payShareImage).offset(120);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
    }];
    
    [deductionPayMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getRedpake.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
    }];
    
    [self.shareGetpack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-25);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 60);
        make.height.mas_equalTo(@40);
    }];
}


@end



















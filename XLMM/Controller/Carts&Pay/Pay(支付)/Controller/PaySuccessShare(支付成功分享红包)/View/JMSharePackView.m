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

@property (nonatomic,strong) UILabel *getRedpake;

@end


@implementation JMSharePackView

+ (instancetype)enterFooterView {
    JMSharePackView *headView = [[JMSharePackView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 230)];
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
    self.payShareImage.userInteractionEnabled = YES;
    
//    CGFloat PayW = SCREENWIDTH * JMSHAREPROPORTION;
    
    UILabel *getRedpake = [UILabel new];
    [self.payShareImage addSubview:getRedpake];
    self.getRedpake = getRedpake;
    
    
    
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
    [self.shareGetpack addTarget:self action:@selector(shareRedPackClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
        make.top.equalTo(getRedpake.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
    }];
    
    [self.shareGetpack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deductionPayMoneyL.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.payShareImage.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 60);
        make.height.mas_equalTo(@40);
    }];
}
- (void)setLimitStr:(NSString *)limitStr {
    _limitStr = limitStr;
    NSString *numStr = [NSString stringWithFormat:@"恭喜您获得%@个红包",limitStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,10)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0] range:NSMakeRange(5, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(7, 3)];
    self.getRedpake.attributedText = str;
    
}
- (void)shareRedPackClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(composeGetRedpackBtn:didClick:)]) {
        [_delegate composeGetRedpackBtn:self didClick:sender];
    }
}


@end



















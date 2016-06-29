//
//  JMMaMaCenterTopView.m
//  XLMM
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaCenterTopView.h"
#import "Masonry.h"
#import "MMClass.h"

@interface JMMaMaCenterTopView ()
/**
 *  返回上一页按钮
 */
@property (nonatomic, strong) UIButton *backPageButton;
/**
 *  妈妈头像
 */
@property (nonatomic, strong) UIImageView *mamaIconImage;
/**
 *  MaMa是不是会员
 */
@property (nonatomic, strong) UIButton *isVipMamaButton;
/**
 *  Vip剩余时间
 */
@property (nonatomic, strong) UILabel *remainingTimeLabel;
/**
 *  Vip等级考试
 */
@property (nonatomic, strong) UIImageView *vipExamination;

@property (nonatomic, strong) UILabel *lineView;
/**
 *  账户余额
 */
@property (nonatomic, strong) UIButton *balanceButton;
@property (nonatomic, strong) UILabel *balanceLabel;
/**
 *  累计收益
 */
@property (nonatomic, strong) UIButton *accumulatedEarningsButton;
@property (nonatomic, strong) UILabel *accumulatedEarningsLabel;
/**
 *  活跃度
 */
@property (nonatomic, strong) UIButton *activenessButton;
@property (nonatomic, strong) UILabel *activenessLabel;



@end

@implementation JMMaMaCenterTopView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"wodejingxuanback"];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    // ====== 返回按钮 ====== //
    UIButton *backPageButton = [UIButton new];
    [self addSubview:backPageButton];
    self.backPageButton = backPageButton;
    [self.backPageButton setBackgroundImage:[UIImage imageNamed:@"wodejingxuanfanhui"] forState:UIControlStateNormal];
    [self.backPageButton addTarget:self action:@selector(backPageupClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // ====== 妈妈相关 ====== //
    UIImageView *mamaIconBackImage = [UIImageView new]; //wodejingxuantouxiangicon -- > 妈妈头像底层图片
    [self addSubview:mamaIconBackImage];
    mamaIconBackImage.image = [UIImage imageNamed:@"wodejingxuantouxiangicon"];
    
    UIImageView *mamaIconImage = [UIImageView new];
    [mamaIconBackImage addSubview:mamaIconImage];
    self.mamaIconImage = mamaIconImage;
    self.mamaIconImage.layer.masksToBounds = YES;
    self.mamaIconImage.layer.cornerRadius = 25.;
    self.mamaIconImage.layer.borderWidth = 1.;
    self.mamaIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mamaIconImage.image = [UIImage imageNamed:@"zhanwei"];
    
    UIButton *isVipMamaButton = [UIButton new];
    [self addSubview:isVipMamaButton];
    self.isVipMamaButton = isVipMamaButton;
    [self.isVipMamaButton setTitle:@"普通妈妈" forState:UIControlStateNormal];
    [self.isVipMamaButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.isVipMamaButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    /**
     *      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     [btn setImage:image forState:UIControlStateNormal];
     [btn setImage:highImage forState:UIControlStateSelected];
     [btn setTitle:title forState:UIControlStateNormal];
     [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
     btn.tag = self.subviews.count + 1;
     if (btn.tag == 1) {
     btn.selected = YES;
     }
     [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -6, 0.0, 0.0)];
     [self addSubview:btn];
     */
    
    UILabel *remainingTimeLabel = [UILabel new];
    [self addSubview:remainingTimeLabel];
    self.remainingTimeLabel = remainingTimeLabel;
    self.remainingTimeLabel.text = @"会员剩余期限188天";
    
    UIImageView *vipExamination = [UIImageView new];
    [self addSubview:vipExamination];
    self.vipExamination = vipExamination;

    // ====== 收益相关 ====== //
    UIButton *balanceButton = [UIButton new];
    [self addSubview:balanceButton];
    self.balanceButton = balanceButton;
    
    UIButton *accumulatedEarningsButton = [UIButton new];
    [self addSubview:accumulatedEarningsButton];
    self.accumulatedEarningsButton = accumulatedEarningsButton;
    
    UIButton *activenessButton = [UIButton new];
    [self addSubview:activenessButton];
    self.activenessButton = activenessButton;

    UILabel *balanceLabel = [UILabel new];
    [self.balanceButton addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    self.balanceLabel.text = @"234.454";
    
    UILabel *accumulatedEarningsLabel = [UILabel new];
    [self.accumulatedEarningsButton addSubview:accumulatedEarningsLabel];
    self.accumulatedEarningsLabel = accumulatedEarningsLabel;
    self.accumulatedEarningsLabel.text = @"234.454";
    
    UILabel *activenessLabel = [UILabel new];
    [self.activenessButton addSubview:activenessLabel];
    self.activenessLabel = activenessLabel;
    self.activenessLabel.text = @"234.454";
    
    UILabel *firstLabel = [UILabel new];
    [self.balanceButton addSubview:firstLabel];
    firstLabel.text = @"账户余额(元)";
    
    UILabel *twoLabel = [UILabel new];
    [self.accumulatedEarningsButton addSubview:twoLabel];
    twoLabel.text = @"累计收益(元)";
    
    UILabel *threeLabel = [UILabel new];
    [self.activenessButton addSubview:threeLabel];
    threeLabel.text = @"活跃度";
    
    // ====== 分割线 ====== //
    UILabel *lineView = [UILabel new];
    [self addSubview:lineView];
    self.lineView = lineView;
    self.lineView.backgroundColor = [UIColor whiteColor];
    
    kWeakSelf
    
    [self.backPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(weakSelf).offset(30);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(40);
        make.top.equalTo(weakSelf).offset(80);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.isVipMamaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(15);
        make.top.equalTo(mamaIconBackImage);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@20);
    }];
    
    [self.remainingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.isVipMamaButton);
        make.top.equalTo(weakSelf.isVipMamaButton.mas_bottom).offset(15);
    }];
    
    [self.vipExamination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-10);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@45);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@1);
        make.top.equalTo(weakSelf).offset(165);
    }];
    
    CGFloat buttonW = SCREENWIDTH / 3;
    [self.balanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(@55);
    }];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.balanceButton).offset(10);
        make.centerX.equalTo(weakSelf.balanceButton.mas_centerX);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLabel.mas_bottom).offset(1);
        make.centerX.equalTo(weakSelf.balanceButton.mas_centerX);
    }];
    
    [self.accumulatedEarningsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.balanceButton.mas_right);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(@55);
    }];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.accumulatedEarningsButton).offset(10);
        make.centerX.equalTo(weakSelf.accumulatedEarningsButton.mas_centerX);
    }];
    [self.accumulatedEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLabel.mas_bottom).offset(1);
        make.centerX.equalTo(weakSelf.accumulatedEarningsButton.mas_centerX);
    }];
    
    [self.activenessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accumulatedEarningsButton.mas_right);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(@55);
    }];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.activenessButton).offset(10);
        make.centerX.equalTo(weakSelf.activenessButton.mas_centerX);
    }];
    [self.activenessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeLabel.mas_bottom).offset(1);
        make.centerX.equalTo(weakSelf.activenessButton.mas_centerX);
    }];
    
    
    
}

//- (void)setLimitStr:(NSString *)limitStr {
//    _limitStr = limitStr;
//    NSInteger count = limitStr.length;
//    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limitStr];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,10)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(0, 6)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0] range:NSMakeRange(6, count)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(6+count, 1)];
//    self.getRedpake.attributedText = str;
//    
//}


- (void)backPageupClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeBackPageup:Button:)]) {
        [_delegate composeBackPageup:self Button:button];
    }
}



@end





























































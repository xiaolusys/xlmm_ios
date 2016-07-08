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
#import "JMMaMaExtraModel.h"
#import "MJExtension.h"
#import "NSString+URL.h"

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
@property (nonatomic, strong) UILabel *buttonLabel;
/**
 *  MaMa等级
 */
@property (nonatomic, strong) UILabel *mamaLeveLabel;
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

@property (nonatomic, strong) JMMaMaExtraModel *extraModel;


@end

@implementation JMMaMaCenterTopView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"wodejingxuanback"];
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}
- (void)setCenterModel:(JMMaMaCenterModel *)centerModel {
    _centerModel = centerModel;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:centerModel.extra_info];
    
    
    self.buttonLabel.text = self.centerModel.mama_level_display;
    
    self.activenessLabel.text = self.centerModel.active_value_num;
    
    CGFloat carryValue = [self.centerModel.carry_value floatValue];
    self.accumulatedEarningsLabel.text = [NSString stringWithFormat:@"%.2f",carryValue];
    
    CGFloat cashValue = [self.centerModel.cash_value floatValue];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",cashValue];
    
    self.mamaLeveLabel.text = self.extraModel.agencylevel_display;
    
    NSString *limtStr = self.extraModel.surplus_days;
    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limtStr];
    NSInteger count = limtStr.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6,count)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(count + 6,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0] range:NSMakeRange(6, count)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(6+count, 1)];
    self.remainingTimeLabel.attributedText = str;
    
    [self.mamaIconImage sd_setImageWithURL:[NSURL URLWithString:[self.extraModel.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    
    
}
- (void)createUI {
    // ====== 返回按钮 ====== //
    UIButton *backPageButton = [UIButton new];
    [self addSubview:backPageButton];
    self.backPageButton = backPageButton;
    [self.backPageButton setBackgroundImage:[UIImage imageNamed:@"wodejingxuanfanhui"] forState:UIControlStateNormal];
    self.backPageButton.tag = 100;
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
//    self.mamaIconImage.image = [UIImage imageNamed:@"zhanwei"];
    
    UIButton *isVipMamaButton = [UIButton new];
    [self addSubview:isVipMamaButton];
    self.isVipMamaButton = isVipMamaButton;
    self.isVipMamaButton.layer.masksToBounds = YES;
    self.isVipMamaButton.layer.cornerRadius = 10.;
    self.isVipMamaButton.layer.borderWidth = 1.;
    self.isVipMamaButton.layer.borderColor = [UIColor whiteColor].CGColor;

    UIImageView *buttonImage = [UIImageView new];
    [self.isVipMamaButton addSubview:buttonImage];
    buttonImage.backgroundColor = [UIColor clearColor];
    buttonImage.image = [UIImage imageNamed:@"mamaUser_DiamondsIcon"];
    
    UILabel *buttonLabel = [UILabel new];
    [self.isVipMamaButton addSubview:buttonLabel];
    self.buttonLabel = buttonLabel;
    self.buttonLabel.textColor = [UIColor whiteColor];
    self.buttonLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *mamaLeveLabel = [UILabel new];
    [self addSubview:mamaLeveLabel];
    self.mamaLeveLabel = mamaLeveLabel;
    self.mamaLeveLabel.font = [UIFont boldSystemFontOfSize:16.];
    
    UILabel *remainingTimeLabel = [UILabel new];
    [self addSubview:remainingTimeLabel];
    self.remainingTimeLabel = remainingTimeLabel;
    self.remainingTimeLabel.font = [UIFont systemFontOfSize:14.];
    
    UIImageView *vipExamination = [UIImageView new];
    [self addSubview:vipExamination];
    self.vipExamination = vipExamination;
    self.vipExamination.userInteractionEnabled = YES;
    self.vipExamination.image = [UIImage imageNamed:@"vipGrade_Examination"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVipClick:)];
    [self.vipExamination addGestureRecognizer:tap];

    // ====== 收益相关 ====== //
    UIButton *balanceButton = [UIButton new];
    [self addSubview:balanceButton];
    self.balanceButton = balanceButton;
    self.balanceButton.tag = 111;
    [self.balanceButton addTarget:self action:@selector(backPageupClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *accumulatedEarningsButton = [UIButton new];
    [self addSubview:accumulatedEarningsButton];
    self.accumulatedEarningsButton = accumulatedEarningsButton;
    self.accumulatedEarningsButton.tag = 112;
    [self.accumulatedEarningsButton addTarget:self action:@selector(backPageupClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *activenessButton = [UIButton new];
    [self addSubview:activenessButton];
    self.activenessButton = activenessButton;
    self.activenessButton.tag = 113;
    [self.activenessButton addTarget:self action:@selector(backPageupClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *balanceLabel = [UILabel new];
    [self.balanceButton addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    self.balanceLabel.font = [UIFont boldSystemFontOfSize:18.];
    
    UILabel *accumulatedEarningsLabel = [UILabel new];
    [self.accumulatedEarningsButton addSubview:accumulatedEarningsLabel];
    self.accumulatedEarningsLabel = accumulatedEarningsLabel;
    self.accumulatedEarningsLabel.font = [UIFont boldSystemFontOfSize:18.];

    UILabel *activenessLabel = [UILabel new];
    [self.activenessButton addSubview:activenessLabel];
    self.activenessLabel = activenessLabel;
    self.activenessLabel.font = [UIFont boldSystemFontOfSize:18.];
    
    UILabel *firstLabel = [UILabel new];
    [self.balanceButton addSubview:firstLabel];
    firstLabel.font = [UIFont systemFontOfSize:12.];
    firstLabel.text = @"账户余额(元)";
    
    UILabel *twoLabel = [UILabel new];
    [self.accumulatedEarningsButton addSubview:twoLabel];
    twoLabel.font = [UIFont systemFontOfSize:12.];
    twoLabel.text = @"累计收益(元)";
    
    UILabel *threeLabel = [UILabel new];
    [self.activenessButton addSubview:threeLabel];
    threeLabel.font = [UIFont systemFontOfSize:12.];
    threeLabel.text = @"活跃度";
    
    // ====== 分割线 ====== //
    UILabel *lineView = [UILabel new];
    [self addSubview:lineView];
    self.lineView = lineView;
    self.lineView.backgroundColor = [UIColor whiteColor];
    
    kWeakSelf
    
    [self.backPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(1);
        make.top.equalTo(weakSelf).offset(20);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf).offset(80);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.isVipMamaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(10);
        make.top.equalTo(mamaIconBackImage).offset(5);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@20);
    }];
    [buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.isVipMamaButton).offset(6);
        make.top.equalTo(weakSelf.isVipMamaButton).offset(3);
        make.bottom.equalTo(weakSelf.isVipMamaButton).offset(-3);
    }];
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonImage.mas_right).offset(3);
        make.centerY.equalTo(weakSelf.isVipMamaButton.mas_centerY);
    }];
    
    [self.mamaLeveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.isVipMamaButton.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.isVipMamaButton.mas_centerY);
    }];
    
    [self.remainingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.isVipMamaButton);
        make.top.equalTo(weakSelf.isVipMamaButton.mas_bottom).offset(10);
    }];
    
    [self.vipExamination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@45);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@1);
        make.top.equalTo(weakSelf).offset(180);
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
        make.height.mas_equalTo(@60);
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
- (void)tapVipClick:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(composeTapBackPageup:Tap:)]) {
        [_delegate composeTapBackPageup:self Tap:tap];
    }
}

- (void)backPageupClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeBackPageup:Index:)]) {
        [_delegate composeBackPageup:self Index:button.tag];
    }
}



@end





























































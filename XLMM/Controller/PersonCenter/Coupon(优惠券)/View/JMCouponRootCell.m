//
//  JMCouponRootCell.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponRootCell.h"
#import "MMClass.h"
#import "JMCouponModel.h"



@interface JMCouponRootCell ()

/**
 *  优惠券金额
 */
@property (nonatomic, strong) UILabel *couponValueLabel;
/**
 *  使用条件
 */
@property (nonatomic, strong) UILabel *couponUsefeeLabel;
/**
 *  使用场景
 */
@property (nonatomic, strong) UILabel *couponProsdescLabel;
/**
 *  开始时间
 */
@property (nonatomic, strong) UILabel *couponCreatedTimeLabel;
/**
 *  结束时间
 */
@property (nonatomic, strong) UILabel *couponDeadLineLabel;

@property (nonatomic, strong) UIImageView *rightImage;

@end

@implementation JMCouponRootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *couponBackImage = [UIImageView new];
    [self.contentView addSubview:couponBackImage];
    self.couponBackImage = couponBackImage;
    
    UIImageView *rightImage = [UIImageView new];
    [self.couponBackImage addSubview:rightImage];
    self.rightImage = rightImage;
    self.rightImage.image = [UIImage imageNamed:@"icon-jiantouyou2"];
    self.rightImage.hidden = YES;
    
    UILabel *couponValueLabel = [UILabel new];
    [self.couponBackImage addSubview:couponValueLabel];
    self.couponValueLabel = couponValueLabel;
    self.couponValueLabel.font = [UIFont systemFontOfSize:52.];
    
    UILabel *couponUsefeeLabel = [UILabel new];
    [self.couponBackImage addSubview:couponUsefeeLabel];
    self.couponUsefeeLabel = couponUsefeeLabel;
    self.couponUsefeeLabel.font = [UIFont systemFontOfSize:14.];
    self.couponUsefeeLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *couponProsdescLabel = [UILabel new];
    [self.couponBackImage addSubview:couponProsdescLabel];
    self.couponProsdescLabel = couponProsdescLabel;
    self.couponProsdescLabel.font = [UIFont systemFontOfSize:16.];
    self.couponProsdescLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *couponCreatedTimeLabel = [UILabel new];
    [self.couponBackImage addSubview:couponCreatedTimeLabel];
    self.couponCreatedTimeLabel = couponCreatedTimeLabel;
    self.couponCreatedTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.couponCreatedTimeLabel.textColor = [UIColor titleDarkGrayColor];
    
    UILabel *couponDeadLineLabel = [UILabel new];
    [self.couponBackImage addSubview:couponDeadLineLabel];
    self.couponDeadLineLabel = couponDeadLineLabel;
    self.couponDeadLineLabel.font = [UIFont systemFontOfSize:11.];
    self.couponDeadLineLabel.textColor = [UIColor titleDarkGrayColor];
    
    // 期限label
    UILabel *deadLineLabel = [UILabel new];
    [self.couponBackImage addSubview:deadLineLabel];
    deadLineLabel.font = [UIFont systemFontOfSize:12.];
    deadLineLabel.textColor = [UIColor titleDarkGrayColor];
    deadLineLabel.text = @"期限 ";
    UILabel *deadOfLabel = [UILabel new];
    [self.couponBackImage addSubview:deadOfLabel];
    deadOfLabel.font = [UIFont systemFontOfSize:12.];
    deadOfLabel.textColor = [UIColor titleDarkGrayColor];
    deadOfLabel.text = @" 至 ";
    
    kWeakSelf
    
    [self.couponBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(@100);
    }];
    
    [self.couponValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponBackImage).offset(65);
        make.top.equalTo(weakSelf.couponBackImage).offset(5);
    }];
    
    [self.couponUsefeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponValueLabel.mas_right).offset(15);
        make.top.equalTo(weakSelf.couponValueLabel).offset(10);
    }];
    
    [self.couponProsdescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.couponUsefeeLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.couponUsefeeLabel);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.couponBackImage).offset(-25);
        make.centerY.equalTo(weakSelf.couponValueLabel.mas_centerY);
    }];
    
    [deadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponBackImage).offset(55);
        make.bottom.equalTo(weakSelf.couponBackImage).offset(-10);
    }];
    [self.couponCreatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deadLineLabel.mas_right);
        make.centerY.equalTo(deadLineLabel.mas_centerY);
    }];
    [deadOfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponCreatedTimeLabel.mas_right);
        make.centerY.equalTo(deadLineLabel.mas_centerY);
    }];
    [self.couponDeadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deadOfLabel.mas_right);
        make.centerY.equalTo(deadLineLabel.mas_centerY);
    }];
    
    
}



- (void)configData:(JMCouponModel *)couponModel Index:(NSInteger)index {
    NSString *imageStr = @"";
    if (index == 0) {
        //未使用优惠券
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
        self.rightImage.hidden = NO;
    }else if (index == 1) {
        //已使用
        imageStr = @"used_coupon";
        self.couponValueLabel.textColor = [UIColor timeLabelColor];
    }else if (index == 2) {
        //不可使用
        //未使用优惠券
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
    }else if (index == 3) {
        //已过期
        imageStr = @"outDate_coupon";
        self.couponValueLabel.textColor = [UIColor timeLabelColor];
    }else {
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
    }
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    
    self.couponValueLabel.text = [NSString stringWithFormat:@"¥%@",couponModel.coupon_value];
    
    self.couponUsefeeLabel.text = couponModel.use_fee_des;
    self.couponProsdescLabel.text = couponModel.pros_desc;
    
    self.couponCreatedTimeLabel.text = [self composeString:couponModel.created];
    self.couponDeadLineLabel.text = [self composeString:couponModel.deadline];
    
}
- (void)configUsableData:(JMCouponModel *)couponModel IsSelectedYHQ:(BOOL)isselectedYHQ SelectedID:(NSString *)selectedID {
    NSString *imageStr = @"";
    if (isselectedYHQ == YES) {
        if ([selectedID isEqualToString:couponModel.couponID]) {
            imageStr = @"used_nomalcoupon";
            self.couponValueLabel.textColor = [UIColor redColor];
        }else {
            imageStr = @"noUsed_coupon";
            self.couponValueLabel.textColor = [UIColor redColor];
        }
    }
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    self.couponValueLabel.text = [NSString stringWithFormat:@"¥%@",couponModel.coupon_value];
    self.couponUsefeeLabel.text = couponModel.use_fee_des;
    self.couponProsdescLabel.text = couponModel.pros_desc;
    self.couponCreatedTimeLabel.text = [self composeString:couponModel.created];
    self.couponDeadLineLabel.text = [self composeString:couponModel.deadline];
}

- (NSString *)composeString:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *string1 = [arr componentsJoinedByString:@" "];
    NSString *string2 = [string1 substringWithRange:NSMakeRange(0,16)];
    return string2;
}



@end

/**
 *  未使用 {
           |-->   noUsed_coupon@2x
    未选中--|-->   used_nomalcoupon@2x
    选中           used_selectedcoupon@2x
 }
    已过期 -- >   outDate_coupon@2x
 
    已使用 -- >   used_coupon@2x
 
    选择优惠券 -->
 */



















































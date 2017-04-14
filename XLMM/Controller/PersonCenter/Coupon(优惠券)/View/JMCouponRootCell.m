//
//  JMCouponRootCell.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponRootCell.h"
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
@property (nonatomic, strong) UILabel *couponTypeLabel;
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
    self.couponValueLabel.font = [UIFont systemFontOfSize:30.];
    
    UILabel *couponUsefeeLabel = [UILabel new];
    [self.couponBackImage addSubview:couponUsefeeLabel];
    self.couponUsefeeLabel = couponUsefeeLabel;
    self.couponUsefeeLabel.font = [UIFont systemFontOfSize:12.];
    self.couponUsefeeLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *couponProsdescLabel = [UILabel new];
    [self.couponBackImage addSubview:couponProsdescLabel];
    self.couponProsdescLabel = couponProsdescLabel;
    self.couponProsdescLabel.font = [UIFont systemFontOfSize:12.];
    self.couponProsdescLabel.textColor = [UIColor buttonTitleColor];
    
    NSString *heightStr = @"优惠券";
    CGFloat counpTypeHeight = [heightStr heightWithWidth:SCREENWIDTH andFont:12.].height;
    UIView *counpTypeView = [UIView new];
    [self.couponBackImage addSubview:counpTypeView];
    
    UILabel *couponTypeLabel = [UILabel new];
    [counpTypeView addSubview:couponTypeLabel];
    self.couponTypeLabel = couponTypeLabel;
    self.couponTypeLabel.font = [UIFont systemFontOfSize:12.];
    self.couponTypeLabel.textColor = [UIColor buttonTitleColor];
    self.couponTypeLabel.numberOfLines = 2;
    
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
    CGFloat spaceLeft = HomeCategoryRatio * 55;
    
    [self.couponBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(@100);
    }];
    
    [self.couponValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponBackImage).offset(spaceLeft);
        make.top.equalTo(weakSelf.couponBackImage).offset(5);
        make.width.mas_equalTo(@(80));
    }];
    
    [self.couponProsdescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponValueLabel.mas_right).offset(0);
        make.top.equalTo(weakSelf.couponBackImage).offset(5);
    }];
    [self.couponUsefeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.couponProsdescLabel.mas_bottom).offset(3);
        make.left.equalTo(weakSelf.couponProsdescLabel);
    }];
    [counpTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.couponUsefeeLabel.mas_bottom).offset(3);
        make.left.equalTo(weakSelf.couponValueLabel);
        make.right.equalTo(weakSelf.couponBackImage).offset(-5);
        make.height.mas_equalTo(@(counpTypeHeight * 2));
    }];
    [self.couponTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(counpTypeView.mas_centerY);
        make.left.right.equalTo(counpTypeView);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.couponBackImage).offset(-20);
        make.centerY.equalTo(weakSelf.couponValueLabel.mas_centerY);
    }];
    
    [deadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponBackImage).offset(spaceLeft);
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
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
    }else if (index == 3) {
        //已过期
        imageStr = @"outDate_coupon";
        self.couponValueLabel.textColor = [UIColor timeLabelColor];
    }else if (index == 8) {
        //未使用优惠券
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
        self.rightImage.hidden = NO;
    }else {
        imageStr = @"noUsed_coupon";
        self.couponValueLabel.textColor = [UIColor redColor];
    }
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    self.couponValueLabel.text = [NSString stringWithFormat:@"¥%.2f",[couponModel.coupon_value floatValue]];
    CGSize sizeToFit = [self.couponValueLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.]} context:nil].size;
    CGFloat valueWidth = sizeToFit.width + 5;
    [self.couponValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(@(valueWidth));
    }];
    
    self.couponUsefeeLabel.text = couponModel.use_fee_des;
    self.couponProsdescLabel.text = couponModel.pros_desc;
    self.couponTypeLabel.text = couponModel.title;
    self.couponCreatedTimeLabel.text = [self composeString:couponModel.created];
    self.couponDeadLineLabel.text = [self composeString:couponModel.deadline];
    
    
}
- (void)configUsableData:(JMCouponModel *)couponModel IsSelectedYHQ:(BOOL)isselectedYHQ SelectedID:(NSString *)selectedID Index:(NSInteger)index {
    NSString *imageStr = @"";
    if (index == 0) {
        imageStr = @"noUsed_coupon";
        if (isselectedYHQ == YES) {
            NSArray *selectedIDArr = [selectedID componentsSeparatedByString:@"/"];
            NSString *selectedFirstID = selectedIDArr[0];
            if ([selectedFirstID isEqualToString:couponModel.couponID]) {
                imageStr = @"used_nomalcoupon";
                self.couponValueLabel.textColor = [UIColor redColor];
            }else {
                imageStr = @"noUsed_coupon";
                self.couponValueLabel.textColor = [UIColor redColor];
            }
        }else {
            imageStr = @"noUsed_coupon";
            self.couponValueLabel.textColor = [UIColor redColor];
        }
    }else {
        imageStr = @"newyouhuiquanbukeyongbg";
    }
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    self.couponValueLabel.text = [NSString stringWithFormat:@"¥%.2f",[couponModel.coupon_value floatValue]];
    CGSize sizeToFit = [self.couponValueLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.]} context:nil].size;
    CGFloat valueWidth = sizeToFit.width + 5;
    [self.couponValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(@(valueWidth));
    }];

    self.couponUsefeeLabel.text = couponModel.use_fee_des;
    self.couponProsdescLabel.text = couponModel.pros_desc;
    self.couponTypeLabel.text = couponModel.title;
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



















































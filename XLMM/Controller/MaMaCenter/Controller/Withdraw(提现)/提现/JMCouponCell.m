//
//  JMCouponCell.m
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponCell.h"
#import "MMClass.h"

@interface JMCouponCell ()






@end

@implementation JMCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *couponImage = [UIImageView new];
    [self.contentView addSubview:couponImage];
    self.couponImage = couponImage;
    
    UILabel *moneyLabel = [UILabel new];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *goforLabel = [UILabel new];
    [self.contentView addSubview:goforLabel];
    goforLabel.text = @"全场通用";
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    timeLabel.text = @"使用期限：一个月";
    
    kWeakSelf
    
    [self.couponImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(5);
        make.width.mas_equalTo(SCREENWIDTH - 10);
        make.height.mas_equalTo(100);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponImage).offset(60);
        make.top.equalTo(weakSelf.couponImage);
    }];
    
    [goforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moneyLabel.mas_right).offset(10);
        make.top.equalTo(weakSelf.couponImage).offset(40);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moneyLabel);
        make.bottom.equalTo(weakSelf.couponImage).offset(-10);
    }];
    
    
    
    
}


@end







































































































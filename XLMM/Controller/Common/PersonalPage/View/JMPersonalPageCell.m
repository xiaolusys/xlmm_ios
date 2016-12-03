//
//  JMPersonalPageCell.m
//  XLMM
//
//  Created by zhang on 16/11/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPersonalPageCell.h"

@interface JMPersonalPageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *orderNumLabel;


@end

@implementation JMPersonalPageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView {
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = CS_SYSTEMFONT(16.);
    self.titleLabel = titleLabel;
    
    UILabel *orderNumLabel  = [UILabel new];
    [self.contentView addSubview:orderNumLabel];
    orderNumLabel.textColor = [UIColor whiteColor];
    orderNumLabel.textAlignment = NSTextAlignmentCenter;
    orderNumLabel.font = CS_SYSTEMFONT(12.);
    orderNumLabel.hidden = YES;
    self.orderNumLabel = orderNumLabel;
    
    kWeakSelf
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.centerY.equalTo(iconImageView.mas_centerY);
    }];
    [orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-30);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    
    
}

- (void)config:(NSDictionary *)dic Section:(NSInteger)section Index:(NSInteger)index {
    self.iconImageView.image = [UIImage imageNamed:dic[@"iconImage"]];
    self.titleLabel.text = dic[@"title"];
    
    NSString *orderNumString = dic[@"orderNum"];
    if ([orderNumString integerValue] != 0) {
        self.orderNumLabel.hidden = NO;
        CGSize sizeToFit = [CS_STRING(orderNumString) boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]} context:nil].size;
        CGFloat numW = sizeToFit.width + 5;
        [self.orderNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@(numW));
        }];
        self.orderNumLabel.layer.cornerRadius = numW / 2;
        self.orderNumLabel.layer.masksToBounds = YES;
        self.orderNumLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
        self.orderNumLabel.text = CS_STRING(orderNumString);
    }else {
        self.orderNumLabel.hidden = YES;
    }
    
    
}




@end



























































































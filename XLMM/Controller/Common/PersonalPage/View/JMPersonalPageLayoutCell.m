//
//  JMPersonalPageLayoutCell.m
//  XLMM
//
//  Created by zhang on 16/11/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPersonalPageLayoutCell.h"

@interface JMPersonalPageLayoutCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *orderNumLabel;


@end

@implementation JMPersonalPageLayoutCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChildUI];
    }
    return self;
}

- (void)setUpChildUI {
    kWeakSelf
    
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = CS_SYSTEMFONT(12.);
    self.titleLabel = titleLabel;
    
    self.orderNumLabel = [UILabel new];
    [self.iconImageView addSubview:self.orderNumLabel];
    self.orderNumLabel.textColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    self.orderNumLabel.backgroundColor = [UIColor whiteColor];
    self.orderNumLabel.textAlignment = NSTextAlignmentCenter;
    self.orderNumLabel.font = CS_BOLDSYSTEMFONT(11.);
    self.orderNumLabel.layer.masksToBounds = YES;
    self.orderNumLabel.layer.cornerRadius = 9.;
    self.orderNumLabel.layer.borderWidth = 1.5;
    self.orderNumLabel.layer.borderColor = [UIColor colorWithR:255 G:56 B:64 alpha:1].CGColor;
    self.orderNumLabel.hidden = YES;
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.height.mas_equalTo(@24);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(15);
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImageView).offset(10);
        make.centerY.equalTo(weakSelf.iconImageView).offset(-10);
        make.width.height.mas_equalTo(@(18));
    }];
    
}


- (void)config:(NSDictionary *)dict {
    self.iconImageView.image = [UIImage imageNamed:dict[@"iconImage"]];
    self.titleLabel.text = dict[@"title"];
    
    NSString *orderNumString = dict[@"orderNum"];
    if ([orderNumString integerValue] != 0) {
        self.orderNumLabel.hidden = NO;
        self.orderNumLabel.text = CS_STRING(orderNumString);
    }else {
        self.orderNumLabel.hidden = YES;
    }

    
    
    
    

}








@end









































































































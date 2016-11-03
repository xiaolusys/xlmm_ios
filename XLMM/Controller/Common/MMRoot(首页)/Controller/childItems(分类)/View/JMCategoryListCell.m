//
//  JMCategoryListCell.m
//  XLMM
//
//  Created by zhang on 16/8/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCategoryListCell.h"

@interface JMCategoryListCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLbael;

@end

@implementation JMCategoryListCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    self.titleLbael = titleLabel;
    
    
    kWeakSelf
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.height.mas_equalTo(@(SCREENWIDTH * 0.2));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    
    
    
    
}

- (void)setItemsDic:(NSDictionary *)itemsDic {
    _itemsDic = itemsDic;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[itemsDic[@"cat_pic"] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.titleLbael.text = itemsDic[@"name"];
    
    
}



@end







































































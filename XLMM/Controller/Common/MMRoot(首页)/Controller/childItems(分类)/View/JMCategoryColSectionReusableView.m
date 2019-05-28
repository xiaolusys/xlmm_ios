//
//  JMCategoryColSectionReusableView.m
//  XLMM
//
//  Created by zhang on 17/2/18.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMCategoryColSectionReusableView.h"

@interface JMCategoryColSectionReusableView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JMCategoryColSectionReusableView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UILabel *titleLabel = [UILabel new];
    self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:16.];
    titleLabel.textColor = [UIColor buttonTitleColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    kWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

@end

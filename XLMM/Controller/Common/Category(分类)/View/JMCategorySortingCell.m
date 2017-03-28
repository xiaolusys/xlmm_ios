//
//  JMCategorySortingCell.m
//  XLMM
//
//  Created by zhang on 17/3/18.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMCategorySortingCell.h"

@implementation JMCategorySortingCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor countLabelColor].CGColor;
        
        
        self.titlLabel = [UILabel new];
        self.titlLabel.font = [UIFont systemFontOfSize:14.];
        self.titlLabel.textColor = [UIColor buttonTitleColor];
        [self addSubview:self.titlLabel];
        
        self.iconImageView = [UIImageView new];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
        [self addSubview:self.iconImageView];
        
        self.selectedImageView = [UIImageView new];
        self.selectedImageView.image = [UIImage imageNamed:@"categoryPauxu"];
        self.selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.selectedImageView.clipsToBounds = YES;
        self.selectedImageView.hidden = YES;
        [self addSubview:self.selectedImageView];
        
        
        kWeakSelf
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.height.mas_equalTo(@(24));
        }];
        [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(20);
            make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        }];
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-20);
            make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
            make.width.height.mas_equalTo(@(24));
        }];
        
        
        
    }
    return self;
}

@end

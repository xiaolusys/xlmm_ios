//
//  JMAddressIDCardCell.m
//  XLMM
//
//  Created by zhang on 17/3/6.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMAddressIDCardCell.h"

@implementation JMAddressIDCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [UIImageView new];
//        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
//        self.clipsToBounds = YES;
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"deletaBtnIcon"] forState:UIControlStateNormal];
//        _deleteBtn.frame = CGRectMake(self.mj_w - 36, 0, 36, 36);
//        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
//        _deleteBtn.alpha = 0.6;
        [self.contentView addSubview:_deleteBtn];
        
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:10.];
        _titleLabel.textColor = [UIColor buttonTitleColor];
        [self.contentView addSubview:_titleLabel];
        
        kWeakSelf
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(10);
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
            make.width.height.mas_equalTo(@(70));
        }];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-10);
            make.top.equalTo(weakSelf.contentView).offset(10);
            make.width.height.mas_equalTo(@(30));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
            make.bottom.equalTo(weakSelf.contentView).offset(-5);
        }];
        
        
        
        
        
        
        
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _imageView.frame = self.bounds;
//
//}



@end








































//
//  JMSearchHeaderView.m
//  XLMM
//
//  Created by zhang on 17/1/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchHeaderView.h"

@implementation JMSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    UILabel *titleL = [UILabel new];
    [self addSubview:titleL];
    titleL.textColor = [UIColor textDarkGrayColor];
    titleL.font = [UIFont systemFontOfSize:14.];
    titleL.text = @"历史搜索";
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    UIImageView *imageV = [UIImageView new];
    [deleteButton addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"deleteSearchHistory"];
    
    kWeakSelf
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-5);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(@(40));
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(deleteButton);
    }];
    
    
    
    
}
- (void)deleteButtonClick:(UIButton *)button {
    if (self.block) {
        self.block(button);
    }
}

@end

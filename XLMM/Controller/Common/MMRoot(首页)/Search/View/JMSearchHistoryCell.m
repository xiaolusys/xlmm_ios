//
//  JMSearchHistoryCell.m
//  XLMM
//
//  Created by zhang on 17/1/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchHistoryCell.h"
#import "JMSearchHistoryModel.h"


@interface JMSearchHistoryCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JMSearchHistoryCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.backgroundColor = [UIColor lineGrayColor];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:13.];
    self.titleLabel.textColor = [UIColor textDarkGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.layer.masksToBounds = YES;
//    self.titleLabel.layer.cornerRadius = 5.f;
//    self.titleLabel.backgroundColor = [UIColor lineGrayColor];
    
    
    kWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.left.equalTo(weakSelf).offset(5);
//        make.height.mas_equalTo(@(35));
    }];
    
    
    
}
- (void)setModel:(JMSearchHistoryModel *)model {
    _model = model;
    self.titleLabel.text = model.content;
    
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(@(model.cellWidth));
//    }];
    
}

@end


















//
//  JMGeneralCell.m
//  XLMM
//
//  Created by zhang on 16/12/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGeneralCell.h"

NSString *const JMGeneralCellIdentifier = @"JMGeneralCellIdentifier";

@implementation JMGeneralCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor buttonTitleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.];
    
    self.descTitleLabel = [UILabel new];
    [self.contentView addSubview:self.descTitleLabel];
    self.descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    self.descTitleLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *line = [UILabel new];
    [self.contentView addSubview:line];
    line.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    
    kWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(0.5));
    }];
    
    
    
    
}



@end

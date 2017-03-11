//
//  JMPushingDaysHeaderView.m
//  XLMM
//
//  Created by zhang on 17/3/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMPushingDaysHeaderView.h"
#import "JMSharePicModel.h"

@interface JMPushingDaysHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;

@end

@implementation JMPushingDaysHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:16.];
        self.titleLabel.textColor = [UIColor blackColor];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:13.];
        self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
        
        self.descTitleLabel = [UILabel new];
        self.descTitleLabel.font = [UIFont systemFontOfSize:15.];
        self.descTitleLabel.textColor = [UIColor buttonTitleColor];
        self.descTitleLabel.numberOfLines = 0;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.descTitleLabel];
        
        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf).offset(10);
            make.width.mas_equalTo(@(SCREENWIDTH - 20));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        }];
        [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(@(SCREENWIDTH - 20));
        }];
        
        
    }
    return self;
}



- (void)setModel:(JMSharePicModel *)model {
    _model = model;
    self.titleLabel.text = model.title_content;
    self.timeLabel.text = [NSString jm_cutOutYearWihtSec:model.start_time];
    self.descTitleLabel.text = model.descriptionTitle;
}

@end


















































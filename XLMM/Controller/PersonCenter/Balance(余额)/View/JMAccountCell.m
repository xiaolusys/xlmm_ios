//
//  JMAccountCell.m
//  XLMM
//
//  Created by zhang on 16/12/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAccountCell.h"
#import "AccountModel.h"


@interface JMAccountCell ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation JMAccountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.statusLabel = [UILabel new];
    [self.contentView addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.statusLabel.font = [UIFont systemFontOfSize:12.];
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.];
    
    self.sourceLabel = [UILabel new];
    [self.contentView addSubview:self.sourceLabel];
    self.sourceLabel.textColor = [UIColor buttonTitleColor];
    self.sourceLabel.numberOfLines = 0;
    self.sourceLabel.font = [UIFont systemFontOfSize:14.];
    
    self.moneyLabel = [UILabel new];
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:16.];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    
    self.bottomLabel = [UILabel new];
    [self.contentView addSubview:self.bottomLabel];
    self.bottomLabel.backgroundColor = [UIColor countLabelColor];
    
    kWeakSelf
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.statusLabel.mas_centerY);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusLabel);
        make.top.equalTo(weakSelf.statusLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.statusLabel.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.width.mas_equalTo(@120);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.contentView).offset(-1);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@1);
    }];
    
    
    
}


- (void)fillDataOfCell:(AccountModel *)accountM {
    self.statusLabel.text = accountM.get_status_display;
    self.timeLabel.text = accountM.budget_date;
    self.sourceLabel.text = accountM.desc;
    
    if ([accountM.budget_type boolValue]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"- %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor textDarkGrayColor];
    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor orangeThemeColor];
    }
    
    
}



@end
































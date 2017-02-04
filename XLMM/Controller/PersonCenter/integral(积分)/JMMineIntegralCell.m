//
//  JMMineIntegralCell.m
//  XLMM
//
//  Created by zhang on 16/9/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMineIntegralCell.h"
#import "JMMineIntegralModel.h"

@interface JMMineIntegralCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *orderLabel;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JMMineIntegralCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor countLabelColor];
        [self initUI];
        
    }
    return self;
}

- (void)initUI {
    kWeakSelf
    
//    UILabel *titleLabel = [UILabel new];
//    [self.contentView addSubview:titleLabel];
//    titleLabel.font = [UIFont systemFontOfSize:14.];
//    titleLabel.textColor = [UIColor buttonTitleColor];
//    titleLabel.text = @"购物订单完成奖励积分";
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12.];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    
//    self.orderLabel = [UILabel new];
//    [self.contentView addSubview:self.orderLabel];
//    self.orderLabel.font = [UIFont systemFontOfSize:14.];
//    self.orderLabel.textColor = [UIColor buttonTitleColor];
    
    self.descLabel = [UILabel new];
    [self.contentView addSubview:self.descLabel];
    self.descLabel.font = [UIFont systemFontOfSize:14.];
    self.descLabel.textColor = [UIColor buttonTitleColor];
    
    
    self.valueLabel = [UILabel new];
    [self.contentView addSubview:self.valueLabel];
    self.valueLabel.font = [UIFont systemFontOfSize:16.];
    self.valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *lineLabel = [UILabel new];
    [self.contentView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor lineGrayColor];
    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.contentView).offset(15);
//        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(10);
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLabel);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(10);
    }];
    
//    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleLabel);
//        make.top.equalTo(titleLabel.mas_bottom).offset(5);
//    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];

    
}

- (void)configIntegral:(JMMineIntegralModel *)model {
    self.timeLabel.text = [NSString jm_deleteTimeWithT:model.created];
//    self.orderLabel.text = [NSString stringWithFormat:@"订单号  %@",[model.order_info objectForKey:@"order_id"]];
    CGFloat amountValue = [model.amount floatValue] / 100.00;
    if ([model.iro_type isEqual:@"支出"]) {
        self.valueLabel.text = [NSString stringWithFormat:@"-%.1f",amountValue];
    }else {
        self.valueLabel.text = [NSString stringWithFormat:@"+%.1f",amountValue];
    }
    self.descLabel.text = model.subject;
    
    
    
    
    
}





@end



































































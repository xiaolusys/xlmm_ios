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
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.text = @"购物订单完成奖励积分";
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12.];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    self.orderLabel = [UILabel new];
    [self.contentView addSubview:self.orderLabel];
    self.orderLabel.font = [UIFont systemFontOfSize:14.];
    self.orderLabel.textColor = [UIColor buttonTitleColor];
    
    self.valueLabel = [UILabel new];
    [self.contentView addSubview:self.valueLabel];
    self.valueLabel.font = [UIFont systemFontOfSize:16.];
    self.valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *lineLabel = [UILabel new];
    [self.contentView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor lineGrayColor];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(titleLabel.mas_top).offset(-5);
    }];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
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
    self.timeLabel.text = [self replaceString:model.created];
    self.orderLabel.text = [NSString stringWithFormat:@"订单号  %@",[model.order_info objectForKey:@"order_id"]];
    self.valueLabel.text = [NSString stringWithFormat:@"+%@分",model.log_value];
    
}

- (NSString *)replaceString:(NSString *)string{
    if ([NSString isStringEmpty:string]) {
        return @"";
    }
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:string];
    NSRange range = {10, 1};
    [mutableStr replaceCharactersInRange:range withString:@" "];
    return mutableStr;
}





@end



































































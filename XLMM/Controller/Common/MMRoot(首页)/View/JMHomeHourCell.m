//
//  JMHomeHourCell.m
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeHourCell.h"
#import "JMHomeHourModel.h"


@interface JMHomeHourCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *profitLabel;

@end

@implementation JMHomeHourCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartCurrentTapAction:)];
//    [self.iconImage addGestureRecognizer:tap];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.textColor = [UIColor settingBackgroundColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.titleLabel.numberOfLines = 2;
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont systemFontOfSize:14.];
    self.PriceLabel.textColor = [UIColor settingBackgroundColor];
    
    UILabel *profitLabel = [UILabel new];
    [self.contentView addSubview:profitLabel];
    self.profitLabel = profitLabel;
    self.profitLabel.font = [UIFont systemFontOfSize:13.];
    self.profitLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *lineLabel = [UILabel new];
    [self.contentView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@(80));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(12);
        //        make.width.mas_equalTo(@(SCREENWIDTH - 120));
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.profitLabel.mas_top).offset(-5);
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.iconImage.mas_bottom).offset(-5);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, 0.5));
    }];
    
}




- (void)setModel:(JMHomeHourModel *)model {
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[model.pic imageGoodsOrderCompression] JMUrlEncodedString]]];
    self.titleLabel.text = model.name;
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
    NSDictionary *profitDic = model.profit;
    self.profitLabel.text = [NSString stringWithFormat:@"利润:¥%.1f ~ ¥%.1f",[profitDic[@"min"] floatValue],[profitDic[@"max"] floatValue]];
    
    
}


@end









































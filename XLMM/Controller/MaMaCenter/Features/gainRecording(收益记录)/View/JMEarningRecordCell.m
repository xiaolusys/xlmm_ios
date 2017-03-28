//
//  JMEarningRecordCell.m
//  XLMM
//
//  Created by zhang on 17/3/2.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMEarningRecordCell.h"
#import "CarryLogModel.h"
#import "JMEarningModel.h"


@interface JMEarningRecordCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *earningLabel;

@end

@implementation JMEarningRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor lineGrayColor].CGColor;
//    UIImageView *iconImageView = [UIImageView new];
//    iconImageView.layer.masksToBounds = YES;
//    iconImageView.layer.cornerRadius = 22.f;
//    [self.contentView addSubview:iconImageView];
//    self.iconImageView = iconImageView;
    
//    UILabel *statusLabel = [UILabel new];
//    statusLabel.font = [UIFont systemFontOfSize:13.];
//    statusLabel.textColor = [UIColor orangeColor];
//    [self.contentView addSubview:statusLabel];
//    self.statusLabel = statusLabel;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:13.];
    nameLabel.textColor = [UIColor dingfanxiangqingColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:13.];
    descLabel.textColor = [UIColor buttonTitleColor];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
//    UILabel *timeLabel = [UILabel new];
//    timeLabel.font = [UIFont systemFontOfSize:13.];
//    timeLabel.textColor = [UIColor buttonTitleColor];
//    [self.contentView addSubview:timeLabel];
//    self.timeLabel = timeLabel;
    
    UILabel *earningLabel = [UILabel new];
    earningLabel.font = [UIFont systemFontOfSize:18.];
    earningLabel.textColor = [UIColor buttonTitleColor];
    [self.contentView addSubview:earningLabel];
    self.earningLabel = earningLabel;
    
    kWeakSelf
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.contentView).offset(10);
//        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//        make.width.height.mas_equalTo(@(44));
//    }];
//    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
//        make.top.equalTo(weakSelf.iconImageView);
//    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(15);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
        make.width.mas_equalTo(@(SCREENWIDTH - 120));
    }];
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.centerY.equalTo(weakSelf.statusLabel.mas_centerY);
//    }];
    [self.earningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    
    
}
- (void)configEarningModel:(JMEarningModel *)model {
    self.nameLabel.text = [NSString jm_subWithHourMinuteSe:model.created];
    self.descLabel.text = model.type;
    self.earningLabel.text = [NSString stringWithFormat:@"+%.2f", ([model.amount floatValue] / 100.f)];
}

- (void)configModel:(CarryLogModel *)model Index:(NSInteger)index {
//    if (model == nil) {
//        return ;
//    }
    self.earningLabel.text = [NSString stringWithFormat:@"+%.2f", [model.carry_value floatValue]];
    self.statusLabel.text = model.status_display;
    self.descLabel.text = model.carry_description;
    NSInteger carry_type = [model.carry_type integerValue];
    switch (index) {
        case 0:
            self.timeLabel.hidden = YES;
            self.nameLabel.text = [NSString jm_subWithHourAndMinute:model.created];
            if (carry_type == 1) {
                self.iconImageView.image = [UIImage imageNamed:@"mamafan"];
            }else if (carry_type == 2) {
                self.iconImageView.image = [UIImage imageNamed:@"mamayong"];
            }else {
                self.iconImageView.image = [UIImage imageNamed:@"mamajiang"];
            }
            break;
        case 1:
            self.timeLabel.hidden = NO;
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.contributor_img JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
            self.nameLabel.text = model.contributor_nick;
            self.timeLabel.text = [NSString jm_subWithHourAndMinute:model.created];
            break;
        case 2:
            self.iconImageView.image = [UIImage imageNamed:@"mamafan"];
            self.nameLabel.text = [NSString jm_subWithHourAndMinute:model.created];
            self.timeLabel.hidden = YES;
            break;
        case 3:
            self.timeLabel.hidden = NO;
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.contributor_img JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
            self.nameLabel.text = model.contributor_nick;
            self.timeLabel.text = [NSString jm_subWithHourAndMinute:model.created];
            break;
            
        default:
            break;
    }
    
    
    
    
}

@end







































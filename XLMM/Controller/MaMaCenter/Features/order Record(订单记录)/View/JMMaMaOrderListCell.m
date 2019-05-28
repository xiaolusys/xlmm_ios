//
//  JMMaMaOrderCell.m
//  XLMM
//
//  Created by zhang on 16/5/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaOrderListCell.h"
#import "MaMaOrderModel.h"



@interface JMMaMaOrderListCell ()

/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *iconImageView;
/**
 *  买家
 */
@property (nonatomic,strong) UILabel *userName;
/**
 *  付款状态
 */
@property (nonatomic,strong) UILabel *payState;
/**
 *  时间
 */
@property (nonatomic,strong) UILabel *timeLabel;
/**
 *  是否显示APP
 */
@property (nonatomic,strong) UILabel *isAPP;
/**
 *  实际支付
 */
@property (nonatomic,strong) UILabel *actualPay;
/**
 *  收益
 */
@property (nonatomic,strong) UILabel *incomeLabel;
/**
 *  扣除
 */
@property (nonatomic,strong) UILabel *deductLabel;

@property (nonatomic, strong) UILabel *skuNameLabel;


@end

@implementation JMMaMaOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        [self setUpData];
    }
    return self;
}

- (void)setUpUI {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor countLabelColor].CGColor;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
    UILabel *isAPP = [[UILabel alloc] init];
    [self.contentView addSubview:isAPP];
    self.isAPP = isAPP;
    self.isAPP.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.isAPP.textColor = [UIColor whiteColor];
    self.isAPP.font = [UIFont systemFontOfSize:12.];
    
    UILabel *skuNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:skuNameLabel];
    self.skuNameLabel = skuNameLabel;
    self.skuNameLabel.font = [UIFont boldSystemFontOfSize:12.];
    self.skuNameLabel.textColor = [UIColor textDarkGrayColor];
    
    UILabel *userName = [[UILabel alloc] init];
    [self.contentView addSubview:userName];
    self.userName = userName;
    self.userName.font = [UIFont boldSystemFontOfSize:14.];
    
    UILabel *payState = [[UILabel alloc] init];
    [self.contentView addSubview:payState];
    self.payState  = payState;
    self.payState.font = [UIFont boldSystemFontOfSize:14.];
    self.payState.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.textColor = [UIColor timeLabelColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.];
    
    UILabel *actualPay = [[UILabel alloc] init];
    [self.contentView addSubview:actualPay];
    self.actualPay = actualPay;
    self.actualPay.textColor = [UIColor timeLabelColor];
    self.actualPay.font = [UIFont systemFontOfSize:12.];
    
    UILabel *incomeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:incomeLabel];
    self.incomeLabel = incomeLabel;
    self.incomeLabel.textColor = [UIColor timeLabelColor];
    self.incomeLabel.font = [UIFont systemFontOfSize:12.];
    
    UILabel *deductLabel = [[UILabel alloc] init];
    [self.contentView addSubview:deductLabel];
    self.deductLabel = deductLabel;
    self.deductLabel.textColor = [UIColor redColor];
    
}
- (void)setUpData {
    kWeakSelf
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@70);
    }];
    [self.skuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        make.width.mas_equalTo(@(100));
    }];
    [self.payState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.userName.mas_centerY);
        make.left.equalTo(weakSelf.userName.mas_right).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.userName.mas_centerY);
    }];
    
    [self.isAPP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom);
    }];
    
    [self.actualPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.isAPP.mas_centerY);
        make.left.equalTo(weakSelf.isAPP.mas_right).offset(10);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actualPay.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.actualPay.mas_centerY);
    }];
    [self.deductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.actualPay.mas_centerY);
    }];
    
    
}



- (void)fillDataOfCell:(MaMaOrderModel *)orderM {
    //    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:100];
    
    //    self.isAPP = imageView;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[orderM.sku_img JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.userName.text = orderM.contributor_nick;
    self.skuNameLabel.text = orderM.sku_name;
    if ([orderM.carry_type intValue] == 1) {
        self.isAPP.text = @"";
    }else if([orderM.carry_type intValue] == 2) {
        self.isAPP.text = @"APP";
    }else if([orderM.carry_type intValue] == 3 || [orderM.carry_type intValue] == 4) {
        self.isAPP.text = @"下属订单";
    }else {
        self.isAPP.text = @"";
    }
    
    //    self.isAPP.image = [UIImage imageNamed:@"isApp_orderList"];
    
    /**
     *  收益
     */
    self.incomeLabel.text = [NSString stringWithFormat:@"收益%.2f", [orderM.carry_num floatValue]];
    
    /**
     *  付款状态
     */
    self.payState.text = orderM.status_display;
    self.payState.font = [UIFont systemFontOfSize:12];
    // new add things.
    
    /**
     *  实际支付
     */
    self.actualPay.text = [NSString stringWithFormat:@"实付 %.2f", [orderM.order_value floatValue]];
    //    self.actualPay.text = orderM.carry_type_name;
    self.timeLabel.text = [NSString jm_subWithHourAndMinute:orderM.created];
    
}

@end












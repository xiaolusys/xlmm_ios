//
//  JMMaMaOrderCell.m
//  XLMM
//
//  Created by zhang on 16/5/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaOrderListCell.h"
#import "MaMaOrderModel.h"
#import "MMClass.h"



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

@property (nonatomic,assign) BOOL isAppImage;

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
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *isAPP = [[UILabel alloc] init];
    [self.contentView addSubview:isAPP];
    self.isAPP = isAPP;

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
    self.timeLabel.font = [UIFont systemFontOfSize:14.];
    
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
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    
    if (self.isAppImage == NO) {
        [self.isAPP mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
            make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-5);
        }];
        
        [self.actualPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.isAPP.mas_centerY);
            make.left.equalTo(weakSelf.isAPP.mas_right).offset(10);
        }];
    }else {
        [self.actualPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.iconImageView).offset(-5);
            make.left.equalTo(weakSelf.iconImageView.mas_right);
        }];
    }
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actualPay.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.actualPay.mas_centerY);
    }];
    
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView).offset(5);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
    }];
    
    [self.payState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.userName.mas_centerY);
        make.left.equalTo(weakSelf.userName.mas_right).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.userName.mas_centerY);
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
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userName.text = orderM.contributor_nick;
    
    if ([orderM.carry_type intValue] == 1) {

        self.isAppImage = NO;
        self.isAPP = nil;
    }else if([orderM.carry_type intValue] == 2) {

        self.isAppImage = YES;
        self.isAPP.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.isAPP.text = @"APP";
        self.isAPP.textColor = [UIColor whiteColor];
        self.isAPP.font = [UIFont systemFontOfSize:12.];
//        self.isAPP.image = [UIImage imageNamed:@"isApp_orderList"];

    }else if([orderM.carry_type intValue] == 3) {
        self.isAppImage = YES;
//        self.isAPP.image = [UIImage imageNamed:@"isApp_orderList"];
        self.isAPP.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.isAPP.text = @"下属订单";
        self.isAPP.textColor = [UIColor whiteColor];
        self.isAPP.font = [UIFont systemFontOfSize:12.];
    }else {
        
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
    
    self.timeLabel.text = [self dealDate:orderM.created];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
}

- (NSString *)dealDate:(NSString *)str {
    NSArray *strarray = [str componentsSeparatedByString:@"T"];
    NSString *hour = strarray[1];
    NSString *time = [hour substringToIndex:5];
    return time;
}

@end












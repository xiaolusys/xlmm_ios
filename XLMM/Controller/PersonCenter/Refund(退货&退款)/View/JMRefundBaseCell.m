//
//  JMRefundBaseCell.m
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundBaseCell.h"
#import "JMRefundModel.h"

NSString *const JMRefundBaseCellIdentifier = @"JMRefundBaseCellIdentifier";

@interface JMRefundBaseCell ()

@property (nonatomic, strong) UIImageView *refundImage;

@property (nonatomic, strong) UILabel *refundWayLabel;

@property (nonatomic, strong) UILabel *refundStatusLabel;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *goodsTitleLabel;

@property (nonatomic, strong) UILabel *goodsSizeLabel;

@property (nonatomic, strong) UILabel *goodsPaymentLabel;

@property (nonatomic, strong) UILabel *goodsRefundMoneyLabel;

@property (nonatomic, strong) UILabel *goodsNumLabel;

@property (nonatomic, strong) UIImageView *refunStatusImage;

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation JMRefundBaseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    // == 组头视图 == //
    UIView *sectionView = [UIView new];
    [self.contentView addSubview:sectionView];
    self.sectionView = sectionView;
    
    UIImageView *refundImage = [UIImageView new];
    [sectionView addSubview:refundImage];
    self.refundImage = refundImage;
    
    UILabel *refundWayLabel = [UILabel new];
    [sectionView addSubview:refundWayLabel];
    self.refundWayLabel = refundWayLabel;
    self.refundWayLabel.font = [UIFont systemFontOfSize:14.];
    self.refundWayLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *refundStatusLabel = [UILabel new];
    [sectionView addSubview:refundStatusLabel];
    self.refundStatusLabel = refundStatusLabel;
    self.refundStatusLabel.font = [UIFont systemFontOfSize:14.];
    
    UIImageView *refunStatusImage = [UIImageView new];
    [sectionView addSubview:refunStatusImage];
    self.refunStatusImage = refunStatusImage;
    self.refunStatusImage.image = [UIImage imageNamed:@"refundStatusImage"];
    self.refunStatusImage.hidden = YES;
    
    // == 行视图 == //
    UIView *rowView = [UIView new];
    [self.contentView addSubview:rowView];
    
    UIView *currentView = [UIView new];
    [rowView addSubview:currentView];
    currentView.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    
    UIImageView *iconImage = [UIImageView new];
    [rowView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *goodsTitleLabel = [UILabel new];
    [rowView addSubview:goodsTitleLabel];
    self.goodsTitleLabel = goodsTitleLabel;
    self.goodsTitleLabel.font = [UIFont systemFontOfSize:12.];
    self.goodsTitleLabel.textColor = [UIColor buttonTitleColor];
    self.goodsTitleLabel.numberOfLines = 2;
    
    UILabel *goodsSizeLabel = [UILabel new];
    [rowView addSubview:goodsSizeLabel];
    self.goodsSizeLabel = goodsSizeLabel;
    self.goodsSizeLabel.font = [UIFont systemFontOfSize:12.];
    self.goodsSizeLabel.textColor = [UIColor dingfanxiangqingColor];

    UILabel *goodsPaymentLabel = [UILabel new];
    [rowView addSubview:goodsPaymentLabel];
    self.goodsPaymentLabel = goodsPaymentLabel;
    self.goodsPaymentLabel.font = [UIFont systemFontOfSize:12.];
    self.goodsPaymentLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *goodsRefundMoneyLabel = [UILabel new];
    [rowView addSubview:goodsRefundMoneyLabel];
    self.goodsRefundMoneyLabel = goodsRefundMoneyLabel;
    self.goodsRefundMoneyLabel.font = [UIFont systemFontOfSize:12.];
    self.goodsRefundMoneyLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *goodsNumLabel = [UILabel new];
    [rowView addSubview:goodsNumLabel];
    self.goodsNumLabel = goodsNumLabel;
    self.goodsNumLabel.font = [UIFont systemFontOfSize:12.];
    self.goodsNumLabel.textColor = [UIColor buttonTitleColor];
    
    // == 分割线视图 == //
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    self.lineView = lineView;
    
    kWeakSelf
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@35);
    }];
    [self.refundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(15);
        make.centerY.equalTo(sectionView.mas_centerY);
        make.width.height.mas_equalTo(@15);
    }];
    [self.refundWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.refundImage.mas_right).offset(10);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    [self.refundStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView).offset(-15);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    [self.refunStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.refundStatusLabel.mas_left);
        make.centerY.equalTo(sectionView.mas_centerY);
        make.width.height.mas_equalTo(@12);
    }];
    
    [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(sectionView.mas_bottom);
        make.height.mas_equalTo(@110);
    }];
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(rowView);
        make.height.mas_equalTo(@1);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rowView).offset(15);
        make.centerY.equalTo(rowView.mas_centerY);
        make.width.height.mas_equalTo(@90);
    }];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.right.equalTo(rowView).offset(-10);
        make.top.equalTo(weakSelf.iconImage);
    }];

    [self.goodsSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsTitleLabel);
        make.top.equalTo(weakSelf.goodsTitleLabel.mas_bottom).offset(5);
    }];
    [self.goodsPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsTitleLabel);
        make.bottom.equalTo(weakSelf.goodsRefundMoneyLabel.mas_top).offset(-2);
    }];
    [self.goodsRefundMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsTitleLabel);
//        make.centerY.equalTo(weakSelf.goodsPaymentLabel.mas_centerY);
        make.bottom.equalTo(weakSelf.iconImage.mas_bottom);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(rowView.mas_bottom);
        make.height.mas_equalTo(@15);
    }];
    
    
    
    
}




- (void)configRefund:(JMRefundModel *)refundModel {
    //has_good_return == 1 退货
    BOOL isGoodsReturn = ([refundModel.has_good_return integerValue] == 0);
    NSString *refundImageStr = @"";
    
    NSArray *statusShaftArr = refundModel.status_shaft;
    NSInteger count = statusShaftArr.count - 1;
    if (statusShaftArr.count == 0) {
        return ;
    }else {
        
        NSDictionary *statusDic = [statusShaftArr[count] mj_keyValues];
        self.refundStatusLabel.text = statusDic[@"status_display"];
    }
    
    NSInteger status = [refundModel.status integerValue];
    NSInteger goodsSatus = [refundModel.good_status integerValue];
    if (!isGoodsReturn) {
        // 退货
        refundImageStr = @"refund_tuihuoImage";
        self.refundWayLabel.text = @"退货退款";
        if (status == REFUND_STATUS_SELLER_AGREED && goodsSatus == 1) {
            self.refunStatusImage.hidden = NO;
            self.refundStatusLabel.textColor = [UIColor redColor];
            self.refundStatusLabel.text = @"请寄回商品";
        }else {
            self.refunStatusImage.hidden = YES;
            self.refundStatusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
        }
    }else {
        self.refunStatusImage.hidden = YES;
        // 退款
        if ([refundModel.refund_channel isEqualToString:@"budget"]) {
            //退款到小鹿钱包
            refundImageStr = @"refund_xiaolutuikuanImage";
            self.refundWayLabel.text = @"极速退款";
        }else {
            refundImageStr = @"refund_othertuikuan";
            self.refundWayLabel.text = @"退款";
        }
        self.refundStatusLabel.textColor = [UIColor buttonEnabledBackgroundColor];

    }
    self.refundImage.image = [UIImage imageNamed:refundImageStr];
    
    
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[refundModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    self.goodsTitleLabel.text = refundModel.title;
    self.goodsSizeLabel.text = [NSString stringWithFormat:@"尺寸:%@",refundModel.sku_name];
    CGFloat payment = [refundModel.payment floatValue];
    NSInteger goodsCount = [refundModel.refund_num integerValue];
    self.goodsPaymentLabel.text = [NSString stringWithFormat:@"交易金额:¥%.2f×%ld",payment,goodsCount];
    self.goodsRefundMoneyLabel.text = [NSString stringWithFormat:@"退款金额:¥%.2f×%ld",payment,goodsCount];
    
    
}

- (void)configRefundDetail:(JMRefundModel *)refundModel {
    [self.sectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[refundModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    self.goodsTitleLabel.text = refundModel.title;
    self.goodsSizeLabel.text = [NSString stringWithFormat:@"尺寸:%@",refundModel.sku_name];
    CGFloat payment = [refundModel.payment floatValue];
    NSInteger goodsCount = [refundModel.refund_num integerValue];
    self.goodsPaymentLabel.text = [NSString stringWithFormat:@"交易金额:¥%.2f×%ld",payment,goodsCount];
    self.goodsRefundMoneyLabel.text = [NSString stringWithFormat:@"退款金额:¥%.2f×%ld",payment,goodsCount];
}


@end










































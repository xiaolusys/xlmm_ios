//
//  JMOrderDetailFooterView.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailFooterView.h"

@interface JMOrderDetailFooterView ()
/**
 *  支付方式
 */
@property (nonatomic, strong) UIImageView *payWayImage;
/**
 *  商品总金额
 */
@property (nonatomic, strong) UILabel *goodsAllMoneyLabel;
/**
 *  优惠券
 */
@property (nonatomic, strong) UILabel *couponMoneyLabel;
/**
 *  运费
 */
@property (nonatomic, strong) UILabel *freightMoneyLabel;
/**
 *  结算
 */
@property (nonatomic, strong) UILabel *clearingMoneyLabel;
/**
 *  零钱支付
 */
@property (nonatomic, strong) UILabel *dibMoneyLabel;



@end

@implementation JMOrderDetailFooterView {
    NSString *_imageStr;
}

//+ (instancetype)enterFooterView {
//    JMOrderDetailFooterView *footerView = [[JMOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
//    return footerView;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor countLabelColor];
        [self createUI];
    }
    return self;
}
- (void)setOrderDetailModel:(JMOrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
    
    if ([orderDetailModel.channel isEqualToString:@"budget"]) {
        _imageStr = @"payWay_xiaoluPay";
    }else if ([orderDetailModel.channel isEqualToString:@"wx"]) {
        _imageStr = @"weixinIcon";
    }else if ([orderDetailModel.channel isEqualToString:@"alipay"]){
        _imageStr = @"zhifubaoiconthird";
    }else {
        
    }
    self.payWayImage.image = [UIImage imageNamed:_imageStr];
    self.goodsAllMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.total_fee floatValue]];
    self.couponMoneyLabel.text = [NSString stringWithFormat:@"－¥%.2f",[orderDetailModel.discount_fee floatValue]];
    self.freightMoneyLabel.text = [NSString stringWithFormat:@"＋¥%.2f",[orderDetailModel.post_fee floatValue]];
    CGFloat actualPayMent = [orderDetailModel.payment floatValue] - [orderDetailModel.pay_cash floatValue];
    self.clearingMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",actualPayMent];
    self.dibMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.pay_cash floatValue]];
    
}
- (void)createUI {
    // == 视图一 == //
    UIView *oneView = [UIView new];
    [self addSubview:oneView];
    
    UILabel *payWayL = [UILabel new];
    [oneView addSubview:payWayL];
    payWayL.font = [UIFont systemFontOfSize:14.];
    payWayL.textColor = [UIColor buttonTitleColor];
    payWayL.text = @"支付方式";
    
    UIImageView *payWayImage = [UIImageView new];
    [oneView addSubview:payWayImage];
    self.payWayImage = payWayImage;
    
    UILabel *goodsAllMoneyL = [UILabel new];
    [oneView addSubview:goodsAllMoneyL];
    goodsAllMoneyL.font = [UIFont systemFontOfSize:14.];
    goodsAllMoneyL.textColor = [UIColor buttonTitleColor];
    goodsAllMoneyL.text = @"商品金额";
    
    UILabel *goodsAllMoneyLabel = [UILabel new];
    [oneView addSubview:goodsAllMoneyLabel];
    self.goodsAllMoneyLabel = goodsAllMoneyLabel;
    self.goodsAllMoneyLabel.font = [UIFont systemFontOfSize:14.];
    self.goodsAllMoneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *couponMoneyL = [UILabel new];
    [oneView addSubview:couponMoneyL];
    couponMoneyL.font = [UIFont systemFontOfSize:14.];
    couponMoneyL.textColor = [UIColor buttonTitleColor];
    couponMoneyL.text = @"优惠金额";
    
    UILabel *couponMoneyLabel = [UILabel new];
    [oneView addSubview:couponMoneyLabel];
    self.couponMoneyLabel = couponMoneyLabel;
    self.couponMoneyLabel.font = [UIFont systemFontOfSize:14.];
    self.couponMoneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];

    UILabel *freightMoneyL = [UILabel new];
    [oneView addSubview:freightMoneyL];
    freightMoneyL.font = [UIFont systemFontOfSize:14.];
    freightMoneyL.textColor = [UIColor buttonTitleColor];
    freightMoneyL.text = @"运费";
    
    UILabel *freightMoneyLabel = [UILabel new];
    [oneView addSubview:freightMoneyLabel];
    self.freightMoneyLabel = freightMoneyLabel;
    self.freightMoneyLabel.font = [UIFont systemFontOfSize:14.];
    self.freightMoneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *dibMoneyL = [UILabel new];
    [oneView addSubview:dibMoneyL];
    dibMoneyL.font = [UIFont systemFontOfSize:14.];
    dibMoneyL.textColor = [UIColor buttonTitleColor];
    dibMoneyL.text = @"实付金额";
    
    UILabel *dibMoneyLabel = [UILabel new];
    [oneView addSubview:dibMoneyLabel];
    self.dibMoneyLabel = dibMoneyLabel;
    self.dibMoneyLabel.font = [UIFont systemFontOfSize:14.];
    self.dibMoneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    
    // == 视图二 == //
    UIView *twoView = [UIView new];
    [self addSubview:twoView];

    UILabel *clearingMoneyL = [UILabel new];
    [twoView addSubview:clearingMoneyL];
    clearingMoneyL.font = [UIFont systemFontOfSize:14.];
    clearingMoneyL.textColor = [UIColor buttonTitleColor];
    clearingMoneyL.text = @"零钱支付";
    
    UILabel *clearingMoneyLabel = [UILabel new];
    [twoView addSubview:clearingMoneyLabel];
    self.clearingMoneyLabel = clearingMoneyLabel;
    self.clearingMoneyLabel.font = [UIFont systemFontOfSize:18.];
    self.clearingMoneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    kWeakSelf
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@190);
    }];
    [payWayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView).offset(20);
        make.left.equalTo(oneView).offset(10);
    }];
    [self.payWayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(payWayL.mas_centerY);
        make.width.height.mas_equalTo(@22);
    }];
    [goodsAllMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payWayL.mas_bottom).offset(20);
        make.left.equalTo(oneView).offset(10);
    }];
    [self.goodsAllMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(goodsAllMoneyL.mas_centerY);
    }];
    [couponMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsAllMoneyL.mas_bottom).offset(20);
        make.left.equalTo(oneView).offset(10);
    }];
    [self.couponMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(couponMoneyL.mas_centerY);
    }];
    [freightMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(couponMoneyL.mas_bottom).offset(20);
        make.left.equalTo(oneView).offset(10);
    }];
    [self.freightMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(freightMoneyL.mas_centerY);
    }];
    [dibMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freightMoneyL.mas_bottom).offset(20);
        make.left.equalTo(oneView).offset(10);
    }];
    [self.dibMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(dibMoneyL.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 10));
        make.height.mas_equalTo(@1);
    }];
    
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@50);
    }];
    [clearingMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoView).offset(10);
        make.centerY.equalTo(twoView.mas_centerY);
    }];
    [self.clearingMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(twoView).offset(-10);
        make.centerY.equalTo(twoView.mas_centerY);
    }];
    
    
    
    
    
}







@end























































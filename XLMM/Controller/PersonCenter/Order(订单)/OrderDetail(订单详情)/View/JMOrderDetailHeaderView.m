//
//  JMOrderDetailHeaderView.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailHeaderView.h"
#import "JMOrderGoodsModel.h"
#import "JMTimeLineView.h"

@interface JMOrderDetailHeaderView ()

/**
 *  订单编号
 */
@property (nonatomic, strong) UILabel *orderNumLabel;
/**
 *  订单状态
 */
@property (nonatomic, strong) UILabel *orderStatusLabel;
/**
 *  订单创建时间
 */
@property (nonatomic, strong) UILabel *orderCreateTime;
/**
 *  地址_姓名
 */
@property (nonatomic, strong) UILabel *addressNameLabel;
/**
 *  地址_手机号
 */
@property (nonatomic, strong) UILabel *addressPhoneLabel;
/**
 *  地址_详细地址
 */
@property (nonatomic, strong) UILabel *addressDetailLabel;
/**
 *  物流选择
 */
@property (nonatomic, strong) UILabel *logisticsLabel;


@property (nonatomic, strong) UIScrollView *timeLineView;

@end


@implementation JMOrderDetailHeaderView {
    NSDictionary *_timeLineDict;
    CGFloat _timeLineH;
}


+ (instancetype)enterHeaderView {
    JMOrderDetailHeaderView *headView = [[JMOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 230)];
    return headView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (frame.size.height == 290) {
            self.isTimeLineView = YES;
        }else {
            self.isTimeLineView = NO;
        }
        [self setUpTopUI];
    }
    return self;
}

- (void)setLogisticsStr:(NSString *)logisticsStr {
    _logisticsStr = logisticsStr;
    self.logisticsLabel.text = logisticsStr;
}
- (void)setOrderDetailModel:(JMOrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
    self.orderStatusLabel.text = self.orderDetailModel.status_display;
    self.orderNumLabel.text = orderDetailModel.tid;
    self.orderCreateTime.text = [NSString jm_deleteTimeWithT:orderDetailModel.created];
    NSDictionary *addressDict = orderDetailModel.user_adress;
    self.addressNameLabel.text = addressDict[@"receiver_name"];
    self.addressPhoneLabel.text = addressDict[@"receiver_mobile"];
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",addressDict[@"receiver_state"],addressDict[@"receiver_city"],addressDict[@"receiver_district"],addressDict[@"receiver_address"]];
    self.addressDetailLabel.text = addressStr;
    
    NSDictionary *logisticsDic = orderDetailModel.logistics_company;
    if (logisticsDic.count == 0) {
        self.logisticsStr = @"小鹿推荐";
        self.logisticsLabel.text = @"小鹿推荐";
    }else {
        self.logisticsStr = logisticsDic[@"name"];
        self.logisticsLabel.text = logisticsDic[@"name"];
    }
    NSDictionary *dic = [orderDetailModel.orders[0] mj_keyValues];
    NSInteger countNum = [dic[@"status"] integerValue];
    NSInteger refundNum = [dic[@"refund_status"] integerValue];
    NSArray *desArr = [NSArray array];
    NSInteger count = 0;
    int i = 0;
    BOOL isCountNum = !(countNum == ORDER_STATUS_REFUND_CLOSE || countNum == ORDER_STATUS_TRADE_CLOSE);
    BOOL isRefundNum = (refundNum == REFUND_STATUS_NO_REFUND || refundNum == REFUND_STATUS_REFUND_CLOSE);
    if (isCountNum && isRefundNum) {
        desArr = @[@"订单创建",@"支付成功",@"产品发货",@"产品签收",@"交易完成"];
        for ( i = 0 ; i < desArr.count; i++) {
            if (countNum == i) {
                if (countNum >= 1) {
                    i --;
                }
                break;
            }else {
                continue;
            }
        }
        count = i + 1;
        JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:self.timeLineView.frame];
        [self.timeLineView addSubview:timeLineV];
        self.timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
        self.timeLineView.showsHorizontalScrollIndicator = NO;
    }
    
}
- (void)setUpTopUI {
    // == 时间轴视图 == //
    UIScrollView *timeLineView = [[UIScrollView alloc] init];
    [self addSubview:timeLineView];
    self.timeLineView = timeLineView;
    self.timeLineView.backgroundColor = [UIColor countLabelColor];
    // == 第一行视图 == //
    UIView *oneView = [UIView new];
    [self addSubview:oneView];
    oneView.backgroundColor = [UIColor whiteColor];
    UILabel *orderNumber = [UILabel new];
    [oneView addSubview:orderNumber];
    orderNumber.font = [UIFont systemFontOfSize:13.];
    orderNumber.textColor = [UIColor buttonTitleColor];
    orderNumber.text = @"订单编号 :";
    
    UILabel *orderNumLabel = [UILabel new];
    [oneView addSubview:orderNumLabel];
    self.orderNumLabel = orderNumLabel;
    self.orderNumLabel.font = [UIFont systemFontOfSize:13.];
    self.orderNumLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *orderStatusLabel = [UILabel new];
    [oneView addSubview:orderStatusLabel];
    self.orderStatusLabel = orderStatusLabel;
    self.orderStatusLabel.font = [UIFont systemFontOfSize:13.];
    self.orderStatusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    // == 第二行视图 == //
    UIView *twoView = [UIView new];
    [self addSubview:twoView];
    twoView.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *orderCreateTime = [UILabel new];
    [twoView addSubview:orderCreateTime];
    self.orderCreateTime = orderCreateTime;
    self.orderCreateTime.font = [UIFont systemFontOfSize:13.];
    self.orderCreateTime.textColor = [UIColor buttonTitleColor];
    
    // == 第三行视图 == //
    UIView *threeView = [UIView new];
    [self addSubview:threeView];
    self.addressView = threeView;
    self.addressView.backgroundColor = [UIColor whiteColor];
    self.addressView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.addressView addGestureRecognizer:tap];
    UIView *threeTapView = [tap view];
    threeTapView.tag = 100;
    
    UIImageView *addressImage = [UIImageView new];
    [threeView addSubview:addressImage];
    addressImage.image = [UIImage imageNamed:@"address_icon"];
    
    UILabel *addressNameLabel = [UILabel new];
    [threeView addSubview:addressNameLabel];
    self.addressNameLabel = addressNameLabel;
    self.addressNameLabel.font = [UIFont systemFontOfSize:13.];
    self.addressNameLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *addressPhoneLabel = [UILabel new];
    [threeView addSubview:addressPhoneLabel];
    self.addressPhoneLabel = addressPhoneLabel;
    self.addressPhoneLabel.font = [UIFont systemFontOfSize:12.];
    self.addressPhoneLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *addressDetailLabel = [UILabel new];
    [threeView addSubview:addressDetailLabel];
    self.addressDetailLabel = addressDetailLabel;
    self.addressDetailLabel.font = [UIFont systemFontOfSize:12.];
    self.addressDetailLabel.textColor = [UIColor dingfanxiangqingColor];
    self.addressDetailLabel.numberOfLines = 0;
    // == 第四行视图 == //
    UIView *fourView = [UIView new];
    [self addSubview:fourView];
    self.logisticsView = fourView;
    self.logisticsView.backgroundColor = [UIColor whiteColor];
    self.logisticsView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.logisticsView addGestureRecognizer:tap1];
    UIView *fourTapView = [tap1 view];
    fourTapView.tag = 101;
    
    UILabel *logistics = [UILabel new];
    [fourView addSubview:logistics];
    logistics.font = [UIFont systemFontOfSize:13.];
    logistics.textColor = [UIColor buttonTitleColor];
    logistics.text = @"物流配送";
    
    UIImageView *logisticeImage = [UIImageView new];
    [fourView addSubview:logisticeImage];
    logisticeImage.image = [UIImage imageNamed:@"rightArrow"];
    
    UILabel *logisticsLabel = [UILabel new];
    [fourView addSubview:logisticsLabel];
    self.logisticsLabel = logisticsLabel;
    self.logisticsLabel.font = [UIFont systemFontOfSize:13.];
    self.logisticsLabel.textColor = [UIColor buttonTitleColor];
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    
    if (self.isTimeLineView) {
        [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf);
            make.height.mas_equalTo(@60);
        }];
    }else {
        [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf);
            make.height.mas_equalTo(@0);
        }];
    }
    // == 第一行视图 == //
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLineView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@50);
    }];
    [orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneView).offset(10);
        make.centerY.equalTo(oneView.mas_centerY);
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderNumber.mas_right).offset(10);
        make.centerY.equalTo(oneView.mas_centerY);
    }];
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-10);
        make.centerY.equalTo(oneView.mas_centerY);
    }];
    // == 第二行视图 == //
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@30);
    }];
    [self.orderCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(twoView).offset(-10);
        make.centerY.equalTo(twoView.mas_centerY);
    }];
    // == 第三行视图 == //
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@90);
    }];
    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeView).offset(10);
        make.centerY.equalTo(threeView.mas_centerY);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@20);
    }];
    [self.addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.top.equalTo(threeView).offset(15);
    }];
    [self.addressPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressNameLabel.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.addressNameLabel.mas_centerY);
    }];
    [self.addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.right.equalTo(threeView).offset(-10);
        make.bottom.equalTo(threeView).offset(-15);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(20);
    }];
    
    // == 第四行视图 == //
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@40);
    }];
    [logistics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fourView).offset(10);
        make.centerY.equalTo(fourView.mas_centerY);
    }];
    [logisticeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fourView).offset(-10);
        make.centerY.equalTo(fourView.mas_centerY);
        make.width.mas_equalTo(@16);
        make.height.mas_equalTo(@25);
    }];
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(logisticeImage.mas_left).offset(-10);
        make.centerY.equalTo(fourView.mas_centerY);
    }];
    
    UIView *fourLineV = [UIView new];
    [fourView addSubview:fourLineV];
    fourLineV.backgroundColor = [UIColor countLabelColor];
    [fourLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.left.right.bottom.equalTo(fourView);
    }];
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger tag = tapView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(composeHeaderTapView:TapClick:)]) {
        [_delegate composeHeaderTapView:self TapClick:tag];
    }
}


@end





























































//
//  JMOrderDetailController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailController.h"
#import "JMOrderNumTimeModel.h"
#import "JMOrderNumTimeView.h"
#import "JMLogisticsAddressView.h"
#import "JMLogisticsAddressController.h"
#import "JMGoodsShowController.h"
#import "JMGoodsShowView.h"
#import "JMPayView.h"
#import "MMClass.h"
#import "JMPayModel.h"
#import "JMOrderPayView.h"

@interface JMOrderDetailController ()<JMOrderPayViewDelegate>

/**
 *  订单编号View
 */
@property (nonatomic,strong) JMOrderNumTimeView *orderNumTimeView;
/**
 *  物流信息View
 */
@property (nonatomic,strong) JMLogisticsAddressController *logisticsAddressVC;
/**
 *  商品展示cell
 */
@property (nonatomic,strong) JMGoodsShowController *goodsShowVC;
/**
 *  支付View
 */
@property (nonatomic,strong) JMPayView *payView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong) JMOrderPayView *orderPayView;

@end

@implementation JMOrderDetailController

- (JMLogisticsAddressController *)logisticsAddressVC {
    if (!_logisticsAddressVC) {
        _logisticsAddressVC = [[JMLogisticsAddressController alloc] init];
    }
    return _logisticsAddressVC;
}


- (JMGoodsShowController *)goodsShowVC {
    if (!_goodsShowVC) {
        _goodsShowVC = [[JMGoodsShowController alloc] init];
    }
    return _goodsShowVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self prepareData];
}

- (void)createUI {
    
    /**
     *  顶部视图
     */
    JMOrderNumTimeView *orderNumTimeView = [[JMOrderNumTimeView alloc] init];
    [self.view addSubview:orderNumTimeView];
    self.orderNumTimeView = orderNumTimeView;
    self.orderNumTimeView.frame = CGRectMake(0, 64, SCREENWIDTH, 124);
    
    
    // ===== 物流信息的view  这里 直接给view一个位置就可以了
    JMLogisticsAddressView *logisticsView = [[JMLogisticsAddressView alloc] init];
    logisticsView.frame = CGRectMake(0, 124, SCREENWIDTH, 214);
    logisticsView.contentView = self.logisticsAddressVC.view;
    
    
    JMGoodsShowView *goodsShowView = [[JMGoodsShowView alloc] init];
    goodsShowView.frame = CGRectMake(0, 214, SCREENWIDTH, 320);
    [self.view addSubview:goodsShowView];
    goodsShowView.contentView = self.goodsShowVC.view;
    goodsShowView.backgroundColor = [UIColor greenColor];
    
    JMPayView *payView = [[JMPayView alloc] init];
    payView.frame = CGRectMake(0, SCREENHEIGHT - 220, SCREENWIDTH, 160);
    [self.view addSubview:payView];
    payView.backgroundColor = [UIColor grayColor];
    self.payView = payView;
    
    JMOrderPayView *orderPayView = [[JMOrderPayView alloc] init];
    [self.view addSubview:orderPayView];
    self.orderPayView = orderPayView;
    self.orderPayView.delegate = self;
    self.orderPayView.frame = CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60);
    self.orderPayView.backgroundColor = [UIColor greenColor];
}


- (void)prepareData {
    
    JMOrderNumTimeModel *models = [[JMOrderNumTimeModel alloc] init];
    models.orderNum = @"测试订单编号:xfjdkf2382893849384";
    models.orderState = @"测试订单状态:待支付";
    models.orderTime = @"测试下单时间:2016-03-23-12:12";
    models = [JMOrderNumTimeModel modelWithModel:models];
    self.orderNumTimeView.model = models;
   
    JMPayModel *payModel = [[JMPayModel alloc] init];
    payModel.payment = @"测试数据";
    payModel.coupon = @"测试数据";
    payModel.appPay = @"测试数据";
    payModel.freight = @"测试数据";
    payModel.lastPayment = @"测试数据";
    payModel = [JMPayModel modelWithModel:payModel];
    self.payView.model = payModel;
    
}


- (void)composePayBtn:(JMOrderPayView *)payBtn didClickBtn:(NSInteger)index {
    
    if (index == 0) {
        
        NSLog(@"确认支付 按钮  被点击");
        
    }else {
        
        NSLog(@"取消支付 按钮  被点击");
    }
    
}


@end




























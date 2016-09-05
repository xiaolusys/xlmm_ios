//
//  JMOrderDetailModel.h
//  XLMM
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JMOrderDetailModel : NSObject

@property (nonatomic,copy) NSString *buyer_id;

@property (nonatomic,copy) NSString *buyer_message;
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *buyer_nick;
/**
 *  支付方式
 */
@property (nonatomic,copy) NSString *channel;

@property (nonatomic,copy) NSString *consign_time;
/**
 *  订单创建时间
 */
@property (nonatomic,copy) NSString *created;

@property (nonatomic,copy) NSString *discount_fee;
/**
 *  商品的ID
 */
@property (nonatomic,copy) NSString *goodsID;
/**
 *  判断物流选择
 */
@property (nonatomic,strong) NSDictionary *logistics_company;

@property (nonatomic,copy) NSString *out_sid;

@property (nonatomic,copy) NSString *pay_time;

@property (nonatomic,copy) NSString *payment;

@property (nonatomic,copy) NSString *post_fee;
/**
 *  订单状态
 */
@property (nonatomic,copy) NSString *status;
/**
 *  订单状态文字
 */
@property (nonatomic,copy) NSString *status_display;

@property (nonatomic,copy) NSString *tid;

@property (nonatomic,copy) NSString *total_fee;

@property (nonatomic,copy) NSString *trade_type;

//@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *order_type;
/**
 *  商品信息
 */
@property (nonatomic,strong) NSMutableArray *orders;
/**
 *  收货地址
 */
@property (nonatomic,strong) NSDictionary *user_adress;
/**
 *  包裹信息
 */
@property (nonatomic,strong) NSMutableArray *package_orders;
/**
 *  退款方式
 */
@property (nonatomic,strong) NSDictionary *extras;


@end











































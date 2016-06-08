//
//  JMOrderGoodsModel.h
//  XLMM
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMOrderGoodsModel : NSObject


@property (nonatomic,copy) NSString *discount_fee;

@property (nonatomic,copy) NSString *orderGoodsID;

@property (nonatomic,copy) NSString *is_seckill;

@property (nonatomic,copy) NSString *item_id;

@property (nonatomic,copy) NSString *kill_title;
/**
 *  商品个数
 */
@property (nonatomic,copy) NSString *num;

@property (nonatomic,copy) NSString *oid;

@property (nonatomic,copy) NSString *outer_id;

@property (nonatomic,copy) NSString *payment;
/**
 *  商品图片
 */
@property (nonatomic,copy) NSString *pic_path;

@property (nonatomic,copy) NSString *refund_id;
/**
 *  退款状态
 */
@property (nonatomic,copy) NSString *refund_status;
/**
 *  退款状态描述
 */
@property (nonatomic,copy) NSString *refund_status_display;

@property (nonatomic,copy) NSString *sku_id;
/**
 *  商品尺码
 */
@property (nonatomic,copy) NSString *sku_name;
/**
 *  订单状态
 */
@property (nonatomic,copy) NSString *status;
/**
 *  订单状态描述
 */
@property (nonatomic,copy) NSString *status_display;
/**
 *  商品标题
 */
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *total_fee;


@end





















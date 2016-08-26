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

@property (nonatomic,assign) BOOL is_seckill;

@property (nonatomic,copy) NSString *item_id;

@property (nonatomic,assign) BOOL kill_title;
/**
 *  商品ID
 */
@property (nonatomic,copy) NSString *model_id;
/**
 *  商品个数
 */
@property (nonatomic,copy) NSString *num;

@property (nonatomic,copy) NSString *oid;

@property (nonatomic,copy) NSString *outer_id;
/**
 *  包裹分包信息
 */
@property (nonatomic,copy) NSString *package_order_id;

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

/**
 *  orders =     (
 {
 "discount_fee" = 2;
 id = 454042;
 "is_seckill" = 0;
 "item_id" = 61047;
 "kill_title" = 0;
 "model_id" = 17716;
 num = 1;
 oid = xo16081757b408b771078;
 "outer_id" = 329294630091;
 "package_order_id" = "1-134679-3-1";
 payment = "36.02";
 "pic_path" = "http://image.xiaolu.so/MG_1469628689550.jpg";
 "refund_id" = 52255;
 "refund_status" = 7;
 "refund_status_display" = "\U9000\U6b3e\U6210\U529f";
 "sku_id" = 227959;
 "sku_name" = "\U6d1b\U795e\U82b1";
 status = 6;
 "status_display" = "\U9000\U6b3e\U5173\U95ed";
 title = "\U9b54\U5e7b\U4e4b\U7f8e\U73ab\U7470\U5473\U82b1\U679c\U8336";
 "total_fee" = "38.02";
 }
 );

 */



















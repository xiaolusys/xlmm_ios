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
 *   {
 "discount_fee" = "15.1";
 id = 412740;
 "is_seckill" = 0;
 "item_id" = 55697;
 "kill_title" = 0;
 num = 1;
 oid = xo16062857726e925fefc;
 "outer_id" = 819293150031;
 "package_order_id" = "";
 payment = "74.8";
 "pic_path" = "http://image.xiaolu.so/MG_14666752120661.jpg";
 "refund_id" = 48227;
 "refund_status" = 7;
 "refund_status_display" = "\U9000\U6b3e\U6210\U529f";
 "sku_id" = 204086;
 "sku_name" = M;
 status = 6;
 "status_display" = "\U9000\U6b3e\U5173\U95ed";
 title = "\U663e\U7626\U7f51\U7eb1\U5370\U82b1\U8fde\U8863\U88d9/\U9ed1\U8272";
 "total_fee" = "89.90000000000001";
 }

 */



















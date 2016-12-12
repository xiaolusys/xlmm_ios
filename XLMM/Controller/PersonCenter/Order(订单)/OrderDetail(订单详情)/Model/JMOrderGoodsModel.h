//
//  JMOrderGoodsModel.h
//  XLMM
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMOrderGoodsModel : NSObject


@property (nonatomic, assign) BOOL can_refund;

/**
 *  是否是保税商品
 */
@property (nonatomic, assign) BOOL is_bonded_goods;

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
 *   orders =     (
 {
 "can_refund" = 0;
 "discount_fee" = 0;
 id = 575211;
 "is_bonded_goods" = 0;
 "is_seckill" = 0;
 "item_id" = 79295;
 "kill_title" = 0;
 "model_id" = 24808;
 num = 1;
 oid = xo16112558379d05424f1;
 "outer_id" = RMB129XJJ;
 "package_order_id" = "";
 payment = 129;
 "pic_path" = "http://img.xiaolumeimei.com/nine_pic1479890636715";
 "refund_id" = "<null>";
 "refund_status" = 0;
 "refund_status_display" = "\U6ca1\U6709\U9000\U6b3e";
 "sku_id" = 293539;
 "sku_name" = "Associate-\U7ecf\U7406\U5238";
 status = 5;
 "status_display" = "\U4ea4\U6613\U6210\U529f";
 title = "\U52b5\U4e28\U8fdb\U53e35\U74f6\U88c5\U6297\U83cc\U6d17\U6d01\U7cbe/Associate-\U7ecf\U7406\U5238";
 "total_fee" = 129;
 }
 );

 */



















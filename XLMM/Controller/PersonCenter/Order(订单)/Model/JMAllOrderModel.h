//
//  JMAllOrderModel.h
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAllOrderModel : NSObject


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

@property (nonatomic, copy) NSString *order_type;

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
/**
 *  商品信息
 */
@property (nonatomic,strong) NSMutableArray *orders;




@end
 // order_type --> 判断是否为团购
/**
 *  "buyer_id" = 1;
 "buyer_message" = "";
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 channel = alipay;
 "consign_time" = "<null>";
 created = "2016-07-07T17:32:16";
 "discount_fee" = 2;
 id = 372406;
 "logistics_company" = "<null>";
 "order_pic" = "http://image.xiaolu.so/MG_14669983063031.jpg";
 orders =             (
 {
 "discount_fee" = 2;
 id = 415094;
 "is_seckill" = 0;
 "item_id" = 56166;
 "kill_title" = 0;
 num = 1;
 oid = xo160707577e21a05fd76;
 "outer_id" = 822292890071;
 "package_order_id" = "";
 payment = "67.90000000000001";
 "pic_path" = "http://image.xiaolu.so/MG_14669983063031.jpg";
 "refund_id" = "<null>";
 "refund_status" = 0;
 "refund_status_display" = "\U6ca1\U6709\U9000\U6b3e";
 "sku_id" = 206175;
 "sku_name" = S;
 status = 1;
 "status_display" = "\U5f85\U4ed8\U6b3e";
 title = "\U4e2d\U957f\U6b3e\U77ed\U84ec\U84ec\U5957\U88c5\U88d9/\U767d\U8272";
 "total_fee" = "69.90000000000001";
 }
 );
 "out_sid" = "";
 "pay_time" = "<null>";
 payment = "67.90000000000001";
 "post_fee" = 0;
 "receiver_address" = "\U53a6\U95e8\U7fd4\U5b89\U533a\U9a6c\U5df7\U9547\U5317\U5de5\U4e1a\U533a\U4e94\U661f\U8def447\U53f7\U5ba3\U5fb7\U9f99\U670d\U88c5\U6709\U9650\U516c\U53f8";
 "receiver_city" = "\U67f3\U5dde\U5e02";
 "receiver_district" = "\U5e02\U8f96\U533a";
 "receiver_mobile" = 18801806068;
 "receiver_name" = "meron\U54c8\U54c8";
 "receiver_phone" = "";
 "receiver_state" = "\U5e7f\U897f\U58ee\U65cf\U81ea\U6cbb\U533a";
 status = 1;
 "status_display" = "\U5f85\U4ed8\U6b3e";
 tid = xd160707577e1ff091711;
 "total_fee" = "69.90000000000001";
 "trade_type" = 0;
 */

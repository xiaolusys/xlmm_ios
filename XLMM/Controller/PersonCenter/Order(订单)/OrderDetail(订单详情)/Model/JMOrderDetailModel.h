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

@property (nonatomic, copy) NSString *can_change_address;
@property (nonatomic, copy) NSString *can_refund;

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

@property (nonatomic, assign) bool has_budget_paid;

@property (nonatomic, copy) NSString *pay_cash;

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








/**
 *  (lldb) po responseObject
 {
 "buyer_id" = 1;
 "buyer_message" = "";
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 "can_change_address" = 1;
 "can_refund" = 1;
 channel = budget;
 "consign_time" = "<null>";
 created = "2016-09-23T17:13:34";
 "discount_fee" = 2;
 extras =     {
 channels =         (
 {
 id = wx;
 msg = "";
 name = "\U5fae\U4fe1\U652f\U4ed8";
 payable = 1;
 },
 {
 id = alipay;
 msg = "";
 name = "\U652f\U4ed8\U5b9d";
 payable = 1;
 }
 );
 "refund_choices" =         (
 {
 desc = "\U7533\U8bf7\U9000\U6b3e\U540e\Uff0c\U9000\U6b3e\U91d1\U989d\U7acb\U5373\U9000\U5230\U5c0f\U9e7f\U94b1\U5305\Uff0c\U5e76\U53ef\U7acb\U5373\U652f\U4ed8\U4f7f\U7528\Uff0c\U65e0\U9700\U7b49\U5f85.";
 name = "\U6781\U901f\U9000\U6b3e";
 "refund_channel" = budget;
 }
 );
 };
 "has_budget_paid" = 0;
 id = 436236;
 "logistics_company" = "<null>";
 "order_type" = 0;
 orders =     (
 {
 "can_refund" = 1;
 "discount_fee" = 2;
 id = 483004;
 "is_seckill" = 0;
 "item_id" = 68117;
 "kill_title" = 0;
 "model_id" = 20730;
 num = 1;
 oid = xo16092357e4f23e303e2;
 "outer_id" = 820290110233;
 "package_order_id" = "";
 payment = "47.9";
 "pic_path" = "http://img.xiaolumeimei.com/MG_14737504122196.jpg";
 "refund_id" = "<null>";
 "refund_status" = 0;
 "refund_status_display" = "\U6ca1\U6709\U9000\U6b3e";
 "sku_id" = 254740;
 "sku_name" = "\U5747\U7801";
 status = 2;
 "status_display" = "\U5df2\U4ed8\U6b3e";
 title = "\U65b0\U6b3e\U65f6\U5c1aV\U9886\U6253\U5e95\U886b/\U767d\U8272";
 "total_fee" = "49.9";
 }
 );
 "out_sid" = "";
 "package_orders" =     (
 {
 "assign_status_display" = "\U672a\U5907\U8d27";
 "assign_time" = "<null>";
 "book_time" = "<null>";
 "cancel_time" = "<null>";
 "finish_time" = "<null>";
 id = "";
 "logistics_company" = "<null>";
 note = "";
 "out_sid" = "";
 "pay_time" = "2016-09-23T17:13:36";
 "process_time" = "2016-09-23T17:13:36";
 "ware_by_display" = "\U4e0a\U6d77\U4ed3";
 "weight_time" = "2017-02-14 17:27:59";
 }
 );
 "pay_cash" = 0;
 "pay_time" = "2016-09-23T17:13:36";
 payment = "47.9";
 "post_fee" = 0;
 status = 2;
 "status_display" = "\U5df2\U4ed8\U6b3e";
 tid = xd16092357e4f23a85f83;
 "total_fee" = "49.9";
 "trade_type" = 0;
 "user_adress" =     {
 default = 1;
 id = 140077;
 "receiver_address" = "\U5e73\U51c9\U8def988\U53f7\U4e1c\U7eba\U8c37\U521b\U4e1a\U56ed3\U53f7\U697c3241\U5ba4";
 "receiver_city" = "\U6768\U6d66\U533a";
 "receiver_district" = "\U5185\U73af\U4ee5\U5185";
 "receiver_mobile" = 18621623915;
 "receiver_name" = "\U6d4b\U8bd5\U5730\U5740\U4e0d\U53d1\U8d27";
 "receiver_phone" = "";
 "receiver_state" = "\U4e0a\U6d77";
 };
 }
 */


































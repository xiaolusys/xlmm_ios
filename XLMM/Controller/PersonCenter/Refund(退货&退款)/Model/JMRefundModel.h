//
//  JMRefundModel.h
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMRefundModel : NSObject


@property (nonatomic, strong) NSDictionary *amount_flow;

@property (nonatomic, copy) NSString *buyer_id;
/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *buyer_nick;

@property (nonatomic, copy) NSString *company_name;
/**
 *  订单创建时间
 */
@property (nonatomic, copy) NSString *created;
/**
 *  退货方式
 */
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *feedback;
/**
 *  商品状态
 */
@property (nonatomic, copy) NSString *good_status;
/**
 *  判断是否有换货
 */
@property (nonatomic, copy) NSString *has_good_change;
/**
 *  判断退货或者退款
 */
@property (nonatomic, copy) NSString *has_good_return;
@property (nonatomic, copy) NSString *refundID;
@property (nonatomic, copy) NSString *item_id;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *modified;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *order_id;
/**
 *  商品价格
 */
@property (nonatomic, copy) NSString *payment;

@property (nonatomic, copy) NSString *phone;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *pic_path;
@property (nonatomic, strong) NSArray *proof_pic;
/**
 *  选择退换货的方式
 */
@property (nonatomic, copy) NSString *reason;
/**
 *  退款方式
 */
@property (nonatomic, copy) NSString *refund_channel;
/**
 *  退款金额
 */
@property (nonatomic, copy) NSString *refund_fee;
/**
 *  退款编号
 */
@property (nonatomic, copy) NSString *refund_no;
/**
 *  退货数量
 */
@property (nonatomic, copy) NSString *refund_num;
/**
 *  退货地址
 */
@property (nonatomic, copy) NSString *return_address;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *sku_id;
/**
 *  尺码(均码)
 */
@property (nonatomic, copy) NSString *sku_name;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *status_display;

@property (nonatomic, copy) NSArray *status_shaft;
/**
 *  商品标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  商品价格
 */
@property (nonatomic, copy) NSString *total_fee;
/**
 *  交易ID
 */
@property (nonatomic, copy) NSString *trade_id;
/**
 *  详情链接
 */
@property (nonatomic, copy) NSString *url;



@end




/**
 *   {
 "amount_flow" =             {
 desc = "";
 };
 "buyer_id" = 1;
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 "company_name" = "";
 created = "2016-07-08T14:02:32";
 desc = "\U4e03\U5929\U65e0\U7406\U7531\U9000\U8d27";
 feedback = "";
 "good_status" = 0;
 "has_good_change" = 0;
 "has_good_return" = 0;
 id = 48509;
 "item_id" = 56167;
 mobile = 18801806068;
 modified = "2016-07-08T14:02:35";
 "order_id" = 415102;
 payment = "27.9";
 phone = "";
 "pic_path" = "http://image.xiaolu.so/MG_14670059669424.jpg";
 "proof_pic" =             (
 );
 reason = "\U4e03\U5929\U65e0\U7406\U7531\U9000\U6362\U8d27";
 "refund_channel" = budget;
 "refund_fee" = "27.9";
 "refund_no" = RF160708577f41f83cc46;
 "refund_num" = 1;
 "return_address" = "\U5e7f\U5dde\U5e02\U767d\U4e91\U533a\U592a\U548c\U9547\U6c38\U5174\U6751\U9f99\U5f52\U8def\U53e3\U60a6\U535a\U5927\U9152\U5e97\U5bf9\U9762\U9f99\U95e8\U516c\U5bd33\U697c\Uff0c4008235355\Uff0c\U5c0f\U9e7f\U7f8e\U7f8e\U552e\U540e(\U6536)";
 sid = "";
 "sku_id" = 206179;
 "sku_name" = "\U5747\U7801";
 status = 7;
 "status_display" = "\U9000\U6b3e\U6210\U529f";
 "status_shaft" =             (
 {
 "status_display" = "\U7533\U8bf7\U9000\U6b3e";
 time = "2016-07-08T14:02:32";
 },
 {
 "status_display" = "\U7b49\U5f85\U8fd4\U6b3e";
 time = "2016-07-08T14:02:35";
 },
 {
 "status_display" = "\U9000\U6b3e\U6210\U529f";
 time = "2016-07-08T14:02:35";
 }
 );
 title = "\U65b0\U6b3e\U6f6e\U97e9\U7248\U5bbd\U677e\U4e2d\U957f\U6b3e\U8759\U8760\U886b/\U5f69\U8272\U5b57\U6bcd\U5370\U82b1\U9ed1\U8272";
 "total_fee" = "29.9";
 "trade_id" = 372412;
 url = "http://staging.xiaolumeimei.com/rest/v1/refunds/48509";
 },
 
 */





























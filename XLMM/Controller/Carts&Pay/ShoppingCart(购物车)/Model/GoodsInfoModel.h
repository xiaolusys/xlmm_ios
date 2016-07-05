//
//  GoodsInfoModel.h
//  XLMM
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface GoodsInfoModel : NSObject

@property (nonatomic,copy) NSString *alipay_payable;

@property (nonatomic,copy) NSString *apple_payable;

@property (nonatomic,copy) NSString *budget_cash;

@property (nonatomic,copy) NSString *budget_payable;
/**
 *  购物车内商品ID
 */
@property (nonatomic,copy) NSString *cart_ids;
/**
 *  优惠券返回信息
 */
@property (nonatomic,copy) NSString *coupon_message;

@property (nonatomic,copy) NSString *coupon_ticket;

@property (nonatomic,copy) NSString *discount_fee;

@property (nonatomic,copy) NSString *post_fee;

@property (nonatomic,copy) NSString *total_fee;

@property (nonatomic,copy) NSString *total_payment;

@property (nonatomic,copy) NSString *uuid;

@property (nonatomic,copy) NSString *wallet_cash;

@property (nonatomic,copy) NSString *wallet_payable;

@property (nonatomic,copy) NSString *weixin_payable;

@property (nonatomic,strong) NSMutableArray *cart_list;

@property (nonatomic,strong) NSMutableArray *pay_extras;



@end

/*
 {
 "alipay_payable" = 1;
 "apple_payable" = 0;
 "budget_cash" = "13518.5";
 "budget_payable" = 1;
 "cart_ids" = 457683;
 "cart_list" =     (
 {
 "buyer_id" = 1;
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 created = "2016-05-26T10:00:54";
 id = 457683;
 "is_repayable" = 0;
 "item_id" = 41250;
 num = 1;
 "pic_path" = "http://image.xiaolu.so/MG_14618991767092.jpg";
 price = "49.9";
 "sku_id" = 166551;
 "sku_name" = M;
 status = 0;
 "std_sale_price" = 199;
 title = "\U767e\U642d\U4fee\U8eab\U540a\U5e26\U8fde\U8863\U88d9/\U7070\U8272";
 "total_fee" = "49.9";
 url = "http://m.xiaolumeimei.com/rest/v2/carts/457683";
 }
 );
 "coupon_message" = "\U8be5\U4f18\U60e0\U5238\U6ee150.0\U5143\U53ef\U7528";
 "coupon_ticket" = "<null>";
 "discount_fee" = 0;
 "pay_extras" =     (
 {
 name = "\U4f18\U60e0\U5238";
 pid = 2;
 type = 0;
 "use_coupon_allowed" = 1;
 value = 2;
 },
 {
 name = "APP\U652f\U4ed8\U51cf2\U5143";
 pid = 1;
 type = 0;
 value = 2;
 },
 {
 name = "\U4f59\U989d\U652f\U4ed8";
 pid = 3;
 type = 1;
 value = "49.9";
 }
 );
 "post_fee" = 0;
 "total_fee" = "49.9";
 "total_payment" = "49.9";
 uuid = xd16052657465a4e3f742;
 "wallet_cash" = "24440.48";
 "wallet_payable" = 1;
 "weixin_payable" = 0;
 }
 

 */
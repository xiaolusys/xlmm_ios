//
//  TuihuoModel.h
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kID @"id"
#define kURL @"url"
#define kRefund_NO @"refund_no"
#define kTrade_ID @"trade_id"
#define kOrder_ID @"order_id"
#define kBuyer_ID @"buyer_id"
#define kItem_ID @"item_id"
#define kTitle @"title"
#define kSku_ID @"sku_id"
#define kSku_Name @"sku_name"
#define kRefund_Num @"refund_num"
#define kBuyer_Nick @"buyer_nick"
#define kMobile @"mobile"
#define kPhone @"phone"
#define kTotal_Fee @"total_fee"
#define kPayment @"payment"
#define kCreated @"created"
#define kModified @"modified"
#define kCompany_Name @"company_name"
#define kSID @"sid"
#define kReason @"reason"
#define kPic_Path @"pic_path"
#define kDesc @"desc"
#define kFeedback @"feedback"
#define kHas_Good_Return @"has_good_return"
#define kHas_Good_Change @"has_good_change"
#define kGood_status @"good_status"
#define kStatus @"status"
#define kRefune_Fee @"refund_fee"
#define kStatus_Display @"status_display"


@interface TuihuoModel : NSObject

@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *refund_no;
@property (nonatomic, assign)NSInteger trade_id;
@property (nonatomic, assign)NSInteger order_id;
@property (nonatomic, assign)NSInteger buyer_id;
@property (nonatomic, assign)NSInteger item_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger sku_id;
@property (nonatomic, copy)NSString *sku_name;
@property (nonatomic, assign)NSInteger refund_num;
@property (nonatomic, copy)NSString *buyer_nick;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, assign)float total_fee;
@property (nonatomic, assign)float payment;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *modified;
@property (nonatomic, copy)NSString *company_name;
@property (nonatomic, copy)NSString *sid;
@property (nonatomic, copy)NSString *reason;
@property (nonatomic, copy)NSString *pic_path;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, copy)NSString *feedback;
@property (nonatomic, assign)BOOL has_good_return;
@property (nonatomic, assign)BOOL has_good_change;
@property (nonatomic, assign)NSInteger good_status;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, assign)float refund_fee;
@property (nonatomic, copy)NSString *status_display;






@end

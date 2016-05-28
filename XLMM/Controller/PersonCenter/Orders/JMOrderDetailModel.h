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

@property (nonatomic,copy) NSString *buyer_nick;

@property (nonatomic,copy) NSString *channel;

@property (nonatomic,copy) NSString *consign_time;

@property (nonatomic,copy) NSString *created;

@property (nonatomic,copy) NSString *discount_fee;
/**
 *  商品的ID
 */
@property (nonatomic,copy) NSString *goodsID;

@property (nonatomic,copy) NSString *logistic_company_code;

@property (nonatomic,copy) NSString *out_sid;

@property (nonatomic,copy) NSString *pay_time;

@property (nonatomic,copy) NSString *payment;

@property (nonatomic,copy) NSString *post_fee;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *status_display;

@property (nonatomic,copy) NSString *tid;

@property (nonatomic,copy) NSString *total_fee;

@property (nonatomic,copy) NSString *trade_type;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) NSMutableArray *orders;

@property (nonatomic,strong) NSMutableDictionary *user_adress;

@end











































//
//  OrderModel.h
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *oID;
@property (nonatomic, copy)NSString *item_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *sku_id;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *outer_id;
@property (nonatomic, copy)NSString *total_fee;
@property (nonatomic, copy)NSString *payment;
@property (nonatomic, copy)NSString *sku_name;

@property (nonatomic, copy)NSString *pic_path;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *status_display;
@property (nonatomic, copy)NSString *refund_status;
@property (nonatomic, copy)NSString *refund_status_display;



@end

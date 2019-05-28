//
//  JMEditAddressModel.h
//  XLMM
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  修改订单收货地址Model
 */
@interface JMEditAddressModel : NSObject
/**
 *  收货人姓名
 */
@property (nonatomic,copy) NSString *receiver_name;
/**
 *  收货人电话
 */
@property (nonatomic,copy) NSString *receiver_mobile;
/**
 *  所在地区 -- 省
 */
@property (nonatomic,copy) NSString *receiver_state;
/**
 *  所在地区 -- 市
 */
@property (nonatomic,copy) NSString *receiver_city;
/**
 *  所在地区 -- 县
 */
@property (nonatomic,copy) NSString *receiver_district;
/**
 *  详细地址
 */
@property (nonatomic,copy) NSString *receiver_address;
/**
 *  修改商品详情ID
 */
@property (nonatomic,copy) NSString *referal_trade_id;
/**
 *
 */
@property (nonatomic,copy) NSString *receiver_phone;
/**
 *
 */
@property (nonatomic,copy) NSString *userAddressDefault;

@property (nonatomic, copy) NSString *identification_no;

@end

/*
 "user_adress" =     {
 default = "";
 id = "<null>";
 "identification_no" = "";
 "receiver_address" = "";
 "receiver_city" = "";
 "receiver_district" = "";
 "receiver_mobile" = "";
 "receiver_name" = "";
 "receiver_phone" = "";
 "receiver_state" = "";
 };

 */



















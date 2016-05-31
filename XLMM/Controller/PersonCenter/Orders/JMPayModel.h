//
//  JMPayModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMPayModel : NSObject
/**
 *  商品金额
 */
@property (nonatomic,copy) NSString *payment;
/**
 *  优惠券折扣
 */
@property (nonatomic,copy) NSString *coupon;
/**
 *  APP支付优惠
 */
@property (nonatomic,copy) NSString *appPay;
/**
 *  运费
 */
@property (nonatomic,copy) NSString *freight;
/**
 *  应付金额
 */
@property (nonatomic,copy) NSString *lastPayment;

- (instancetype)initWithModel:(JMPayModel *)model;

+ (instancetype)modelWithModel:(JMPayModel *)model;


@end

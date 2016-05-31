//
//  JMPayModel.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayModel.h"

@implementation JMPayModel

+ (instancetype)modelWithModel:(JMPayModel *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(JMPayModel *)model {
    if (self = [super init]) {
        self.payment = model.payment;
        self.coupon = model.coupon;
        self.appPay = model.appPay;
        self.freight = model.freight;
        self.lastPayment = model.lastPayment;
    }
    return self;
}


@end

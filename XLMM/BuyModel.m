//
//  BuyModel.m
//  XLMM
//
//  Created by younishijie on 15/8/26.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "BuyModel.h"

@implementation BuyModel

- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%ld\n",
                     self.addressID
                     ,self.channel
                     ,self.payment
                     ,self.postFee
                     ,self.discountFee
                     ,self.totalFee
                     ,self.uuID
                     ,self.itemID
                     ,self.skuID
                     ,self.buyNumber
                     ];
    return str;
}

@end

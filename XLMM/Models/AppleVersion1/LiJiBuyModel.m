//
//  LiJiBuyModel.m
//  XLMM
//
//  Created by younishijie on 15/8/25.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "LiJiBuyModel.h"

@implementation LiJiBuyModel


- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",
                     self.addressID
                     ,self.channel
                     ,self.payment
                     ,self.postFee
                     ,self.discountFee
                     ,self.totalFee
                     ,self.uuID
                     ,self.itemID
                     ,self.skuID
                     ,self.number
                     ];
    return str;
}

@end

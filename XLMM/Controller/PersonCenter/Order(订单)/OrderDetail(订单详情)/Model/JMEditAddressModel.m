//
//  JMEditAddressModel.m
//  XLMM
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEditAddressModel.h"

@implementation JMEditAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"referal_trade_id":@"id",
             @"userAddressDefault":@"default"};
}


@end

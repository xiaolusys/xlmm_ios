//
//  JMAllOrderModel.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAllOrderModel.h"
#import "JMOrderGoodsModel.h"

@implementation JMAllOrderModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMOrderGoodsModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"goodsID":@"id"};
}

@end

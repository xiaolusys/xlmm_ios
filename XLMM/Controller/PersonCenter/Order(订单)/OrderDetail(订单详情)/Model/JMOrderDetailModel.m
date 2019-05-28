//
//  JMOrderDetailModel.m
//  XLMM
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"
#import "JMPackAgeModel.h"

@implementation JMOrderDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMOrderGoodsModel class],
             @"package_orders":[JMPackAgeModel class]};
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"goodsID":@"id"};
}

@end

//
//  JMOrderDetailModel.m
//  XLMM
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"

@implementation JMOrderDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMOrderGoodsModel class]};
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"goodsID":@"id",
             @"logistic_company_code":@"logistic_company"};
}

@end

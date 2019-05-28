//
//  JMRefundModel.m
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundModel.h"
#import "JMRefundStatusModel.h"

@implementation JMRefundModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"status_shaft":[JMRefundStatusModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"refundID":@"id"};
}


@end

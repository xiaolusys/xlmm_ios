//
//  JMQueryLogInfoModel.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMQueryLogInfoModel.h"
#import "JMTimeInfoModel.h"

@implementation JMQueryLogInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"expressID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMTimeInfoModel class]};
}


@end

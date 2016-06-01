//
//  JMLogistics.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogistics.h"

@implementation JMLogistics


- (instancetype)initWithDict:(NSDictionary *) dict
{
    if (self = [super  init]) {
        //        self.name = dict[@"name"];
        //        self.icon = dict[@"icon"];
        
        // 因为dict字典对象的数据元素都是基本类型，可以直接用KVC
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype )logisticsWithDict:(NSDictionary *) dict
{
    return [[self alloc] initWithDict:dict];
}

@end

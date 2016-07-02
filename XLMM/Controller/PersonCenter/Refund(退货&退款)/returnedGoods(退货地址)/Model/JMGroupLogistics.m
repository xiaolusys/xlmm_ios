//
//  JMGroupLogistics.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGroupLogistics.h"
#import "JMLogistics.h"

@implementation JMGroupLogistics

- (instancetype) initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        //        self.name = dict[@"title"];
        //        self.cars = dict[@"cars"];  // 因为cars是个字典，要进行模型装换
        
        [self setValuesForKeysWithDictionary:dict];  // 相当于给普通数据赋值
        
        // 当有模型嵌套的时候需要手动把字典转为模型
        // 创建一个用来保存模型的数组
        NSMutableArray *arrayModels = [NSMutableArray array];
        // 手动做一下模型转换
        for(NSDictionary * item_dict  in  dict[@"logistics"]) // cars也是一个字典数组
        { // 注意：声明的迭代项目不能和后面的集合名相同
            JMLogistics *car = [JMLogistics logisticsWithDict:item_dict];
            [arrayModels addObject:car];
        }
        self.logistics = arrayModels;
    }
    
    return self;
}
+ (instancetype)groupLogisticsWithDict:(NSDictionary *)dict
{
    return [[self alloc ]initWithDict:dict];
}

@end

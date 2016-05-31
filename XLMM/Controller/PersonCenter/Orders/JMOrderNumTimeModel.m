//
//  JMOrderNumTimeModel.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderNumTimeModel.h"

@implementation JMOrderNumTimeModel

+ (instancetype)modelWithModel:(JMOrderNumTimeModel *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(JMOrderNumTimeModel *)model {
    if (self = [super init]) {
        self.orderNum = model.orderNum;
        self.orderState = model.orderState;
        self.orderTime = model.orderTime;
    }
    return self;
}

@end

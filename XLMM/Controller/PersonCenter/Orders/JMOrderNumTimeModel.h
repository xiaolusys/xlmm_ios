//
//  JMOrderNumTimeModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMOrderNumTimeModel : NSObject

@property (nonatomic,copy) NSString *orderNum;

@property (nonatomic,copy) NSString *orderState;

@property (nonatomic,copy) NSString *orderTime;

- (instancetype)initWithModel:(JMOrderNumTimeModel *)model;

+ (instancetype)modelWithModel:(JMOrderNumTimeModel *)model;



@end

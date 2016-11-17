//
//  JMGoodsCountTime.h
//  XLMM
//
//  Created by zhang on 16/11/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^countTimeBlock)(int second);

@interface JMGoodsCountTime : NSObject

@property (nonatomic, copy) countTimeBlock countBlock;
@property (nonatomic, strong) dispatch_source_t timer;

+ (instancetype)shareCountTime;

- (instancetype)initWithEndTime:(int)endTime;

+ (instancetype)initCountDownWithCurrentTime:(int)endTime;

@end

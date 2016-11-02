//
//  NSArray+Reverse.h
//  XLMM
//
//  Created by younishijie on 16/3/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Reverse)

+ (NSArray *)reverse:(NSArray *)array;

// 判断数组是否为空
+ (BOOL)isEmptyForArray:(NSArray *)array;

@end

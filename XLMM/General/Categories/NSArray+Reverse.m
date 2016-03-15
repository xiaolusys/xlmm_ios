//
//  NSArray+Reverse.m
//  XLMM
//
//  Created by younishijie on 16/3/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

+ (NSArray *)reverse:(NSArray *)array{
    NSMutableArray *reserveArray = [array mutableCopy];
    for (int i = 0; i < array.count/2; i++) {
        [reserveArray exchangeObjectAtIndex:i withObjectAtIndex:array.count - i - 1];
    }
    return [reserveArray copy];
    
}

@end

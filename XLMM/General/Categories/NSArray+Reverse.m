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
+ (BOOL)isEmptyForArray:(NSArray *)array {
    if (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@"\t)"];
    
    return str;
}




@end

















































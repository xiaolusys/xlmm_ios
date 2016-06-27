//
//  NSArray+Log.m
//  XLMM
//
//  Created by younishijie on 15/10/21.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

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

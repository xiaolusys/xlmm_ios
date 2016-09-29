//
//  NSString+DeleteT.m
//  XLMM
//
//  Created by younishijie on 16/2/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "NSString+DeleteT.h"

@implementation NSString (DeleteT)

+ (NSString *)dateDeleteT:(NSString *)time{
    NSMutableString *string = [NSMutableString stringWithString:time];
    NSRange range = [string rangeOfString:@"T"];
    [string replaceCharactersInRange:range withString:@" "];
    return string;
    
}

+ (NSString *)jm_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}


@end

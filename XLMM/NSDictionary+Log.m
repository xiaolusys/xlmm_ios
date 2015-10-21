//
//  NSDictionary+Log.m
//  XLMM
//
//  Created by younishijie on 15/10/21.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
 {
     NSArray *allKeys = [self allKeys];
     NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
     for (NSString *key in allKeys) {
         id value= self[key];
         [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
     }
     [str appendString:@"\t}"];
    
     return str;
}

@end

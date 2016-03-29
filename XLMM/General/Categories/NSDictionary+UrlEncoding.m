//
//  NSDictionary+UrlEncoding.m
//  XLMM
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"
static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    NSString *test = [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return [test stringByReplacingOccurrencesOfString:@";" withString:@"%3A"];
}

@implementation NSDictionary (UrlEncoding)


 -(NSString*) urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        NSLog(@"part---%@", part);
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end

//
//  NSString+URL.m
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

//   http://image.xiaolu.so/MG-1448717389408-高腰蕾丝修身短裤01.png?imageMogr2/format/jpg/quality/80

- (NSString *)imageCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/70",self];
    return string;
}

- (NSString *)imageMoreCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/10",self];
    return string;
}
@end

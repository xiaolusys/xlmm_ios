//
//  NSString+URL.m
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSString+URL.h"
#import "MMClass.h"

@implementation NSString (URL)
    


- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

//   http://image.xiaolu.so/MG-1448717389408-高腰蕾丝修身短裤01.png?imageMogr2/format/jpg/quality/80

- (NSString *)imageCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/%f/format/jpg/quality/90",self, [self imageWidth]];
    return string;
}




- (NSString *)imageMoreCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/50/format/jpg/quality/50",self];
    return string;
}

- (NSString *)ImageNoCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",self];
    return string;
}

//  imageMogr2/thumbnail/289/format/jpg/quality/90

- (NSString *)imageShareCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/png/quality/50",self];
    return string;
}

- (NSString *)imagePostersCompression{
    NSString *string = [NSString stringWithFormat:@"%@",self];
    return string;
}


- (float)imageWidth{
    float screenwidth = [UIScreen mainScreen].bounds.size.width;
    float width;
    if (screenwidth < 400) {
        width = (screenwidth - 15);
        // NSLog(@"width = %f", width);
        return width;
    }
    width = (screenwidth - 15)*1.3;
    
    //NSLog(@"width = %f", width);
    
    return width;
}


@end

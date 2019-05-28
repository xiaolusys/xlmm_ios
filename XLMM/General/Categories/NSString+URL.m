//
//  NSString+URL.m
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)


- (NSString *)JMUrlEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

-(NSString *)JMURLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

//   http://image.xiaolu.so/MG-1448717389408-高腰蕾丝修身短裤01.png?imageMogr2/format/jpg/quality/80
//首页浏览商品的参数
- (NSString *)imageCompression{
    NSString *string = [NSString stringWithFormat:@"%@imageMogr2/thumbnail/%.0f/format/jpg/quality/70",self, [self imageWidth]];
    return string;
}
// 商品详情参数 , 主页活动列表
- (NSString *)imageNormalCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/640/format/jpg/quality/90",self];
    return string;
}
// 商品列表参数
- (NSString *)imageGoodsListCompression {
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/279/format/jpg/quality/70",self];
    return string;
}
// 商品订单 , 订单详情图片 , 购物车
- (NSString *)imageGoodsOrderCompression {
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/200/format/jpg/quality/80",self];
    return string;
}
// 收益信息弹出头像
- (NSString *)imageMoreCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/50/format/jpg/quality/50",self];
    return string;
}
// 分享图片
- (NSString *)imageShareCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/100/format/jpg/quality/90",self];
    return string;
}
- (NSString *)ImageNoCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100",self];
    return string;
}

//http://image.xiaolu.so/MG_1460339008848%E5%A4%B4%E5%9B%BE%E8%83%8C%E6%99%AF.png?imageMogr2/thumbnail/200/format/png/quality/90
- (NSString *)imagePostersCompression{
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/90",self];
    return string;
}

- (NSString *)imageShareNinePicture {
    NSString *string = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/200/format/jpg/quality/30",self];
    return string;
}













- (float)imageWidth{
    float screenwidth = [UIScreen mainScreen].bounds.size.width;
    float width;
    if (screenwidth < 400) {
        width = (screenwidth - 15);
//        NSLog(@"imageWidth = %f", width);
        return width;
    }
    width = (screenwidth - 15)*1.3;
    
//    NSLog(@"imageWidth = %f", width);
    
    return width;
}


@end



















































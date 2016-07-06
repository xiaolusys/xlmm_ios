//
//  UIImage+ImageWithUrl.m
//  XLMM
//
//  Created by younishijie on 15/8/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "UIImage+ImageWithUrl.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"

@interface UIImage ()


@end
@implementation UIImage (ImageWithUrl)


+(UIImage *)imagewithURLString:(NSString *)urlString{
    UIImage *image = [[UIImage alloc] init];
    NSError *imageError = nil;
    
//    NSArray *array = [urlString componentsSeparatedByString:@"?"];
//    NSString *urlStr = array[0];
    NSData *data = nil;
    
    if(urlString == nil){
        return nil;
    }else {
//        NSURL *url = [NSURL URLWithString:urlString];
//        __block UIImage *image = nil;
//        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//            
//            image = [UIImage imageWithData:data];
//        }];
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMapped error:&imageError]; //[urlStr URLEncodedString]  == > urlString
        
        
        
    }
    
    if(imageError != nil){
        NSLog(@"loadingImageError = %@", imageError);
        //默认后台返回的是转码过的，app直接访问，如果访问出错再转码尝试一次
        NSString *urlStr = [urlString JMUrlEncodedString];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr] options:NSDataReadingMapped error:&imageError];
    }
    // NSLog(@"data = %@", data);
    NSLog(@"imagewithURLString data.length %ld", (unsigned long)data.length);
    
    image = [UIImage imageWithData:data];

    return image;
}

@end

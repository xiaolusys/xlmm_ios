//
//  UIImage+ImageWithUrl.m
//  XLMM
//
//  Created by younishijie on 15/8/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "UIImage+ImageWithUrl.h"
#import "NSString+URL.h"

@implementation UIImage (ImageWithUrl)

+(UIImage *)imagewithURLString:(NSString *)urlString{
    UIImage *image = nil;
    NSError *imageError = nil;
    
    if(urlString == nil) return nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[urlString URLEncodedString]] options:NSDataReadingMapped error:&imageError];
    if(imageError != nil){
        NSLog(@"loadingImageError = %@", imageError);
    }
   // NSLog(@"data = %@", data);
    NSLog(@"%ld", (unsigned long)data.length);
    
    image = [UIImage imageWithData:data];
    
    return image;
}

@end

//
//  UIImage+ImageWithUrl.m
//  XLMM
//
//  Created by younishijie on 15/8/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "UIImage+ImageWithUrl.h"

@implementation UIImage (ImageWithUrl)

+(UIImage *)imagewithURLString:(NSString *)urlString{
    UIImage *image = nil;
    NSError *imageError = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMapped error:&imageError];
    
    NSLog(@"loadingImageError = %@", imageError);
    
   // NSLog(@"data = %@", data);
    NSLog(@"%ld", data.length);
    
    image = [UIImage imageWithData:data];
    
    return image;
}

@end

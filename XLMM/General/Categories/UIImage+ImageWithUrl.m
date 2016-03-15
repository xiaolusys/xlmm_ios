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
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
}

@end

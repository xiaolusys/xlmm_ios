//
//  UIImage+ImageWithSelectedView.m
//  XLMM
//
//  Created by 张迎 on 15/12/16.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "UIImage+ImageWithSelectedView.h"

@implementation UIImage (ImageWithSelectedView)

+ (UIImage *) imageWithView:(UIView *)selectView
{
    UIGraphicsBeginImageContextWithOptions(selectView.bounds.size, selectView.opaque, 0.0);
    [selectView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) imagewithScrollView:(UIScrollView *)scrollView
{
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size,scrollView.opaque, 0.0);
    // scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    
    
}



@end

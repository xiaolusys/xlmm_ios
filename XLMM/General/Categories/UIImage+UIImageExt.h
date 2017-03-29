//
//  UIImage+UIImageExt.h
//  XLMM
//
//  Created by younishijie on 15/11/10.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

+ (UIImage *) imageWithView:(UIView *)selectView;
+ (UIImage *)imagewithWebView:(UIWebView *)webView;
+ (UIImage *) imagewithScrollView:(UIScrollView *)scrollView;

+ (UIImage*)imageFromView:(UIView*)view;


@end

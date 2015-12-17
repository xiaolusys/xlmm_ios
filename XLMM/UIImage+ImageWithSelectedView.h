//
//  UIImage+ImageWithSelectedView.h
//  XLMM
//
//  Created by 张迎 on 15/12/16.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithSelectedView)

+ (UIImage *) imageWithView:(UIView *)selectView;
+ (UIImage *)imagewithWebView:(UIWebView *)webView;

+ (UIImage *) imagewithScrollView:(UIScrollView *)scrollView;

@end

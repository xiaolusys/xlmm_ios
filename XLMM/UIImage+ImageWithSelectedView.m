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

+ (UIImage *)imagewithWebView:(UIWebView *)webView{
    UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, FALSE, 0);
    NSLog(@"webViewSize = %@", NSStringFromCGSize(webView.scrollView.contentSize));
    //渲染图形
    // [[webView.scrollView layer] renderInContext:UIGraphicsGetCurrentContext()];//这个方法没下边的好 因为快照截图 只截了大部分 还剩一点没截到
    [[[webView.scrollView.subviews objectAtIndex:0] layer] renderInContext:UIGraphicsGetCurrentContext()];//这个subview 的名字是 UIWebBrowserView
    //得到新的image
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

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

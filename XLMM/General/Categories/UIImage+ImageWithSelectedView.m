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
    UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, NO, 0);
    NSLog(@"webViewSize = %@", NSStringFromCGSize(webView.scrollView.contentSize));
    //渲染图形
    // [[webView.scrollView layer] renderInContext:UIGraphicsGetCurrentContext()];//这个方法没下边的好 因为快照截图 只截了大部分 还剩一点没截到
    //[webView.scrollView.subviews objectAtIndex:0]
    [[[webView.scrollView.subviews objectAtIndex:0] layer] renderInContext:UIGraphicsGetCurrentContext()];//这个subview 的名字是 UIWebBrowserView
    //得到新的image
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    webView.hidden = YES;
    return image;
//    UIImage *image = nil;
    
//    UIGraphicsBeginImageContext(webView.scrollView.contentSize);
//    CGPoint savedOffset = webView.scrollView.contentOffset;
//    CGRect saveContent = webView.scrollView.frame;
//    webView.scrollView.contentOffset = CGPointZero;
//    webView.scrollView.frame = CGRectMake(0, 0, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height);
//    
//    [[[webView.scrollView.subviews objectAtIndex:0] layer] renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    webView.scrollView.contentOffset = savedOffset;
//    webView.scrollView.frame = saveContent;
//    
//    UIGraphicsEndImageContext();
//    
//    webView.hidden = YES;
//    
////    if (image != nil) {
//        return image;
////    }
    
//
//    return nil;
    
//    CGSize boundsSize = webView.frame.size;
//    CGFloat boundsWidth = webView.frame.size.width;
//    CGFloat boundsHeight = webView.frame.size.height;
//    
//    CGPoint offset = webView.scrollView.contentOffset;
//    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
//    
//    CGFloat contentHeight = webView.scrollView.contentSize.height;
//    NSMutableArray *images = [NSMutableArray array];
//    while (contentHeight > 0) {
//        UIGraphicsBeginImageContext(boundsSize);
//        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [images addObject:image];
//        
//        CGFloat offsetY = webView.scrollView.contentOffset.y;
//        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
//        contentHeight -= boundsHeight;
//    }
//    [webView.scrollView setContentOffset:offset];
//    
//    UIGraphicsBeginImageContext(webView.scrollView.contentSize);
//    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
//        [image drawInRect:CGRectMake(0, boundsHeight * idx, boundsWidth, boundsHeight)];
//    }];
//    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    
//    webView.hidden = YES;
//    return fullImage;
//    
    
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

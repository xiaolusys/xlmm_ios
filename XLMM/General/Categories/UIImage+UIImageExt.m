//
//  UIImage+UIImageExt.m
//  XLMM
//
//  Created by younishijie on 15/11/10.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "UIImage+UIImageExt.h"

@implementation UIImage (UIImageExt)



- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}




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
+ (UIImage*)imageFromView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}




@end





























































































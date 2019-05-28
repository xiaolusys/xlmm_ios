//
//  UIImage+UIImageExt.h
//  XLMM
//
//  Created by younishijie on 15/11/10.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

+ (UIImage*)imageFromView:(UIView*)view;
+ (UIImage *)imageWithColor:(UIColor *)color Frame:(CGRect)frame;
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


+(nullable UIImage *)xh_imageWithName:(nonnull NSString *)imageName;
+(nullable UIImage *)xh_imageWithData:(nonnull NSData *)imageData;



@end

//
//  UIImage+Optimization.h
//  XLMM
//
//  Created by zhang on 16/10/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Optimization)

- (UIImage *)rightSizeImage:(UIImage *)image andSize:(CGSize)imgeSize;

- (void)rightSizeImage:(UIImage *)image andSize:(CGSize)imgeSize completion:(void (^)(UIImage *))completion;

/// 根据当前图像，和指定的尺寸，生成圆角图像并且返回
- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius completion:(void (^)(UIImage * newImage))completion;





@end

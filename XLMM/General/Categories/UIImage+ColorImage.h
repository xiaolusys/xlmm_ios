//
//  UIImage+ColorImage.h
//  XLMM
//
//  Created by younishijie on 15/10/31.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)


+ (UIImage *)imageWithColor:(UIColor *)color Frame:(CGRect)frame;


+ (instancetype)imageWithOriginalName:(NSString *)imageName;
+ (instancetype)imageWithStretchableName:(NSString *)imageName;
+ (UIImage *)resizeImageWithName:(NSString *)name;

@end

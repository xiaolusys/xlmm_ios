//
//  UIColor+RGBColor.m
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "UIColor+RGBColor.h"

@implementation UIColor (RGBColor)

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

+ (UIColor *)buttonBorderColor{
    UIColor *color = [UIColor colorWithR:217 G:140 B:13 alpha:1];
    return color;
}

+ (UIColor *)buttonEnabledBackgroundColor{
    return [UIColor colorWithR:245 G:166 B:35 alpha:1];
}
+ (UIColor *)buttonDisabledBackgroundColor{
    return [UIColor colorWithR:227 G:227 B:227 alpha:1];
}
+ (UIColor *)buttonEnabledBorderColor{
    return [UIColor colorWithR:217 G:140 B:13 alpha:1];
}
+ (UIColor *)buttonDisabledBorderColor{
    return [UIColor colorWithR:218 G:218 B:218 alpha:1];
}


+ (UIColor *)orangeThemeColor{
    return [UIColor colorWithR:245 G:166 B:35 alpha:1];
}

@end

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
//--- 橙色
+ (UIColor *)buttonEnabledBackgroundColor{
    return [UIColor colorWithR:245 G:177 B:35 alpha:1];
}
// --- 灰色
+ (UIColor *)buttonDisabledBackgroundColor{
    return [UIColor colorWithR:227 G:227 B:227 alpha:1];
}
+ (UIColor *)buttonEnabledBorderColor{
    return [UIColor colorWithR:217 G:140 B:13 alpha:1];
}
+ (UIColor *)buttonDisabledBorderColor{
    return [UIColor colorWithR:216 G:216 B:216 alpha:1];
}

+ (UIColor *)buttonEmptyBorderColor{
    return [UIColor colorWithR:245 G:166 B:35 alpha:1];
}

+ (UIColor *)orangeThemeColor{
    return [UIColor colorWithR:245 G:166 B:35 alpha:1];
}

+ (UIColor *)settingBackgroundColor{
    return [UIColor colorWithR:38 G:38 B:46 alpha:1];
}

+ (UIColor *)mamaCenterBorderColor{
   return [UIColor colorWithR:252 G:215 B:82 alpha:1];
}
// -- 灰色
+ (UIColor *)titleDarkGrayColor{
    return [UIColor colorWithR:190 G:190 B:190 alpha:1];
}
+ (UIColor *)tabBarTitleDarkGrayColor{
    return [UIColor colorWithR:140 G:140 B:140 alpha:1];
}
+ (UIColor *)textDarkGrayColor{
   return [UIColor colorWithR:98 G:98 B:98 alpha:1];
}
//绿色
+ (UIColor *)wechatBackColor {
    return [UIColor colorWithR:68 G:173 B:53 alpha:1];
}
// 红色
+ (UIColor *)couponValueColor {
    return [UIColor colorWithR:197 G:79 B:79 alpha:1];
}
//蓝色
+ (UIColor *)colorWithBlueColor {
    return [UIColor colorWithR:71 G:155 B:256 alpha:1];
}
+ (UIColor *)randomColor{
    return [UIColor colorWithR:arc4random()%256 G:arc4random()%256 B:arc4random()%256 alpha:1];
}

+ (UIColor *)pothoViewBackgroundColor{
    return [UIColor blackColor];
}
+ (UIColor *)pagecontrolBackgroundColor{
    return [UIColor orangeColor];
}
+ (UIColor *)pagecontrolCurrentIndicatorColor{
    return [UIColor colorWithRed:120 / 256.0 green:120 / 256.0 blue:120 / 256.0 alpha:0.4];
}

+ (UIColor *)youhuiquanrequireColor{
    return [UIColor colorWithRed:240/255.0 green:80/255.0 blue:80/255.0 alpha:1];
}

+ (UIColor *)shareViewBackgroundColor{
    return [UIColor whiteColor];
}

+ (UIColor *)loadingViewBackgroundColor{
    return [UIColor whiteColor];
    
}

+ (UIColor *)backgroundlightGrayColor{
   return [UIColor colorWithRed:243/255.0 green:243/255.0 blue:244/255.0 alpha:1];
}

+ (UIColor *)lineGrayColor{
    return [UIColor colorWithR:240 G:240 B:240 alpha:1];
}

+ (UIColor *)cartViewBackGround{
    return [UIColor colorWithR:44 G:44 B:44 alpha:1];
}

+ (UIColor *)rootViewButtonColor{
    return [UIColor colorWithR:252 G:185 B:22 alpha:1];
}
+ (UIColor *)countLabelTextColor{
    return [UIColor colorWithR:255 G:56 B:64 alpha:1];
}

+ (UIColor *)touxiangBorderColor{
    return [UIColor colorWithR:253 G:203 B:14 alpha:1];
}

+ (UIColor *)youhuiquanValueColor{
    return [UIColor colorWithR:240 G:80 B:80 alpha:1];
}

+ (UIColor *)dingfanxiangqingColor{
    return [UIColor colorWithR:155 G:155 B:155 alpha:1];
}

+ (UIColor *)countLabelColor{
    return [UIColor colorWithR:246 G:246 B:246 alpha:1];
}

+ (UIColor *)buttonTitleColor{
    return [UIColor colorWithR:74 G:74 B:74 alpha:1];
}

+ (UIColor *)timeLabelColor {
    return [UIColor colorWithR:160 G:160 B:160 alpha:1];
}
+ (UIColor *)sectionViewColor {
    return [UIColor colorWithR:252 G:252 B:252 alpha:1];
}

@end

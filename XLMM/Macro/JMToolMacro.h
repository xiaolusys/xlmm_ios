//
//  JMToolMacro.h
//  XLMM
//
//  Created by zhang on 16/9/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#ifndef JMToolMacro_h
#define JMToolMacro_h

// Log打印日志
#ifdef DEBUG
#define JMString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define NSLog(...) printf("%s -> [ %s ] 第%d行: %s\n\n",[[NSString jm_stringDate] UTF8String],[JMString UTF8String],__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define NSLog(...)
#endif


/// 获取系统单例
#define JMKeyWindow [UIApplication sharedApplication].keyWindow
#define XLMM_APP ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define JMNotificationCenter [NSNotificationCenter defaultCenter]
#define JMUserDefaults [NSUserDefaults standardUserDefaults]
#define JMApplication [UIApplication sharedApplication]

/**
 *  循环引用
 */
#define kWeakSelf __weak typeof (self) weakSelf = self;
#define kStrongSelf __strong typeof (weakSelf) strongSelf = weakSelf;
// 当前版本
#define FSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SSystemVersion ([[UIDevice currentDevice] systemVersion])
// 当前语言
#define CURRENTLANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])
// 获得屏幕宽高
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
// ios7之上的系统
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
// ios8之上的系统
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

// 判断字段时候为空的情况
#define IF_NULL_TO_STRING(x) ([(x) isEqual:[NSNull null]]||(x)==nil || [(x) isEqual:@""])? @"":CS_STRING(x)
// 字符串处理
#define CS_STRING(string)           [NSString stringWithFormat:@"%@",string]
#define CS_DSTRING(string1,string2) [NSString stringWithFormat:@"%@%@",string1,string2]
#define CS_INTEGER(integer)         [NSString stringWithFormat:@"%ld",integer]
#define CS_FLOAT(float)             [NSString stringWithFormat:@"%.2f",float]

//字体处理
#define CS_UIFontBoldSize(fontSize)      [UIFont boldSystemFontOfSize:fontSize]
#define CS_UIFontSize(fontSize)          [UIFont systemFontOfSize:fontSize]
#define CS_UIFontNameSize(name,fontSize) [UIFont fontWithName:(name) size:(fontSize)]
#define CS_UIFontMSYHSize(fontSize)      [UIFont fontWithName:@"MicrosoftYaHei" size:(fontSize)]

// 图片处理
#define CS_UIImageName(name) [UIImage imageNamed:name]

// 主页分类 比例布局
#define HomeCategoryRatio               SCREENWIDTH / 320.0
#define HomeCategorySpaceW              25 * HomeCategoryRatio
#define HomeCategorySpaceH              20 * HomeCategoryRatio

// 十六进制颜色
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])


















#endif /* JMToolMacro_h */

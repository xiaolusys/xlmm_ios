//
//  JMToolMacro.h
//  XLMM
//
//  Created by zhang on 16/9/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#ifndef JMToolMacro_h
#define JMToolMacro_h

// 判断字段时候为空的情况
#define IF_NULL_TO_STRING(x) ([(x) isEqual:[NSNull null]]||(x)==nil || [(x) isEqual:@""])? @"":TEXT_STRING(x)
// 转换为字符串
#define TEXT_STRING(x)              [NSString stringWithFormat:@"%@",x]

// 添加URL
#define URL(url)                    [NSURL URLWithString:url]

// 字符串处理
#define CS_STRING(string)           [NSString stringWithFormat:@"%@",string]
#define CS_DSTRING(string1,string2) [NSString stringWithFormat:@"%@%@",string1,string2]
#define CS_INTEGER(integer)         [NSString stringWithFormat:@"%ld",integer]
#define CS_FLOAT(float)             [NSString stringWithFormat:@"%.2f",float]

//字体处理
#define CS_BOLDSYSTEMFONT(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define CS_SYSTEMFONT(fontSize)     [UIFont systemFontOfSize:fontSize]
#define CS_FONT_NAME(name,fontSize) [UIFont fontWithName:(name) size:(fontSize)]
#define CS_MSYH(fontSize)           [UIFont fontWithName:@"MicrosoftYaHei" size:(fontSize)]

// 图片处理
#define CS_IMAGE(name) [UIImage imageNamed:name]

// 主页分类 比例布局
#define HomeCategoryRatio               SCREENWIDTH / 320.0
#define HomeCategorySpaceW              25 * HomeCategoryRatio
#define HomeCategorySpaceH              20 * HomeCategoryRatio

// 十六进制颜色
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])















#endif /* JMToolMacro_h */

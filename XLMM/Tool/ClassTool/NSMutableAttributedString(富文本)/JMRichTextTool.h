//
//  JMRichTextTool.h
//  XLMM
//
//  Created by zhang on 16/9/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface JMRichTextTool : NSObject

/**
 *  改变字符串中某些文字的颜色
 *
 *  @param color     需要改变成的颜色
 *  @param allStr    字符串
 *  @param subStrArr 需要改变颜色的文字数组
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeColorWithColor:(UIColor *)color AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr;

/*
 *  改变字符文字的字间距
 *
 *  @param allString 字符串
 *  @param lineSpace 字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeTextSapceWithAllString:(NSString *)allString TextSpace:(CGFloat)textSpace;

/*
 *  改变字符串段落的行间距
 *
 *  @param allString 字符串
 *  @param lineSpace 行间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLineSapceWithAllString:(NSString *)allString LineSpace:(CGFloat)lineSpace;

/**
 *  改变字符串段落的行间距和文字间距
 *
 *  @param allString 字符串
 *  @param lineSpace 行间距
 *  @param textSpace 字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLineAndTextSpaceWithAllString:(NSString *)allString LineSpace:(CGFloat)lineSpace TextSpace:(CGFloat)textSpace;

/**
 *  改变某些文字的颜色,并设置字体
 *
 *  @param subFont   字体
 *  @param subColor  颜色
 *  @param allStr    字符串
 *  @param subStrArr 需要改变颜色和字体的文字数组
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeFontAndColorWithSubFont:(UIFont *)subFont SubColor:(UIColor *)subColor AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr;
+ (NSMutableAttributedString *)cs_changeFontAndColorWithSubFont:(UIFont *)subFont AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr;

/**
 *  为某些文字添加下划线
 *
 *  @param allString 字符串
 *  @param subStrArr 需要添加下划线的文字数组
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLinkWithAllString:(NSString *)allString SubStringArray:(NSArray *)subStrArr;









@end

































































































//
//  JMRichTextTool.m
//  XLMM
//
//  Created by zhang on 16/9/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRichTextTool.h"

@implementation JMRichTextTool

/**
 *  改变字符串中某些文字的颜色
 *
 *  @param color     需要改变成的颜色
 *  @param allStr    字符串
 *  @param subStrArr 需要改变颜色的文字数组
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeColorWithColor:(UIColor *)color AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    for (NSString *rangeStr in subStrArr) {
        NSMutableArray *array = [self cs_getRangeWithAllString:allStr SubString:rangeStr];
        for (NSNumber *rangeNum in array) {
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    return attributedStr;
}

/*
 *  改变字符文字的字间距
 *
 *  @param allString 字符串
 *  @param lineSpace 字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeTextSapceWithAllString:(NSString *)allString TextSpace:(CGFloat)textSpace {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allString];
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];   // 需要 <CoreText/CoreText.h>
    CFRelease(num);
    return attributedStr;
}


/*
 *  改变字符串段落的行间距
 *
 *  @param allString 字符串
 *  @param lineSpace 行间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLineSapceWithAllString:(NSString *)allString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [allString length])];
    
    return attributedStr;

}

/**
 *  改变字符串段落的行间距和文字间距
 *
 *  @param allString 字符串
 *  @param lineSpace 行间距
 *  @param textSpace 字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLineAndTextSpaceWithAllString:(NSString *)allString LineSpace:(CGFloat)lineSpace TextSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [allString length])];
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

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
+ (NSMutableAttributedString *)cs_changeFontAndColorWithSubFont:(UIFont *)subFont SubColor:(UIColor *)subColor AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    
    for (NSString *rangeStr in subStrArr) {
        NSRange range = [allStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:subColor range:range];
        [attributedStr addAttribute:NSFontAttributeName value:subFont range:range];
    }
    
    return attributedStr;
}
+ (NSMutableAttributedString *)cs_changeFontAndColorWithSubFont:(UIFont *)subFont AllString:(NSString *)allStr SubStringArray:(NSArray *)subStrArr {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    
    for (NSString *rangeStr in subStrArr) {
        NSRange range = [allStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSFontAttributeName value:subFont range:range];
    }
    
    return attributedStr;
}

/**
 *  为某些文字添加下划线
 *
 *  @param allString 字符串
 *  @param subStrArr 需要添加下划线的文字数组
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)cs_changeLinkWithAllString:(NSString *)allString SubStringArray:(NSArray *)subStrArr {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:allString];
    
    for (NSString *rangeStr in subStrArr) {
        NSRange range = [allString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:allString range:range];
    }
    
    return attributedStr;
}


/**
 *  获取某个子串在整个字符串中的文字
 *
 *  @param allString 字符串
 *  @param subString 子串
 *
 *  @return 富文本
 */
+ (NSMutableArray *)cs_getRangeWithAllString:(NSString *)allString SubString:(NSString *)subString {
    NSMutableArray *arrayRanges = [NSMutableArray array];
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [allString rangeOfString:subString];
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++) {
            if (0 == i) {
                location = rang.location + rang.length;
                length = allString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = allString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            rang1 = [allString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            } else {
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        return arrayRanges;
    }
    
    return nil;
    
    
    
}









@end




/**
 *
     NSInteger count = limtStr.length;
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(0,6)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(6,count)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(count + 6,1)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0] range:NSMakeRange(0, 6)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0] range:NSMakeRange(6, count)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0] range:NSMakeRange(6+count, 1)];
     self.memberLabel.attributedText = str;
 
 
 
 */












































































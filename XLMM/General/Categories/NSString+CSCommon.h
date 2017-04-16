//
//  NSString+CSCommon.h
//  XLMM
//
//  Created by zhang on 16/9/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (CSCommon)

/**
 *  md5加密(32位 常规)
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5;

/**
 *  md5加密(16位)
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5_16;

/**
 *  sha1加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)sha1;

/**
 *  sha256加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha256;

/**
 *  sha384加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha384;

/**
 *  sha512加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)sha512;

/**
 *  是否含有汉字
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)containsChineseCharacter;

/**
 *  计算字符串高度 （多行）
 *
 *  @param width 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)heightWithWidth:(CGFloat)width andFont:(CGFloat)font;

/**
 *  计算字符串宽度
 *
 *  @param height 字符串的高度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)widthWithHeight:(CGFloat)height andFont:(CGFloat)font;

/**
 *  检测是否含有某个字符
 *
 *  @param string 检测是否含有的字符
 *
 *  @return YES 含有 NO 不含有
 */
- (BOOL)containString:(NSString *)string;

/**
 *  是否含有汉字
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)containsChineseCharacte;

/**
 *  判断字符串是否为空
 *
 *  @return YES 是 NO 不是
 */
+ (BOOL)isStringEmpty:(NSString *)string;
/**
 *  判断字符串是否为纯数字
 *
 *  @return YES 是 NO 不是
 */
+ (BOOL)isStringWithNumber:(NSString *)string;

/**
 *  获得打印日志时间
 *
 *  @return 当前时间
 */
+ (NSString *)jm_stringDate;

/**
 *  时间字符串去掉@"T"字符
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_deleteTimeWithT:(NSString *)timeString;

/**
 *  时间字符串去掉年份与秒
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_cutOutYearWihtSec:(NSString *)timeStr;

/**
 *  时间字符串去掉年月日与秒
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_subWithHourAndMinute:(NSString *)str;
+ (NSString *)jm_subWithHourMinuteSe:(NSString *)str;

/**
 *  时间字符串只包含年月日
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)yearDeal:(NSString *)str;

/**
 *  获取N天前的日期
 *  dayNum : 前后的天数 (+后,-前)
 *  @return N天前的日期
 */
+ (NSString *)getBeforeDay:(NSInteger)dayNum;

/**
 *  获取当前时间
 *
 *  @return 当前的日期
 */
+ (NSString *)getCurrentTime;

/**
 *  获取当前时间 的小时
 *
 *  @return 当前的日期 的小时
 */
+ (NSString *)getCurrentTimeWithHour;

/**
 *  获取两个日期之间的天数
 *
 *  @return 相差天数
 */
+ (NSString *)numberOfDaysWithFromDate:(NSString *)fromDate ToData:(NSString *)toDate;

+ (NSString *)numberOfSecondWithFromData:(NSString *)fromData ToData:(NSString *)toData;


+ (NSString *)getCurrentYMD;
+ (NSString *)getCurrentHourMinute:(NSString *)timeStr;



+ (NSString *)miPushTetOperateType:(NSString *)selector;
+ (NSString *)TimeformatDHMSFromSeconds:(int)second;
+ (NSString *)TimeformatMSFromSeconds:(int)second;


@end















































































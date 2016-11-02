//
//  NSString+CSCommon.m
//  XLMM
//
//  Created by zhang on 16/9/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "NSString+CSCommon.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (CSCommon)




#pragma mark 加密

/**
 *  md5加密(32位 常规)
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

/**
 *  md5加密(16位)
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5_16 {
    // 提取32位MD5散列的中间16位
    NSString *md5_32=[self md5];
    // 即9～25位
    NSString *result = [[md5_32 substringToIndex:24] substringFromIndex:8];
    return result;
}

/**
 *  sha1加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  sha256加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha256 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

/**
 *  sha384加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha384 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

/**
 *  sha512加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)sha512 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mrak 计算字符串尺寸 (宽 高)
/**
 *  计算字符串高度 （多行）
 *
 *  @param width 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)heightWithWidth:(CGFloat)width andFont:(CGFloat)font {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return size;
}

/**
 *  计算字符串宽度
 *
 *  @param height 字符串的高度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)widthWithHeight:(CGFloat)height andFont:(CGFloat)font {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
    return size;
}

#pragma mark 检查是否包含某个字符 , 检查字符串是否为空
/**
 *  检测是否含有某个字符
 *
 *  @param string 检测是否含有的字符
 *
 *  @return YES 含有 NO 不含有
 */
- (BOOL)containString:(NSString *)string {
    return ([self rangeOfString:string].location == NSNotFound) ? NO : YES;
}

/**
 *  是否含有汉字
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)containsChineseCharacter {
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FFF) {
            return YES;
        }
    }
    return NO;
}

/**
 *  判断字符串是否为空
 *
 *  @return YES 是 NO 不是
 */
+ (BOOL)isStringEmpty:(NSString *)string {
//    return [self length] > 0 ? NO : YES;
    return [string isKindOfClass:[NSNull class]] || string == nil || [string isEqual:@""];
}

#pragma mark 时间字符串转换
/**
 *  获得打印日志时间
 *
 *  @return 当前时间
 */
+ (NSString *)jm_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSSSSS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

/**
 *  时间字符串去掉@"T"字符
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_deleteTimeWithT:(NSString *)timeString {
    NSMutableString *string = [NSMutableString stringWithString:timeString];
    NSRange range = [string rangeOfString:@"T"];
    [string replaceCharactersInRange:range withString:@" "];
    return string;
}

/**
 *  时间字符串去掉年份与秒
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_cutOutYearWihtSec:(NSString *)timeStr {
    NSString *string = [NSString jm_deleteTimeWithT:timeStr];
    NSString *string1 = [string substringWithRange:NSMakeRange(5,11)];
    return string1;
}

/**
 *  时间字符串去掉年月日与秒
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)jm_subWithHourAndMinute:(NSString *)str {
    NSString *string = [str substringWithRange:NSMakeRange(11, 5)];
    return string;
}

/**
 *  时间字符串只包含年月日
 *
 *  @return 需要的时间字符串
 */
+ (NSString *)yearDeal:(NSString *)str {
    NSArray *strarray = [str componentsSeparatedByString:@"T"];
    NSString *year = strarray[0];
    return year;
}

/**
 *  获取N天前的日期
 *  dayNum : 前后的天数 (+后,-前)
 *  @return N天前的日期
 */
+ (NSString *)getBeforeDay:(NSInteger)dayNum {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;

    if(dayNum != 0) {
        NSTimeInterval oneDay = 24 * 3600;
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay * dayNum];
    }else {
        theDate = nowDate;
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *getDayString = [dateFormatter stringFromDate:theDate];
//    NSString *date = [getDayString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return getDayString;

    
}
/**
 *  获取当前时间
 *
 *  @return 当前的日期
 */
+ (NSString *)getCurrentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentTime;
    
    
}
+ (NSString *)getCurrentYMD {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentTime;
}

/**
 *  获取两个日期之间的天数
 *
 *  @return 相差天数
 */
+ (NSString *)numberOfDaysWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate1 = [dateFormatter dateFromString:[NSString jm_deleteTimeWithT:fromDate]];
    NSDate *toDate1 = [dateFormatter dateFromString:[NSString jm_deleteTimeWithT:toDate]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate1
                                               toDate:toDate1
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  两个日期之间相差的天数 == comp : %@  << --",comp);
    NSString *dayString = [NSString stringWithFormat:@"%ld",comp.day];
    return dayString;
}





@end







































































































































































































//
//  JMStoreManager.h
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMStoreManager : NSObject
/**
 *  记录程序打开的次数
 */
+ (void)recoderAppLoadNum;

/**
 *  是否是第一次打开程序
 */
+ (BOOL)isFirstLoadApp;

/*
    把对象归档存储到沙盒中
 */
+ (void)storeobject:(id)object FileName:(NSString *)fileName;
+ (BOOL)isFileExist:(NSString *)fileName;
/*
    通过文件名从沙盒中找到归档对象
 */
+ (id)getObjectByFileName:(NSString *)fileName;

/*
    根据文件名删除沙盒中的plist(json)文件
 */
+ (void)removeFileByFileName:(NSString*)fileName;

/*
    存储用户偏好设置 到 NSUserDefults
 */
+ (void)storeUserDefults:(id)data forKey:(NSString*)key;

/*
    读取用户偏好设置
 */
+ (id)readUserDataForKey:(NSString*)key;

/*
    删除用户偏好设置
 */
+ (void)removeUserDataForkey:(NSString*)key;

//获取 一个文件 在沙盒沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)fileName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;


+ (void)saveDataFromDictionary:(NSString *)fileName WithData:(NSDictionary *)dic; // 存储字典
+ (void)saveDataFromArray:(NSString *)fileName WithArray:(NSArray *)arr;     // 存储数组
+ (void)saveDataFromString:(NSString *)fileName WithString:(NSString *)str;      // 存储字符串

+ (NSArray *)getDataArray:(NSString *)fileName;
+ (NSDictionary *)getDataDictionary:(NSString *)fileName;
+ (NSString *)getDataString:(NSString *)fileName;

+ (NSString *)getLastFilePath:(NSString *)fileName;
+ (BOOL)isLastFileExist:(NSString *)fileName;

+ (void)saveDataFromImage:(UIImage *)image WithFilePath:(NSString *)fileName Quality:(CGFloat)quality;
+ (UIImage *)getDataImage:(NSString *)fileName Quality:(CGFloat)quality;

@end









































































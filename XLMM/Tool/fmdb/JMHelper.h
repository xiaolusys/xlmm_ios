//
//  JMHelper.h
//  XLMM
//
//  Created by zhang on 16/7/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHelper : NSObject

//获取 一个文件 在沙盒沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;

@end

//
//  JMHelper.m
//  XLMM
//
//  Created by zhang on 16/7/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHelper.h"

@implementation JMHelper


//获取 一个文件 在沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName {
    //先获取 沙盒中的Library/Caches/路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCacheDirectory = [docPath stringByAppendingPathComponent:@"addressCaches"];
    //检测MyCaches 文件夹是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:myCacheDirectory]) {
        //不存在 那么创建
        [[NSFileManager defaultManager] createDirectoryAtPath:myCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
//    NSString * newName = urlName;
    
    return [myCacheDirectory stringByAppendingPathComponent:urlName];
}
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut {
    //获取文件的属性
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //获取文件的上次的修改时间
    NSDate *lastModfyDate = fileDict.fileModificationDate;
    //算出时间差 获取当前系统时间 和 lastModfyDate时间差
    NSTimeInterval sub = [[NSDate date] timeIntervalSinceDate:lastModfyDate];
    if (sub < 0) {
        sub = -sub;
    }
    //比较是否超时
    if (sub > timeOut) {
        //如果时间差 大于 设置的超时时间 那么就表示超时
        return YES;
    }
    return NO;
}



@end

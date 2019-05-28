//
//  JMStoreManager.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMStoreManager.h"

@implementation JMStoreManager
/**
 *  记录打开的次数
 */
+ (void)recoderAppLoadNum {
    //取出沙盒的key的值
    NSInteger num = [JMUserDefaults integerForKey:kAppLoadNum];
    
    if (num == 0) {
        //第一次打开
    }else {
        
    }
    NSLog(@"%ld",(long)num);
    //num++ 记录打开次数加一
    num ++;
    NSLog(@"%ld",(long)num);
    //保存
    [JMUserDefaults setInteger:num forKey:kAppLoadNum];
    [JMUserDefaults synchronize];
}

/**
 *  是否是第一次打开
 */
+ (BOOL)isFirstLoadApp {
    NSInteger num = [JMUserDefaults integerForKey:kAppLoadNum];
    
    if (num == 1) {
        //第一次打开
        return YES;
    }else {
        return NO;
    }
}
/*
    把对象归档存到沙盒里
 */
+ (void)storeobject:(id)object FileName:(NSString*)fileName {
    if ([self isFileExist:fileName]) {
        return ;
    }
    NSString *path  = [self appendFilePath:fileName];
    
    [NSKeyedArchiver archiveRootObject:object toFile:path];
    
}
+ (BOOL)isFileExist:(NSString *)fileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
/*
    拼接文件路径
 */
+ (NSString*)appendFilePath:(NSString*)fileName {
//    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *file = [NSString stringWithFormat:@"%@/%@.plist",documentsPath,fileName];
    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *file = [Path stringByAppendingPathComponent:fileName];

    
    return file;
}
/*
    通过文件名从沙盒中找到归档的对象
 */
+ (id)getObjectByFileName:(NSString*)fileName {
    
    NSString *path  = [self appendFilePath:fileName];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/*
    根据文件名删除沙盒中的 plist 文件
 */
+ (void)removeFileByFileName:(NSString*)fileName {
    if (![self isFileExist:fileName]) {
        return ;
    }
    NSString *path  = [self appendFilePath:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/*
    存储用户偏好设置 到 NSUserDefults
 */
+ (void)storeUserDefults:(id)data forKey:(NSString*)key {
    if (data) {
        [JMUserDefaults setObject:data forKey:key];
        [JMUserDefaults synchronize];
    }
}
/*  
    读取用户偏好设置
 */
+ (id)readUserDataForKey:(NSString*)key {
    return [JMUserDefaults objectForKey:key];
    
}
/*
    删除用户偏好设置
 */
+ (void)removeUserDataForkey:(NSString*)key {
    [JMUserDefaults removeObjectForKey:key];
}

//获取 一个文件 在沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)fileName {
    //先获取 沙盒中的Library/Caches/路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *myCacheDirectory = [docPath stringByAppendingPathComponent:fileName];
    //检测MyCaches 文件夹是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:myCacheDirectory]) {
        //不存在 那么创建
        [[NSFileManager defaultManager] createDirectoryAtPath:myCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //    NSString * newName = urlName;
    
    return myCacheDirectory;
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






// 存储字典
+ (void)saveDataFromDictionary:(NSString *)fileName WithData:(NSDictionary *)dic {
    if ([self isFileExist:fileName]) {
        return ;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    [dic writeToFile:documentPath atomically:YES];
}
// 存储数组
+ (void)saveDataFromArray:(NSString *)fileName WithArray:(NSArray *)arr {
    if ([self isFileExist:fileName]) {
        return ;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    [arr writeToFile:documentPath atomically:YES];
}
// 存储字符串
+ (void)saveDataFromString:(NSString *)fileName WithString:(NSString *)str {
    if ([self isFileExist:fileName]) {
        return ;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    [str writeToFile:documentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (NSArray *)getDataArray:(NSString *)fileName {
    if (![self isFileExist:fileName]) {
        return nil;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    return [NSArray arrayWithContentsOfFile:documentPath];
}
+ (NSDictionary *)getDataDictionary:(NSString *)fileName {
    if (![self isFileExist:fileName]) {
        return nil;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    return [NSDictionary dictionaryWithContentsOfFile:documentPath];
}
+ (NSString *)getDataString:(NSString *)fileName {
    if (![self isFileExist:fileName]) {
        return nil;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    return [NSString stringWithContentsOfFile:documentPath encoding:NSUTF8StringEncoding error:nil];
}
+ (NSString *)getLastFilePath:(NSString *)fileName {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:fileName];
    return documentPath;
}
+ (BOOL)isLastFileExist:(NSString *)fileName {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [array lastObject];
    NSString *filePath = [documents stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}


+ (void)saveDataFromImage:(UIImage *)image WithFilePath:(NSString *)fileName Quality:(CGFloat)quality {
    if ([self isFileExist:fileName]) {
        return ;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    [UIImageJPEGRepresentation(image, quality)writeToFile:documentPath atomically:YES];
    
}
+ (UIImage *)getDataImage:(NSString *)fileName Quality:(CGFloat)quality {
    if (![self isFileExist:fileName]) {
        return nil;
    }
    NSString *documentPath = [self getLastFilePath:fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
    return image;
}





@end





























































//
//  JMStoreManager.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMStoreManager.h"

@implementation JMStoreManager

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
    NSString *path  = [self appendFilePath:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/*
    存储用户偏好设置 到 NSUserDefults
 */
+ (void)storeUserDefults:(id)data forKey:(NSString*)key {
    if (data) {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
/*  
    读取用户偏好设置
 */
+ (id)readUserDataForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
}
/*
    删除用户偏好设置
 */
+ (void)removeUserDataForkey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}




@end





























































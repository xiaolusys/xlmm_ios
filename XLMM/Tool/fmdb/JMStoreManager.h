//
//  JMStoreManager.h
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMStoreManager : NSObject

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








@end

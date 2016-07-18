//
//  JMDBManager.h
//  XLMM
//
//  Created by zhang on 16/7/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface JMDBManager : NSObject

//非标准单例
+ (JMDBManager *)sharedManager;
//增加 数据 收藏/浏览/下载记录


//存储类型 favorites downloads browses
- (void)insertModel:(id)data;
//删除指定的应用数据
- (void)deleteModelForMid:(NSString *)Mid;

//查找所有的记录
- (NSArray *)readModels;

//返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForMid:(NSString *)Mid;



@end

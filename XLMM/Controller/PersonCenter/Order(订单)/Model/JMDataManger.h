//
//  JMDataManger.h
//  XLMM
//
//  Created by zhang on 17/3/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDataManger : NSObject

/**
 *  数据管理对象单例
 *
 *  @return self
 */
+ (instancetype)sharedInstance;
/**
 *  保存页面数据
 *
 *  @param info   页面数据
 *  @param menuId 菜单id
 */
- (void)savePageInfo:(NSArray *)infoList menuId:(NSString *)menuId;
/**
 *  根据menuId获取相应页面的数据
 *
 *  @param menuId 菜单id
 *
 *  @return 页面数据，可为nil
 */
- (NSArray *)pageInfoWithMenuId:(NSString *)menuId;



@end

//
//  JMGlobal.h
//  XLMM
//
//  Created by zhang on 16/11/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clearCacheBlock)(NSString *sdImageCacheString);

@interface JMGlobal : NSObject

// 清除缓存回调
@property (nonatomic, copy) clearCacheBlock cacheBlock;

+ (JMGlobal *)global;


/*
    判断当前时间与 dayNumber(-前/+后)时间 的判断
 */
- (BOOL)currentTimeWithBeforeDays:(NSInteger)dayNumber;
/*
    清除缓存
 */
- (void)clearCacheWithSDImageCache:(clearCacheBlock)cacheBlock;

- (void)monitoringNetworkStatus;











@end

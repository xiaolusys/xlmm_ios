//
//  JMFirstOpen.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFirstOpen : NSObject

/**
 *  记录程序打开的次数
 */
+ (void)recoderAppLoadNum;

/**
 *  是否是第一次打开程序
 */
+ (BOOL)isFirstLoadApp;

@end

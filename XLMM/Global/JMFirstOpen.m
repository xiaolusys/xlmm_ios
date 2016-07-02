//
//  JMFirstOpen.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFirstOpen.h"

#define kAppLoadNum @"kAppLoadNum"

@implementation JMFirstOpen


/**
 *  记录打开的次数
 */
+ (void)recoderAppLoadNum {
    //取出沙盒的key的值
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:kAppLoadNum];
    
    if (num == 0) {
        //第一次打开
    }else {
        
    }
    NSLog(@"%ld",(long)num);
    //num++ 记录打开次数加一
    num ++;
    NSLog(@"%ld",(long)num);
    //保存
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:kAppLoadNum];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  是否是第一次打开
 */
+ (BOOL)isFirstLoadApp {
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:kAppLoadNum];
    
    if (num > 1) {
        //第一次打开
        return YES;
    }else {
        return NO;
    }
}


@end

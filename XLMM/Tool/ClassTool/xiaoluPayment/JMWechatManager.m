//
//  JMWechatManager.m
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWechatManager.h"

@implementation JMWechatManager

+ (instancetype)wechatManager {
    static JMWechatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JMWechatManager alloc] init];
    });
    return manager;
    
}






@end

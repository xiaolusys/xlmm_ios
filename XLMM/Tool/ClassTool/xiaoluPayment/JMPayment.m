//
//  JMPayment.m
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayment.h"

@implementation JMPayment


+ (instancetype)payMentManager {
    static JMPayment *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    return manager;
}







@end

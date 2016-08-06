//
//  JMTimerWeakTarget.h
//  滚动视图封装
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 cui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMTimerWeakTarget : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)sel;
- (void)timerDidFire:(NSTimer *)timer;

@end

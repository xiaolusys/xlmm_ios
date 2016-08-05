//
//  JMTimerWeakTarget.m
//  滚动视图封装
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "JMTimerWeakTarget.h"

@implementation JMTimerWeakTarget {
    __weak id _target;
    SEL _selector;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel {
    if (self = [super init]) {
        _target = target;
        _selector = sel;
    }
    return self;
}

- (void)timerDidFire:(NSTimer *)timer {
    if (_target) {
        if ([_target respondsToSelector:_selector]) {
//            [_target performSelector:_selector withObject:timer afterDelay:0.0];
            [_target performSelector:_selector withObject:timer];
        }
    }else {
        [timer invalidate];
    }
}


@end

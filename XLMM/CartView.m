//
//  CartView.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartView.h"

//创建单例



@implementation CartView




static CartView *_instance = nil;

+(instancetype)sharedCartView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CartView sharedCartView];
}

- (id)copy{
    return [CartView sharedCartView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

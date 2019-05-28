//
//  JMDelayPopView.m
//  XLMM
//
//  Created by zhang on 16/8/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMDelayPopView.h"

@implementation JMDelayPopView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}



+ (instancetype)defaultPopView {
    return [[JMDelayPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH  , SCREENWIDTH)];
}

- (void)createUI {
    
    [MBProgressHUD showLoading:@""];
    
    
}

@end

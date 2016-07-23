//
//  JMUpdataAppPopView.m
//  XLMM
//
//  Created by zhang on 16/7/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUpdataAppPopView.h"
#import "MMClass.h"

@interface JMUpdataAppPopView ()



@end

@implementation JMUpdataAppPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}

+ (instancetype)defaultPopView {
    return [[JMUpdataAppPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH *0.7 , (SCREENWIDTH * 0.7) * 1.3 + 60)];
}

- (void)createUI {
    
}

@end

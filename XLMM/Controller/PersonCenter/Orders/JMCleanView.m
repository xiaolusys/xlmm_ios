//
//  JMCleanView.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCleanView.h"

@implementation JMCleanView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;//[UIScreen mainScreen].bounds;
    
}




@end













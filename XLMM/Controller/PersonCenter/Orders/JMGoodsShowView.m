//
//  JMGoodsShowView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsShowView.h"

@implementation JMGoodsShowView

//+ (instancetype)showInRect:(CGRect)rect
//{
//    JMGoodsShowView *menu = [[JMGoodsShowView alloc] initWithFrame:rect];
//    menu.userInteractionEnabled = YES;
//    
//    return menu;
//}

//- (instancetype)initWithFrame:(CGRect)frame {
//    
//    if (self = [super initWithFrame:frame]) {
//        
//        
//        
//    }
//    return self;
//}

// 设置内容视图
- (void)setContentView:(UIView *)contentView
{
    // 先移除之前内容视图
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:contentView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _contentView.frame = self.bounds;
}


@end

//
//  JMPopView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopView.h"


#define JMKeyWindow [UIApplication sharedApplication].keyWindow


@implementation JMPopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

// 显示弹出菜单
+ (instancetype)showInRect:(CGRect)rect
{
    JMPopView *menu = [[JMPopView alloc] initWithFrame:rect];
    menu.userInteractionEnabled = YES;
    
    [JMKeyWindow addSubview:menu];
    
    return menu;
}

// 隐藏弹出菜单
+ (void)hide
{
    for (UIView *popMenu in JMKeyWindow.subviews) {
        if ([popMenu isKindOfClass:self]) {
            [popMenu removeFromSuperview];
        }
    }
}

// 设置内容视图
- (void)setContentView:(UIView *)contentView
{
    // 先移除之前内容视图
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
   
    
    [self addSubview:contentView];
    
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算内容视图尺寸
//    CGFloat y = 9;
//    CGFloat margin = 5;
//    CGFloat x = margin;
//    CGFloat w = self.width - 2 * margin;
//    CGFloat h = self.height - y - margin;
    
    _contentView.frame = [UIScreen mainScreen].bounds;
    
}

@end

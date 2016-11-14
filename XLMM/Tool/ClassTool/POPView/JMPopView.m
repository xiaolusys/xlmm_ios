//
//  JMPopView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopView.h"




//@interface JMPopView ()
//
//@property(nonatomic,strong) JMPopView *menu;
//
//@end

@implementation JMPopView

+ (JMPopView *)popView {
    
    static dispatch_once_t onceToken;
    static JMPopView *popView = nil;
    dispatch_once(&onceToken, ^{
        popView = [[JMPopView alloc] init];
    });
    return popView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}
// 显示弹出菜单
+ (instancetype)showInRect:(CGRect)rect {
    JMPopView *menu = [[JMPopView alloc] initWithFrame:rect];
    CGFloat height = rect.size.height;
    menu.userInteractionEnabled = YES;
    [JMKeyWindow addSubview:menu];
    [UIView animateWithDuration:0.3 animations:^{
        menu.transform = CGAffineTransformTranslate(menu.transform, 0, -height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    }];
    
    return menu;
}

// 隐藏弹出菜单
+ (void)hide {
    for (UIView *popMenu in JMKeyWindow.subviews) {
        if ([popMenu isKindOfClass:self]) {
            [UIView animateWithDuration:0.3 animations:^{
                popMenu.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                } completion:^(BOOL finished) {
                    [popMenu removeFromSuperview];
                }];
            }];
        }
    }
}

// 设置内容视图
- (void)setContentView:(UIView *)contentView {
    // 先移除之前内容视图
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
   
    [self addSubview:contentView];
    
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 计算内容视图尺寸
//    CGFloat y = 9;
//    CGFloat margin = 5;
//    CGFloat x = margin;
//    CGFloat w = self.width - 2 * margin;
//    CGFloat h = self.height - y - margin;
    
    _contentView.frame = self.bounds;//[UIScreen mainScreen].bounds;
    
}

@end

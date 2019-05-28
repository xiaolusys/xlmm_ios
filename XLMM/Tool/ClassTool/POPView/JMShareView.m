//
//  JMShareView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareView.h"

@implementation JMShareView

// 设置浅灰色蒙板
- (void)setDimBackground:(BOOL)dimBackground {
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
        self.backgroundColor = [UIColor clearColor];
    }
}

// 显示蒙板
+ (instancetype)show {
    JMShareView *cover = [[JMShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.4;
    
    [JMKeyWindow addSubview:cover];
    
    return cover;
    
}

+ (void)hide {
    for (UIView *share in JMKeyWindow.subviews) {
        if ([share isKindOfClass:self]) {
            [share removeFromSuperview];
        }
    }
}

// 点击蒙板的时候做事情
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.blcok) {
        self.blcok(self);
    }
    // 通知代理移除菜单
//    if ([_delegate respondsToSelector:@selector(coverDidClickCover:)]) {
//        
//        [_delegate coverDidClickCover:self];
//        
//    }
    
    
    
}

@end









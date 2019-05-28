//
//  JMShareButtonView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareButtonView.h"

@implementation JMShareButtonView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加所有的子控件
        [self setUpAllChildView];
    }
    return self;
}


- (void)setUpAllChildView {
    //微信
    [self setUpButtonWithImage:[UIImage imageNamed:@"shareweixin"] target:self action:@selector(btnClick:)];
    
    //朋友圈
    [self setUpButtonWithImage:[UIImage imageNamed:@"shareFirends"] target:self action:@selector(btnClick:)];
    
    //QQ
    [self setUpButtonWithImage:[UIImage imageNamed:@"shareqq"] target:self action:@selector(btnClick:)];
    
    //QQ空间
    [self setUpButtonWithImage:[UIImage imageNamed:@"shareQQSpacing"] target:self action:@selector(btnClick:)];
    
    //微博
    [self setUpButtonWithImage:[UIImage imageNamed:@"shareweibo"] target:self action:@selector(btnClick:)];
    
    //复制链接
    [self setUpButtonWithImage:[UIImage imageNamed:@"sharecopylink"] target:self action:@selector(btnClick:)];
    
    
    
}





- (void)setUpButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
//    [btn setImage:highImage forState:UIControlStateHighlighted];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = self.subviews.count + 100;
    [self addSubview:btn];
    
    
}
- (void)btnClick:(UIButton *)button {
    NSLog(@"sharebutton btnClick %ld", (long)button.tag);
    //点击工具条的时候
    if (_delegate && [_delegate respondsToSelector:@selector(composeShareBtn:didClickBtn:)]) {
        [_delegate composeShareBtn:self didClickBtn:button.tag];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    
    NSUInteger count = self.subviews.count;
    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height / 2;//[UIScreen mainScreen].bounds.size.height;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = 55;
    CGFloat H = 75;
    
    //图片宽 55  高度 75
    //间距
    CGFloat space = (width - 4 * 55) / 8;
    
    for (int i = 0 ; i < count; i++) {
        NSInteger page = i / 4;
        NSInteger index = i % 4;
        UIButton *btn = self.subviews[i];
        X = index * (W + space * 2) + space;
        Y = page * (H + 14) + 8;
        btn.frame = CGRectMake(X, Y, W, H);

    }
}

@end















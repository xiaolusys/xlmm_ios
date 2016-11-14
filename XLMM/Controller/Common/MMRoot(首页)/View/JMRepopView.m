//
//  JMRepopView.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRepopView.h"

@interface JMRepopView ()

@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) UIImageView *topView;

@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic,strong) UIButton *cancleBtn;

@end
@implementation JMRepopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];

    }
    return self;
}
+ (instancetype)showInRect:(CGRect)rect {
    JMRepopView *rePop = [[JMRepopView alloc]initWithFrame:rect];
    [JMKeyWindow addSubview:rePop];
    return rePop;
}
+ (void)hide {
    for (UIView *rePop in JMKeyWindow.subviews) {
        if ([rePop isKindOfClass:self]) {
            [rePop removeFromSuperview];
        }
    }
}

- (void)createUI {

    UIView *rootView = [UIView new];
    [self addSubview:rootView];
    
    
    UIView *baseView = [UIView new];
    [self addSubview:baseView];
    self.baseView = baseView;
    
    UIImageView *topView = [UIImageView new];
    [self.baseView addSubview:topView];
    self.topView = topView;
    self.topView.image = [UIImage imageNamed:@"pop_top"];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseView addSubview:bottomBtn];
    self.bottomBtn = bottomBtn;
    self.bottomBtn.tag = 100;
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"pop_bottom"] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"pop_bottom"] forState:UIControlStateHighlighted];
    //    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //    [self.bottomBtn addGestureRecognizer:tap];
    [self.bottomBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    self.cancleBtn.tag = 101;
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *topImage = [UIImage imageNamed:@"pop_top"];
    CGFloat topImageW = topImage.size.width;
    CGFloat topImageH = topImage.size.height;
    CGFloat topImageWH = topImageW / topImageH;
    CGFloat topH = self.frame.size.width / topImageWH;
    
    kWeakSelf
    CGFloat H = (SCREENWIDTH * 0.7) * 1.3 + 60;
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH *0.7);
        make.height.mas_equalTo(@(H));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf.mas_width);
        make.bottom.equalTo(weakSelf).offset(-60);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.baseView);
        make.height.mas_equalTo(topH);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.baseView);
        make.top.equalTo(weakSelf.topView.mas_bottom);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(@35);
        make.centerX.equalTo(weakSelf.baseView.mas_centerX);
    }];
}
- (void)btnClick:(UIButton *)button {
    if (self.activeBlock) {
        self.activeBlock(button);
    }
    
}
@end








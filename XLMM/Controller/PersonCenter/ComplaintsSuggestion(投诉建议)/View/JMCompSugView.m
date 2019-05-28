//
//  JMCompSugView.m
//  投诉建议
//
//  Created by zhang on 16/6/16.
//  Copyright © 2016年 cui. All rights reserved.
//


#import "JMCompSugView.h"
#import <QuartzCore/QuartzCore.h>

@interface JMCompSugView ()

@property (nonatomic,strong) UIButton *productSugButton;

@property (nonatomic,strong) UIButton *orderDcButton;

@property (nonatomic,strong) UIButton *afterQuesButton;

@property (nonatomic,strong) UIButton *otherQuesButton;


@end

@implementation JMCompSugView {
    BOOL isSelect;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    //产品建议
    [self setUpButtonWithImage:[UIImage imageNamed:@"circle_wallet_Normal"] highImage:[UIImage imageNamed:@"circle_wallet_Selected"] Title:@"产品建议" target:self action:@selector(btnClick:)];
    //订单/配送
    [self setUpButtonWithImage:[UIImage imageNamed:@"circle_wallet_Normal"] highImage:[UIImage imageNamed:@"circle_wallet_Selected"] Title:@"订单/配送" target:self action:@selector(btnClick:)];
    //售后问题
    [self setUpButtonWithImage:[UIImage imageNamed:@"circle_wallet_Normal"] highImage:[UIImage imageNamed:@"circle_wallet_Selected"] Title:@"售后问题" target:self action:@selector(btnClick:)];
    //其他问题
    [self setUpButtonWithImage:[UIImage imageNamed:@"circle_wallet_Normal"] highImage:[UIImage imageNamed:@"circle_wallet_Selected"] Title:@"其他问题" target:self action:@selector(btnClick:)];

}
- (void)btnClick:(UIButton *)button {
    //点击工具条的时候
    if (_delegate && [_delegate respondsToSelector:@selector(composeShareBtn:Button:didClickBtn:)]) {
        [_delegate composeShareBtn:self Button:button didClickBtn:button.tag];
    }

}

- (void)setUpButtonWithImage:(UIImage *)image highImage:(UIImage *)highImage Title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = self.subviews.count + 1;
    if (btn.tag == 1) {
        btn.selected = YES;
    }
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -6, 0.0, 0.0)];
    [self addSubview:btn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat width = self.frame.size.width;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = width/count;
    CGFloat H = 40;

    for (int i = 0 ; i < count; i++) {

        UIButton *btn = self.subviews[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.];
//        [btn.layer setBorderWidth:1];
//        [btn.layer setBorderColor:[UIColor orangeColor].CGColor];
//        [btn.layer setMasksToBounds:YES];

        X = i * W;
        btn.frame = CGRectMake(X, Y, W, H);
    }
}















@end
/**
 *
 
 //    UIButton *productSugButton = [UIButton buttonWithType:UIButtonTypeCustom];
 ////    [self addSubview:productSugButton];
 //    self.productSugButton = productSugButton;
 //    [self.productSugButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
 //    [self.productSugButton setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateSelected];
 //    [self.productSugButton setTitle:@"产品建议" forState:UIControlStateNormal];
 //    self.productSugButton.tag = 100;
 //    self.productSugButton.selected = YES;
 //
 //    UIButton *orderDcButton = [UIButton buttonWithType:UIButtonTypeCustom];
 ////    [self addSubview:orderDcButton];
 //    self.orderDcButton = orderDcButton;
 //    [self.orderDcButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
 //    [self.orderDcButton setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateSelected];
 //    [self.orderDcButton setTitle:@"订单/配送" forState:UIControlStateNormal];
 //
 //    UIButton *afterQuesButton = [UIButton buttonWithType:UIButtonTypeCustom];
 ////    [self addSubview:afterQuesButton];
 //    self.afterQuesButton = afterQuesButton;
 //    [self.afterQuesButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
 //    [self.afterQuesButton setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateSelected];
 //    [self.afterQuesButton setTitle:@"售后问题" forState:UIControlStateNormal];
 //
 //    UIButton *otherQuesButton = [UIButton buttonWithType:UIButtonTypeCustom];
 ////    [self addSubview:otherQuesButton];
 //    self.otherQuesButton = otherQuesButton;
 //    [self.otherQuesButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
 //    [self.otherQuesButton setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateSelected];
 //    [self.otherQuesButton setTitle:@"其他问题" forState:UIControlStateNormal];
 //
 //    [self.productSugButton.layer setBorderWidth:1];
 //    [self.productSugButton.layer setBorderColor:[UIColor orangeColor].CGColor];
 //    [self.productSugButton.layer setMasksToBounds:YES];
 
 //    NSArray *views = @[self.productSugButton,self.orderDcButton,self.afterQuesButton,self.otherQuesButton];
 //    UIView *containerView = [UIView new];
 //    [self addSubview:containerView];
 //
 //
 //    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
 //        make.center.equalTo(containerView.superview);
 //        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, 40));
 //    }];
 //
 //    [self makeEqualWidthViews:views inView:containerView LRpadding:0. ViewPadding:0.];


 *  将view等宽布局与containerView中
 *
 *  @param views         viewArr
 *  @param containerView 容器View
 *  @param LRpadding     距离容器的左右边距
 *  @param viewPadding   各个View的左右边距
 
//- (void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding ViewPadding:(CGFloat)viewPadding {
//
//    UIView *lastView;
//    for (UIView *view in views) {
//        [containerView addSubview:view];
//        [view.layer setBorderWidth:1];
//        [view.layer setBorderColor:[UIColor orangeColor].CGColor];
//        [view.layer setMasksToBounds:YES];
//        if (lastView) {
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(containerView);
//                make.left.equalTo(lastView.mas_right).offset(viewPadding);
//                make.width.equalTo(lastView);
//            }];
//        }else {
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(containerView).offset(LRpadding);
//                make.top.bottom.equalTo(containerView);
//            }];
//        }
//        lastView = view;
//    }
//    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(containerView).offset(-LRpadding);
//    }];
//
//}








 */



























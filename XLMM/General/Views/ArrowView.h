//
//  ArrowView.h
//  ArrowView
//
//  Created by linaicai on 14-5-26.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^clickButton)(UIButton *button);

// 箭头在不同的方向 
typedef NS_ENUM(NSInteger, UIArrowViewSytle)
{
    ArrowView_Left = 0,//箭头在左边
    ArrowView_Right = 1,//箭头在右边
    ArrowView_Top = 2,//箭头在顶边
    ArrowView_Bottom = 3,//箭头在底边

};

#import <UIKit/UIKit.h>

@interface ArrowView : UIControl{
}

@property(nonatomic,assign)NSInteger style;
@property (nonatomic, assign) CGFloat height;

// block 语句
@property(nonatomic,weak)clickButton selectBlock;


//创建 View


- (id)initWithFrame:(CGRect)frame style:(UIArrowViewSytle)style height:(CGFloat)height;
// 隐藏 显示 移除 View。。。
- (void)hidArrowView:(BOOL)animated;

- (void)showArrowView:(BOOL)animated;

- (void)dismissArrowView:(BOOL)animated;

//  添加一些东西
- (void)addUIButtonWithTitle:(NSArray *)title;

@end

//
//  RootViewController.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *buttonView;

//设置视图宽度为屏幕的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthView;
//修改标题的高度 实现隐藏效果
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
//标题视图
@property (weak, nonatomic) IBOutlet UIView *headView;
//海报视图
@property (weak, nonatomic) IBOutlet UIView *posterView;
//潮童专区视图
@property (weak, nonatomic) IBOutlet UIView *childView;
//时尚女装视图
@property (weak, nonatomic) IBOutlet UIView *ladyView;

- (IBAction)btnClicked:(UIButton *)sender;


@end

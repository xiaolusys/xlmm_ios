//
//  JMPopViewAnimationDrop.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPopViewAnimationDrop;
typedef enum : NSUInteger {
    JMPopViewStyleAnimationDrop,
    JMPopViewStyleAnimationSpring,
} JMPopViewAnimationStyle;

@interface JMPopViewAnimationDrop : UIView

@property (nonatomic, assign, readonly) JMPopViewAnimationStyle popStyle;


/*
    弹出框提示(类似alertView)
 */
+ (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView;
+ (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView;

/*
    弹出视图(类似分享视图)
 */
+ (void)showPopView:(UIView *)maskView PopView:(UIView *)popView SizeHeight:(CGFloat)height;
+ (void)hindPopView:(UIView *)maskView PopView:(UIView *)popView;
+ (CATransform3D)firstStepTransform;
+ (CATransform3D)secondStepTransform;

@end

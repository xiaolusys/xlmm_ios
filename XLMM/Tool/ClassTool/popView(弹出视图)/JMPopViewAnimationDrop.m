//
//  JMPopViewAnimationDrop.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopViewAnimationDrop.h"




@implementation JMPopViewAnimationDrop

- (instancetype)initWithStyle:(JMPopViewAnimationStyle)style {
    if (self = [super init]) {
        _popStyle = style;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView {
    popupView.center = CGPointMake(overlayView.center.x, -popupView.bounds.size.height/2);
    
    popupView.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    
    [UIView animateWithDuration:0.30f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popupView.transform = CGAffineTransformMakeRotation(0);
        popupView.center = overlayView.center;
    } completion:nil];
}

+ (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView {
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        overlayView.alpha = 0.0;
        popupView.center = CGPointMake(overlayView.center.x, overlayView.bounds.size.height+popupView.bounds.size.height);
        popupView.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}



+ (void)showPopView:(UIView *)maskView PopView:(UIView *)popView SizeHeight:(CGFloat)height {
    [UIView animateWithDuration:0.2 animations:^{
//        maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            popView.transform = CGAffineTransformTranslate(popView.transform, 0, -height);
        }];
    }];
    
}
+ (void)hindPopView:(UIView *)maskView PopView:(UIView *)popView {
    [UIView animateWithDuration:0.3 animations:^{
        popView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            maskView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [popView removeFromSuperview];
        }];
    }];
    
}

// 动画1
+ (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}
// 动画2
+ (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, SCREENHEIGHT * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}











@end

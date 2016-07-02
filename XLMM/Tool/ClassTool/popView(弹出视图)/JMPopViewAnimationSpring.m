//
//  JMPopViewAnimationSpring.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopViewAnimationSpring.h"

@implementation JMPopViewAnimationSpring

+ (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView {
    popupView.center = CGPointMake(overlayView.center.x, overlayView.center.y);
    
    overlayView.alpha = 0.3;
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [popupView.layer addAnimation:popAnimation forKey:nil];
}

+ (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView {
    
    [UIView animateWithDuration:0.4 animations:^{
        overlayView.alpha = 0;
    }];
    
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    hideAnimation.delegate = self;
    [popupView.layer addAnimation:hideAnimation forKey:nil];
    
    [popupView removeFromSuperview];
    [overlayView removeFromSuperview];
    
}


@end

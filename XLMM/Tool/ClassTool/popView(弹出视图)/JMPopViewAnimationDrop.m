//
//  JMPopViewAnimationDrop.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopViewAnimationDrop.h"

@implementation JMPopViewAnimationDrop

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


@end

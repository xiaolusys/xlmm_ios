//
//  MBProgressHUD+JMHUD.m
//  XLMM
//
//  Created by zhang on 16/8/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MBProgressHUD+JMHUD.h"

@implementation MBProgressHUD (JMHUD)

#pragma mark 提示可自动消失
+ (void)showSuccess:(NSString *)success {
    [self showCustomIcon:@"progressSuccess" Title:success ToView:nil];
}
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view {
    [self showCustomIcon:@"progressSuccess" Title:success ToView:view];
}

+ (void)showError:(NSString *)error {
    [self showCustomIcon:@"progressError" Title:error ToView:nil];
}
+ (void)showError:(NSString *)error ToView:(UIView *)view {
    [self showCustomIcon:@"progressError" Title:error ToView:view];
}

+ (void)showWarning:(NSString *)warn {
    [self showCustomIcon:@"progressWarning" Title:warn ToView:nil];
}
+ (void)showWarning:(NSString *)warn ToView:(UIView *)view {
    [self showCustomIcon:@"progressWarning" Title:warn ToView:view];
}

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view {
    [self hideHUDForView:view];
//    [self hideHUDView:view];
//    [self hideHUD];
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
//    hud.label.font = [UIFont systemFontOfSize:14.];
//    hud.dimBackground = NO;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);     // 指示框位置
//    hud.detailsLabel.text = @"我是文本详情";                  // 可以设置文本详情
//    hud.minSize = CGSizeMake(150.f, 100.f);                 // 指示框最小范围
//    hud.margin = 20.;                                       // 指示框内容距离边框间距
    hud.contentColor = [UIColor whiteColor];               // 文字内容颜色
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0f];
}

#pragma mark 文字提示,自动消失,无图
+ (void)showMessage:(NSString *)message {
    [self showMessage:message ToView:nil];
}
+ (void)showMessage:(NSString *)message ToView:(UIView *)view {
    [self showMessage:message ToView:view RemainTime:1.5f Model:MBProgressHUDModeText];
}


#pragma mark 可以自定义时间的提示
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeIndeterminate];
    
}
+ (void)showMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeText];
}
+(void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model {
    [self hideHUDForView:nil];
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.contentColor = [UIColor whiteColor];               // 文字内容颜色
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = message;
    hud.mode = model;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:time];
    
}

#pragma mark 文字+菊花提示,不自动消失
+ (MBProgressHUD *)showTitle:(NSString *)title ToView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = [UIColor whiteColor];               // 文字内容颜色
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = NO;        // 蒙版效果
    return hud;
}
+ (MBProgressHUD *)hideHUDView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud hideAnimated:YES];
    return hud;
}


+ (void)showLoading:(NSString *)title {
    [self showTitle:title ToView:nil];
}
+ (void)showLoading:(NSString *)title ToView:(UIView *)view {
    [self showTitle:title ToView:view];
}



#pragma mark 隐藏提示
+ (void)hideHUD {
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

@end




























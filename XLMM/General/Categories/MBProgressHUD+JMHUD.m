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
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    
//    if ([iconName isEqualToString:@"progressError"] || [iconName isEqualToString:@"progressSuccess"]) {
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
//    }else{
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
//    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
}

#pragma mark 文字提示,自动消失,无图
+ (void)showMessage:(NSString *)message {
    [self showMessage:message ToView:nil];
}
+ (void)showMessage:(NSString *)message ToView:(UIView *)view {
    [self showMessage:message ToView:view RemainTime:1.f Model:MBProgressHUDModeText];
}


#pragma mark 可以自定义时间的提示
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeIndeterminate];
    
}
+ (void)showMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeText];
}
+(void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.mode = model;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;        // 蒙版效果
    [hud hideAnimated:YES afterDelay:time];
    
}

#pragma mark 文字+菊花提示,不自动消失
+ (MBProgressHUD *)showTitle:(NSString *)title ToView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
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




























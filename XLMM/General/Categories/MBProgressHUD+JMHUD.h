//
//  MBProgressHUD+JMHUD.h
//  XLMM
//
//  Created by zhang on 16/8/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (JMHUD)



/**
 *  成功的提示,自动消失.
 *
 *  @param success 显示的文字
 *  @param view    添加的View
 */
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view;

/**
 *  失败的提示,自动消失.
 *
 *  @param error 显示的文字
 *  @param view  添加的View
 */
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error ToView:(UIView *)view;

/**
 *  警告的提示,自动消失
 *
 *  @param warn 显示的文字
 *  @param view 添加的View
 */
+ (void)showWarning:(NSString *)warn;
+ (void)showWarning:(NSString *)warn ToView:(UIView *)view;


/**
 *  隐藏ProgressView
 *
 *  @param view superView
 */
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

/**
 *  文字提示,自动消失.无图
 *
 *  @param message 提示文字
 */
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message ToView:(UIView *)view;


/**
 *  自定义等待时间,有菊花
 *
 *  @param message 显示的文字
 *  @param view  添加的View
 *  @param time  等待的时间
 */
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time;
/**
 *  自定义等待时间,无菊花
 *
 *  @param message 显示的文字
 *  @param view  添加的View
 *  @param time  等待的时间
 */
+ (void)showMessage:(NSString *)message ToView:(UIView *)view WaitTime:(CGFloat)time;

/**
 *  不自动消失,带菊花
 *
 *  @param title 提示文字
 *  @param view  添加的View
 */
+ (void)showLoading:(NSString *)title ToView:(UIView *)view;
+ (void)showLoading:(NSString *)title;
/**
 *  不自动消失,带菊花
 *
 *  @param message 提示文字
 *  @param view    添加的View
 *
 *  @return
 */
+ (MBProgressHUD *)showTitle:(NSString *)title ToView:(UIView *)view;
+ (MBProgressHUD *)hideHUDView:(UIView *)view;







@end





































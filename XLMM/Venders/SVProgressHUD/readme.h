

//
//  readme.h
//  XLMM
//
//  Created by younishijie on 15/12/8.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#ifndef readme_h
#define readme_h
Manually

Drag the SVProgressHUD/SVProgressHUD folder into your project.
Take care that SVProgressHUD.bundle is added to Targets->Build Phases->Copy Bundle Resources.
Add the QuartzCore framework to your project.
Usage

(see sample Xcode project in /Demo)

SVProgressHUD is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call [SVProgressHUD method]).
 
 Use SVProgressHUD wisely! Only use it if you absolutely need to perform a task before taking the user forward. Bad use case examples: pull to refresh, infinite scrolling, sending message.
 
 Using SVProgressHUD in your app will usually look as simple as this (using Grand Central Dispatch):
 
 [SVProgressHUD show];
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
// time-consuming task
dispatch_async(dispatch_get_main_queue(), ^{
[SVProgressHUD dismiss];
});
});
 Showing the HUD
 
 You can show the status of indeterminate tasks using one of the following:
 
 + (void)show;
 + (void)showWithStatus:(NSString*)string;
 If you'd like the HUD to reflect the progress of a task, use one of these:
 
 + (void)showProgress:(CGFloat)progress;
 + (void)showProgress:(CGFloat)progress status:(NSString*)status;
 Dismissing the HUD
 
 The HUD can be dismissed using:
 
 + (void)dismiss;
 + (void)dismissWithDelay:(NSTimeInterval)delay;
 If you'd like to stack HUDs, you can balance out every show call using:
 
 + (void)popActivity;
 The HUD will get dismissed once the popActivity calls will match the number of show calls.
 
 Or show a confirmation glyph before before getting dismissed a little bit later. The display time depends on the length of the given string (between 0.5 and 5 seconds).
 
 + (void)showInfoWithStatus:(NSString *)string;
 + (void)showSuccessWithStatus:(NSString*)string;
 + (void)showErrorWithStatus:(NSString *)string;
 + (void)showImage:(UIImage*)image status:(NSString*)string;
 Customization
 
 SVProgressHUD can be customized via the following methods:
 
 + (void)setDefaultStyle:(SVProgressHUDStyle)style;                  // default is SVProgressHUDStyleLight
 + (void)setDefaultMaskType:(SVProgressHUDMaskType)maskType;         // default is SVProgressHUDMaskTypeNone
 + (void)setDefaultAnimationType:(SVProgressHUDAnimationType)type;   // default is SVProgressHUDAnimationTypeFlat
 + (void)setMinimumSize:(CGSize)minimumSize;                         // default is CGSizeZero, can be used to avoid resizing for a larger message
 + (void)setRingThickness:(CGFloat)width;                            // default is 2 pt
 + (void)setRingRadius:(CGFloat)radius;                              // default is 18 pt
 + (void)setRingNoTextRadius:(CGFloat)radius;                        // default is 24 pt
 + (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
 + (void)setFont:(UIFont*)font;                                      // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
 + (void)setForegroundColor:(UIColor*)color;                         // default is [UIColor blackColor], only used for SVProgressHUDStyleCustom
 + (void)setBackgroundColor:(UIColor*)color;                         // default is [UIColor whiteColor], only used for SVProgressHUDStyleCustom
 + (void)setInfoImage:(UIImage*)image;                               // default is the bundled info image provided by Freepik
 + (void)setSuccessImage:(UIImage*)image;                            // default is bundled success image from Freepik
 + (void)setErrorImage:(UIImage*)image;                              // default is bundled error image from Freepik
 + (void)setViewForExtension:(UIView*)view;                          // default is nil, only used if #define SV_APP_EXTENSIONS is set
 + (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;     // default is 5.0 seconds
 Additionally SVProgressHUD supports the UIAppearance protocol for most of the above methods.
 
 Hint
 
 As standard SVProgressHUD offers two preconfigured styles:
 
 SVProgressHUDStyleLight: White background with black spinner and text
 SVProgressHUDStyleDark: Black background with white spinner and text
 If you want to use custom colors with setForegroundColor and setBackgroundColor: don't forget to set SVProgressHUDStyleCustom via setDefaultStyle:.
 
 Notifications
 
 SVProgressHUD posts four notifications via NSNotificationCenter in response to being shown/dismissed:
 
 SVProgressHUDWillAppearNotification when the show animation starts
 SVProgressHUDDidAppearNotification when the show animation completes
 SVProgressHUDWillDisappearNotification when the dismiss animation starts
 SVProgressHUDDidDisappearNotification when the dismiss animation completes
 Each notification passes a userInfo dictionary holding the HUD's status string (if any), retrievable via SVProgressHUDStatusUserInfoKey.
 
 SVProgressHUD also posts SVProgressHUDDidReceiveTouchEventNotification when users touch on the overall screen or SVProgressHUDDidTouchDownInsideNotification when a user touches on the HUD directly. For this notifications userInfo is not passed but the object parameter contains the UIEvent that related to the touch.

#endif /* readme_h */

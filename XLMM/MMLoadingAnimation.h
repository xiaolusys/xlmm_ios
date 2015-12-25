//
//  MMLoadingAnimation.h
//  XLMM
//
//  Created by younishijie on 15/12/25.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLoadingAnimation : UIView

+ (MMLoadingAnimation *)sharedView;

+ (void)showLoadingView;
+ (void)dismissLoadingView;

@end

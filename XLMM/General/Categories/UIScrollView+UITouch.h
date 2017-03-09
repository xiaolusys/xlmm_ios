//
//  UIScrollView+UITouch.h
//  XLMM
//
//  Created by zhang on 17/2/6.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UITouch)

/**
 *  判断指定的frame是否在当前屏幕的可视范围内
 *
 *  @param frame      视图的frame
 *  @param preloading 是否需要预加载
 *
 *  @return 是否需要显示
 */
- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame preloading:(BOOL)preloading;
/**
 *  判断menuItem的frame是否需要显示在菜单栏上
 *
 *  @param frame item的frame
 *
 *  @return 是否需要显示在菜单栏上
 */
- (BOOL)vtm_isItemNeedDisplayWithFrame:(CGRect)frame;


@end

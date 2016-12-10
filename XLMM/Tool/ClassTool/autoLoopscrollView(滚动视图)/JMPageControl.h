//
//  JMPageControl.h
//  XLMM
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMPageControl : UIControl

/**
 *  页面总数
 */
@property (nonatomic, assign) NSInteger numberOfPages;

/**
 *  当前展示的页
 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 *  正常状态的试图（非当前页）
 */
@property (nonatomic, strong) UIView * normalPageView;

/**
 *  选中状态的试图（当前页）
 */
@property (nonatomic, strong) UIView * currentPageView;

/**
 *  分页控件的试图之间的间距
 */
@property (nonatomic, assign) CGFloat padding;








@end

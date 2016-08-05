//
//  JMAutoLoopScrollView.h
//  滚动视图封装
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 cui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMAutoLoopScrollView;
@class JMRollView;

typedef enum : NSUInteger {
    JMAutoLoopScrollStyleVertical,
    JMAutoLoopScrollStyleHorizontal,
} JMAutoLoopScrollViewStyle;

@protocol JMAutoLoopScrollViewDatasource <NSObject>

@required
- (NSUInteger)jm_numberOfNewViewInScrollView:(JMAutoLoopScrollView *)scrollView;
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView newViewIndex:(NSUInteger)index forRollView:(JMRollView *)rollView;

@end

@protocol JMAutoLoopScrollViewDelegate <NSObject>

@optional
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didSelectedIndex:(NSUInteger)index;
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didDidScrollToPage:(NSUInteger)page;

@end

@interface JMAutoLoopScrollView : UIScrollView

@property (nonatomic, weak) id<UIScrollViewDelegate> myDelegate;

@property (nonatomic, weak) id<JMAutoLoopScrollViewDatasource> jm_scrollDataSource;
@property (nonatomic, weak) id<JMAutoLoopScrollViewDelegate> jm_scrollDelegate;
/**
 *  是否允许自动轮播 -- > 默认YES
 */
@property (nonatomic, assign) BOOL jm_isAutoLoopScroll;
/**
 *  时间间隔 -- > 默认3秒 不得小于1秒
 */
@property (nonatomic, assign) CGFloat jm_autoScrollInterval;
/**
 *  数组个数为一的时候是否关闭自动轮播
 */
@property (nonatomic, assign) BOOL jm_isStopScrollForSingleCount;
/**
 *  设置滚动方向 -- > 默认竖直方向滚动
 */
@property (nonatomic, assign, readonly) JMAutoLoopScrollViewStyle jm_scrollStyle;

// == 滚动视图的加载方式 == //
- (void)jm_registerNib:(UINib *)contentNib;
- (void)jm_registerClass:(Class)contentClass;

- (instancetype)initWithStyle:(JMAutoLoopScrollViewStyle)style;

/**
 *  刷新数据
 */
- (void)jm_reloadData;

@end






























































//
//  JMPageControl.m
//  XLMM
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPageControl.h"


@interface JMPageControl ()

@end


@implementation JMPageControl

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - Custom Accessors

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < 0) {
        return ;
    }
    if (self.subviews.count == 0) {
        return ;
    }
    _currentPage = currentPage;
    // 获取的试图
    UIView * currentPageView = self.subviews[currentPage];
    [currentPageView addSubview:_currentPageView];
}

- (void)setNormalPageView:(UIView *)normalPageView {
    _normalPageView = normalPageView;
}

- (void)setCurrentPageView:(UIView *)currentPageView {
    _currentPageView = currentPageView;
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    if (numberOfPages == 1) {
        return ;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    // 一组视图的宽度
    CGFloat allWidth = _numberOfPages * _normalPageView.bounds.size.width + (_numberOfPages - 1) * self.padding;
    // 创建正常状态的试图
    for (int i = 0; i < self.numberOfPages; i ++) {
        CGFloat pageViewX = ([UIScreen mainScreen].bounds.size.width - allWidth) / 2 + i * _normalPageView.bounds.size.width + i * self.padding;
        
        UIView * pageView = [self duplicate:_normalPageView];
        pageView.frame = CGRectMake(pageViewX, 20 - _normalPageView.bounds.size.height / 2 , _normalPageView.bounds.size.width, _normalPageView.bounds.size.height);
        [self addSubview:pageView];
        if (i == 0) {
            // 设置frame
            [pageView addSubview:_currentPageView];
        }
    }
}

/**
 *   复制（深拷贝）
 */
- (UIView*)duplicate:(UIView*)view {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end














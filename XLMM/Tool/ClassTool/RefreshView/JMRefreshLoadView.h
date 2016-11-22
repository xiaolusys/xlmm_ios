//
//  JMRefreshLoadView.h
//  XLMM
//
//  Created by zhang on 16/11/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMRefreshLoadView : UIView


@property (nonatomic, weak  ) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat progressOffsetY;

- (void)setLineLayerStrokeWithProgress:(CGFloat)progress;
- (void)startLoading;
- (void)endLoading;

@end

//
//  MJAnimationHeader.m
//  XLMM
//
//  Created by zhang on 16/11/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MJAnimationHeader.h"
#import "JMRefreshLoadView.h"

@interface MJAnimationHeader () {
    CGFloat progressOffsetY;
}

@property (nonatomic, assign) CGFloat offsetProgress;
@property (nonatomic, strong) JMRefreshLoadView *refreshLoadView;
@end

@implementation MJAnimationHeader
- (JMRefreshLoadView *)refreshLoadView {
    if (!_refreshLoadView) {
        _refreshLoadView = [[JMRefreshLoadView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 36) / 2, 9, 36, 36)];
    }
    return _refreshLoadView;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 54.;

    [self addSubview:self.refreshLoadView];
    
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
//    CGFloat arrowCenterX = self.mj_w * 0.5 ;
//    CGFloat arrowCenterY = self.mj_h * 0.5 ;
//    self.refreshLoadView.center = CGPointMake(arrowCenterX, arrowCenterY);
    self.refreshLoadView.frame = CGRectMake((SCREENWIDTH - 36) / 2, 9, 36, 36); 
//    kWeakSelf
//    [self.refreshLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.centerY.equalTo(weakSelf.mas_centerY);
//        make.width.height.mas_equalTo(@(36));
//    }];
    
    
    
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGFloat offsetY = - self.scrollView.mj_offsetY;
//    NSLog(@" 当前的contentOffset ==== > %.2f",offsetY);
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = fabs(self.scrollViewOriginalInset.top);
//    NSLog(@"  头部控件刚好出现的offsetY === > %.2f",happenOffsetY);
//    CGFloat currentOffsetY = happenOffsetY == 0 ? 0 : 64;
//    CGFloat currentOffsetY1 = happenOffsetY == 0 ? 64 : 54;
//    NSLog(@" progress === %.2f",offsetY);
//    NSLog(@" self.progressOffsetY === %.2f",happenOffsetY);
    
    self.refreshLoadView.progressOffsetY = happenOffsetY;
    self.refreshLoadView.scrollView = self.scrollView;
    self.refreshLoadView.progress = offsetY - happenOffsetY;
    
    
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
}
//- (void)setOffsetProgress:(CGFloat)offsetProgress {
//    _offsetProgress = - offsetProgress;
//}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
//            [self.refreshLoadView setLineLayerStrokeWithProgress:self.offsetProgress];
            break;
        case MJRefreshStatePulling:
//            [self.refreshLoadView setLineLayerStrokeWithProgress:self.offsetProgress];
            break;
        case MJRefreshStateRefreshing:
//            [self.refreshLoadView startAni];
            break;
        default:
            break;
    }

    
    
}
//- (void)setOffsetProgress:(CGFloat)offsetProgress {
//    _offsetProgress = offsetProgress;
//}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
//    NSLog(@"%.2f",pullingPercent);
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



- (void)endRefreshing {
    [super endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshLoadView endLoading];
    });
    
}










@end





















































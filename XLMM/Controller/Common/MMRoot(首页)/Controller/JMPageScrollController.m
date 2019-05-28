//
//  JMPageScrollController.m
//  XLMM
//
//  Created by zhang on 17/2/24.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMPageScrollController.h"

extern NSString *const JMPageScrollControllerLeaveTopNotifition;

@interface JMPageScrollController () <UIGestureRecognizerDelegate>

@end

@implementation JMPageScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [JMNotificationCenter addObserver:self selector:@selector(leaveFromTop) name:JMPageScrollControllerLeaveTopNotifition object:nil];
}

- (void)leaveFromTop {
    _scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = scrollView;
                _scrollView.bounces = YES; // 回弹效果
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIscanScroll:)]) {
        [self.delegate scrollViewIscanScroll:scrollView];
    }
}

- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}


@end

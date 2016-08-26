//
//  JMBaseScrollViewController.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBaseScrollViewController.h"
#import "MMClass.h"

@interface JMBaseScrollViewController ()<UIGestureRecognizerDelegate>



@end

@implementation JMBaseScrollViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMessage:) name:@"gotoTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMessage:) name:@"leaveTop" object:nil];
    
    
    
    


}

- (void)scrollMessage:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqual:@"gotoTop"]) {
        NSDictionary *userDic = notification.userInfo;
        NSString *isCanScroll = userDic[@"isCanScroll"];
        if ([isCanScroll isEqual:@"1"]) {
            self.isCanScroll = YES;
            self.scrollerView.showsVerticalScrollIndicator = YES;
        }
    }else if ([notificationName isEqual:@"leaveTop"]) {
        self.scrollerView.contentOffset = CGPointZero;
        self.isCanScroll = NO;
        self.scrollerView.showsVerticalScrollIndicator = NO;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"isCanScroll":@"1"}];
    }
    self.scrollerView = scrollView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 首先判断otherGestureRecognizer 是否是系统的pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 在判断系统手势的state是began还是fail,同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollerView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end







































































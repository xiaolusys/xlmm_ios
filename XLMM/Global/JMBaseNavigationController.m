//
//  JMBaseNavigationController.m
//  XLMM
//
//  Created by zhang on 16/7/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBaseNavigationController.h"

@implementation JMBaseNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak JMBaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.topViewController isMemberOfClass:[viewController class]]) {
        return ;
    }
    [super pushViewController:viewController animated:YES];
}



@end























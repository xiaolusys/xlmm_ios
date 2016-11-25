//
//  CSNavigationController.m
//  XLMM
//
//  Created by zhang on 16/11/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CSNavigationController.h"
#import "CSTabBar.h"

@interface CSNavigationController () <UINavigationControllerDelegate>

@end

@implementation CSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    
    
}

/**
 *  第一次使用这个类的时候调用(一个类只会调用一次)
 */
+ (void)initialize {
    
    // 获取当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor buttonEnabledBackgroundColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
    
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置导航条左,右
       
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageNamed:@"back_image2"] forState:UIControlStateNormal];
////        [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
//        [btn sizeToFit];
//        
//        [btn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    [super pushViewController:viewController animated:animated];
    
    
}
//- (void)backToPre {
//    [self popViewControllerAnimated:YES];
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //获取主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //获取tabBarVc rootViewController
    UITabBarController *tabBarVC = (UITabBarController *)keyWindow.rootViewController;
    
    
    for (UIView *tabBarButton in tabBarVC.tabBar.subviews) {
        if (![tabBarButton isKindOfClass:[CSTabBar class]]) {
            [tabBarButton removeFromSuperview];
        }
    }
    
}




@end





































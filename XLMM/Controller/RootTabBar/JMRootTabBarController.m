//
//  JMRootTabBarController.m
//  XLMM
//
//  Created by zhang on 16/11/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootTabBarController.h"
#import "RootNavigationController.h"
#import "CSTabBarController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface JMRootTabBarController ()

@end

@implementation JMRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"主页",
                                   kImgKey    : @"tabBar_mianPageNomal",
                                   kSelImgKey : @"tabBar_mianPageSelected"},
                                 
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"精品汇",
                                   kImgKey    : @"tabBar_featuredNomal",
                                   kSelImgKey : @"tabBar_featuredSelected"},
                                 
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"购物车",
                                   kImgKey    : @"tabBar_featuredNomal",
                                   kSelImgKey : @"tabBar_featuredSelected"},
                                 
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"收藏",
                                   kImgKey    : @"tabBar_featuredNomal",
                                   kSelImgKey : @"tabBar_featuredSelected"},
                                 
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"我",
                                   kImgKey    : @"tabBar_personalNomal",
                                   kSelImgKey : @"tabBar_personalSelected"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor buttonEnabledBackgroundColor]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    self.selectedIndex = 0;

}

- (void)rootVCPushOtherVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[CSTabBarController class]]) {
        JMKeyWindow.rootViewController = vc;
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}





@end












































































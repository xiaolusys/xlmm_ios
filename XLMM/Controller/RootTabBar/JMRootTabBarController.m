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
#import "JMHomeRootController.h"
#import "JMCartViewController.h"
#import "JMStoreupController.h"



#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface JMRootTabBarController () //<UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) JMHomeRootController *homeVC;
@property (nonatomic, strong) JMCartViewController *cartVC;
@property (nonatomic, strong) JMStoreupController *storeVC;



@end

@implementation JMRootTabBarController

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}

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
                                 
                                 @{kClassKey  : @"JMCartViewController",
                                   kTitleKey  : @"购物车",
                                   kImgKey    : @"tabBar_shoppingCartNomal",
                                   kSelImgKey : @"tabBar_shoppingCartSelected"},
                                 
                                 @{kClassKey  : @"JMStoreupController",
                                   kTitleKey  : @"收藏",
                                   kImgKey    : @"tabBar_collectionNomal",
                                   kSelImgKey : @"tabBar_collectionSelected"},
                                 
                                 @{kClassKey  : @"JMHomeRootController",
                                   kTitleKey  : @"我",
                                   kImgKey    : @"tabBar_personalNomal",
                                   kSelImgKey : @"tabBar_personalSelected"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        [self.vcArray addObject:vc];
        vc.title = dict[kTitleKey];
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.tag = idx;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor buttonEnabledBackgroundColor]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    self.selectedIndex = 0;
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    self.tabBar.backgroundColor = [UIColor whiteColor];

}
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 2) {
        NSLog(@"JMCartViewController --- > 点击了");
        self.cartVC = self.vcArray[item.tag];
        self.cartVC.isHideNavigationLeftItem = YES;
        [[JMGlobal global] showWaitLoadingInView:self.cartVC.view];
        [self.cartVC refreshCartData];

    }else if (item.tag == 3) {
        self.storeVC = self.vcArray[item.tag];
        self.storeVC.isHideNavitaionLeftBar = YES;
        
        
    }
    
}


- (void)rootVCPushOtherVC:(UIViewController *)vc {
    UIViewController *childVC = self.vcArray[self.selectedIndex];
    if ([vc isKindOfClass:[CSTabBarController class]]) {
        JMKeyWindow.rootViewController = vc;
    }else {
        [childVC.navigationController pushViewController:vc animated:YES];
    }
}





@end












































































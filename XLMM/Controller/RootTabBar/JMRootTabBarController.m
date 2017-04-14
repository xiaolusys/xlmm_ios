//
//  JMRootTabBarController.m
//  XLMM
//
//  Created by zhang on 16/11/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootTabBarController.h"
#import "RootNavigationController.h"
#import "JMCartViewController.h"
#import "JMLogInViewController.h"
#import "JMMaMaHomeController.h"
#import "JMHomeRootCategoryController.h"
#import "JMFineClassController.h"
#import "JMHomePageController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface JMRootTabBarController () <UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) JMCartViewController *cartVC;             // 购物车
@property (nonatomic, strong) JMMaMaHomeController *mamaHomeVC;         // 妈妈主页
@property (nonatomic, strong) JMHomeRootCategoryController *categoryVC; // 分类页面
@property (nonatomic, strong) JMFineClassController *fineVC;            // 精品汇
@property (nonatomic, strong) JMHomePageController *homePageVC;         // 主页


@property (nonatomic, strong) UIButton *bageButton;

@end

@implementation JMRootTabBarController

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCartNumber:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [JMNotificationCenter  addObserver:self selector:@selector(setLabelNumber) name:@"logout" object:nil];
    [JMNotificationCenter  addObserver:self selector:@selector(requestCartNumber:) name:@"shoppingCartNumChange" object:nil];
    [JMNotificationCenter  addObserver:self selector:@selector(shoppingCartkuaiquguangguang) name:@"kuaiquguangguangButtonClick" object:nil];
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRefreshFine"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.delegate = self;
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"JMHomePageController",
                                   kTitleKey  : @"首页",
                                   kImgKey    : @"tabBar_mianPageNomal",
                                   kSelImgKey : @"tabBar_mianPageSelected"},

                                 @{kClassKey  : @"JMHomeRootCategoryController",
                                   kTitleKey  : @"分类",
                                   kImgKey    : @"tabBar_categoryNomal",
                                   kSelImgKey : @"tabBar_categorySelected"},

                                 @{kClassKey  : @"JMFineClassController",
                                   kTitleKey  : @"精品汇",
                                   kImgKey    : @"tabBar_featuredNomal",
                                   kSelImgKey : @"tabBar_featuredSelected"},
                                 
                                 @{kClassKey  : @"JMCartViewController",
                                   kTitleKey  : @"购物车",
                                   kImgKey    : @"tabBar_shoppingCartNomal",
                                   kSelImgKey : @"tabBar_shoppingCartSelected"},
                                 
                                 @{kClassKey  : @"JMMaMaHomeController",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"tabBar_personalNomal",
                                   kSelImgKey : @"tabBar_personalSelected"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        [self.vcArray addObject:vc];
        vc.title = dict[kTitleKey];
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = vc.tabBarItem;
        item.tag = idx;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor buttonEnabledBackgroundColor]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
        
    }];
    self.selectedIndex = 0;
    self.homePageVC = self.vcArray[0];
    self.categoryVC = self.vcArray[1];
    self.fineVC = self.vcArray[2];
    self.cartVC = self.vcArray[3];
    self.mamaHomeVC = self.vcArray[4];
//    self.storeVC = self.vcArray[3];
    
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    [self.tabBar setBackgroundImage:[UIImage new]];
//    [self.tabBar setShadowImage:[UIImage new]];
//    self.tabBar.backgroundColor = [UIColor whiteColor];
  
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"首页"]) {
        
    }else if ([viewController.tabBarItem.title isEqualToString:@"分类"]) {
        //        [self.homeVC endAutoScroll];
    }else if ([viewController.tabBarItem.title isEqualToString:@"精品汇"]) {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRefreshFine"]) {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRefreshFine"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self.fineVC refreshLoadMaMaWeb];
//        }
//        [self.homeVC endAutoScroll];
    }else if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
//        [self.homeVC endAutoScroll];
        if ([JMUserDefaults boolForKey:kIsLogin]) {
            self.cartVC.isHideNavigationLeftItem = YES;
            self.cartVC.cartType = @"5";
//            [[JMGlobal global] showWaitLoadingInView:self.cartVC.view];
            //            [self.cartVC refreshCartData];
        }else {
        }
        
    }
//    else if ([viewController.tabBarItem.title isEqualToString:@"收藏"]) {
////        [self.homeVC endAutoScroll];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//            self.storeVC.isHideNavitaionLeftBar = YES;
//        }else {
//        }
//    }
    else if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
//        [self.homeVC endAutoScroll];
        if ([JMUserDefaults boolForKey:kIsLogin]) {
            //            [self.personalVC refreshUserInfo];
        }else {
        }
    }else { }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"精品汇"]) {
        if ([JMUserDefaults boolForKey:kIsLogin]) {
            if (![JMUserDefaults boolForKey:kISXLMM]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小鹿提醒" message:@"您暂时还不是小鹿妈妈哦~ 请关注 \"小鹿美美\" 公众号,获取更多信息 " delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
            [MobClick event:@"tabBarWithFine"];
            return YES;
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            loginVC.isTabBarLogin = YES;
            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
            [viewController presentViewController:rootNav animated:YES completion:nil];
            return NO;
        }
    }else if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
        if ([JMUserDefaults boolForKey:kIsLogin]) {
            [MobClick event:@"tabBarWithShoopingCart"];
            return YES;
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            loginVC.isTabBarLogin = YES;
            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
            [viewController presentViewController:rootNav animated:YES completion:nil];
            return NO;
        }
    }else if ([viewController.tabBarItem.title isEqualToString:@"首页"]) {
        [MobClick event:@"tabBarWithHomeRoot"];
        return YES;
    }else if ([viewController.tabBarItem.title isEqualToString:@"分类"]) {
        [MobClick event:@"tabBarWithMineCategory"];
        return YES;
    }
//    else if ([viewController.tabBarItem.title isEqualToString:@"精品汇"]) {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//            return YES;
//        }else {
//            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
//            loginVC.isTabBarLogin = YES;
//            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
//            [viewController presentViewController:rootNav animated:YES completion:nil];
//            return NO;
//        }
//    }
    else if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if ([JMUserDefaults boolForKey:kIsLogin]) {
            [MobClick event:@"tabBarWithMine"];
            return YES;
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            loginVC.isTabBarLogin = YES;
            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
            [viewController presentViewController:rootNav animated:YES completion:nil];
            return NO;
        }
    }else {
        return YES;
    }
  
}

- (void)shoppingCartkuaiquguangguang {
    self.selectedIndex = 0;
    
}
#pragma mark --- 购物车数量 --- 
- (void)setLabelNumber {
//    [self requestCartNumber];
    self.cartVC.tabBarItem.badgeValue = nil;
}

- (void)requestCartNumber:(NSNotification *)dict {
    NSString *typeS;
//    if (dict == nil) {
    typeS = @"5";
//    }else {
//        typeS = dict.userInfo[@"type"];
//    }
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json?type=%@",Root_URL,typeS];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
        
    }];
    
    
}
- (void)fetchData:(NSDictionary *)dict {
    NSString *cartNum = dict[@"result"];
    if ([cartNum integerValue] == 0) {
        self.cartVC.tabBarItem.badgeValue = nil;
    }else {
//        self.cartVC.tabBarItem.badgeColor = [UIColor buttonEnabledBackgroundColor];
        self.cartVC.tabBarItem.badgeValue = CS_STRING(cartNum);
    }
}




@end
























//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    self.selectedIndex = item.tag;
//    if (item.tag != 0) {
//        [self.homeVC endAutoScroll];
//    }
//    if (item.tag == 2) {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//            self.cartVC = self.vcArray[2];
//            self.cartVC.isHideNavigationLeftItem = YES;
//            [[JMGlobal global] showWaitLoadingInView:self.cartVC.view];
////            [self.cartVC refreshCartData];
//        }else {
//        }
//    }else if (item.tag == 3) {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//            self.storeVC = self.vcArray[item.tag];
//            self.storeVC.isHideNavitaionLeftBar = YES;
//        }else {
//        }
//    }else if (item.tag == 4) {
//        self.personalVC = self.vcArray[4];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//            self.personalVC.isHideNavigationBar = NO;
////            [self.personalVC refreshUserInfo];
//        }else {
//            self.personalVC.isHideNavigationBar = YES;
//        }
//    }else {
//    }
//
//}



















































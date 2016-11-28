//
//  CSTabBarController.m
//  CSPageViewController
//
//  Created by zhang on 16/10/28.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "CSTabBarController.h"
#import "CSTabBarButton.h"
#import "CSTabBar.h"
#import "JMMaMaHomeController.h"
#import "JMFineClassController.h"
#import "JMSocialActivityController.h"
#import "JMMineController.h"
#import "UIImage+ColorImage.h"
#import "CSNavigationController.h"



@interface CSTabBarController () <CSTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) JMMaMaHomeController *homeVC;
@property (nonatomic, strong) JMFineClassController *secondVC;
@property (nonatomic, strong) JMSocialActivityController *thirdVC;
@property (nonatomic, strong) JMMineController *fouthVC;





@end

@implementation CSTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAllChildViewControllers];
    
    //自定义 tabBar
    [self setupTabbar];
    
    



}

/**
 *  初始化tabbar
 */
- (void)setupTabbar {
    
    CSTabBar *customTabBar = [[CSTabBar alloc] initWithFrame:self.tabBar.bounds];
    customTabBar.backgroundColor = [UIColor whiteColor];
    customTabBar.delegate = self;
    
    // 给tabBar传递tabBarItem模型
    customTabBar.items = self.items;
    
    //添加自定义的tabbar
    [self.tabBar addSubview:customTabBar];
    // 移除系统的tabBar
    //    [self.tabBar removeFromSuperview];
    
}

- (void)tabBar:(CSTabBar *)tabBar didSelectedButton:(NSInteger)index {
    
    if (index == 0 && self.selectedIndex == index) {
        //点击首页  刷新
//        [_homeVC refresh];
    }
    
    self.selectedIndex = index;
    if (index != 0) {
        [_homeVC endEarningMessage];
    }
}






//- (void)tabBarDidClickPlusButton:(CSTabBar *)tabBar {
//    NSLog(@"点击了加号按钮");
//    
//}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    NSLog(@"%@",self.tabBar.items);
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

- (void)setupAllChildViewControllers {
    
    //初始化所有的子控制器
    JMMaMaHomeController *homeVC = [[JMMaMaHomeController alloc] init];
    [self setupChildViewController:homeVC title:@"首页" imageName:@"tabBar_mianPageNomal" selectedImageName:@"tabBar_mianPageSelected"];
    _homeVC = homeVC;
    
    JMFineClassController *secondVC = [[JMFineClassController alloc] init];
    [self setupChildViewController:secondVC title:@"精品" imageName:@"tabBar_featuredNomal" selectedImageName:@"tabBar_featuredSelected"];
    _secondVC = secondVC;
    
    JMSocialActivityController *thirdVC = [[JMSocialActivityController alloc] init];
    [self setupChildViewController:thirdVC title:@"论坛" imageName:@"tabBar_mianBBSNomal" selectedImageName:@"tabBar_mianBBSSelected"];
    _thirdVC = thirdVC;

    JMMineController *fouthVC = [[JMMineController alloc] init];
    [self setupChildViewController:fouthVC title:@"我" imageName:@"tabBar_personalNomal" selectedImageName:@"tabBar_personalSelected"];
    _fouthVC = fouthVC;
    
}
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageWithOriginalName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.items addObject:childVc.tabBarItem];
    
    CSNavigationController *nav = [[CSNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
}







@end





























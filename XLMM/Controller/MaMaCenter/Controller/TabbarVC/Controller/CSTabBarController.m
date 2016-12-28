//
//  CSTabBarController.m
//  CSPageViewController
//
//  Created by zhang on 16/10/28.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "CSTabBarController.h"
#import "JMMaMaHomeController.h"
#import "JMFineClassController.h"
#import "JMSocialActivityController.h"
#import "JMMineController.h"
#import "UIImage+ColorImage.h"
#import "RootNavigationController.h"
#import "JMLogInViewController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"


@interface CSTabBarController () <UITabBarControllerDelegate,UITabBarDelegate>

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

    self.delegate = self;
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"JMFineClassController",
                                   kTitleKey  : @"精品汇",
                                   kImgKey    : @"tabBar_featuredNomal",
                                   kSelImgKey : @"tabBar_featuredSelected"},
                                 
                                 @{kClassKey  : @"JMMaMaHomeController",
                                   kTitleKey  : @"我要赚钱",
                                   kImgKey    : @"tabBar_mianPageNomal",
                                   kSelImgKey : @"tabBar_mianPageSelected"},
                                 
                                 @{kClassKey  : @"JMSocialActivityController",
                                   kTitleKey  : @"论坛",
                                   kImgKey    : @"tabBar_mianBBSNomal",
                                   kSelImgKey : @"tabBar_mianBBSSelected"},
                                 
                                 @{kClassKey  : @"JMMineController",
                                   kTitleKey  : @"妈妈中心",
                                   kImgKey    : @"tabBar_personalNomal",
                                   kSelImgKey : @"tabBar_personalSelected"}
                                 ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        [self.items addObject:vc];
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
    self.secondVC = self.items[0];
    self.homeVC = self.items[1];
    self.thirdVC = self.items[2];
    self.fouthVC = self.items[3];
    
 
    
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}



@end








































































































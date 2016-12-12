//
//  CSTabBar.h
//  CSPageViewController
//
//  Created by zhang on 16/10/28.
//  Copyright © 2016年 cui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CSTabBar;

@protocol CSTabBarDelegate <NSObject>

@optional
- (void)tabBar:(CSTabBar *)tabBar didSelectedButton:(NSInteger)index;


- (void)tabBarDidClickPlusButton:(CSTabBar *)tabBar;

@end

@interface CSTabBar : UIView


// items:保存每一个按钮对应tabBarItem模型
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<CSTabBarDelegate> delegate;




@end

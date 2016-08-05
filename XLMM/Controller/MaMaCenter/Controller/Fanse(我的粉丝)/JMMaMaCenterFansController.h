//
//  JMMaMaCenterFansController.h
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMaMaCenterFansController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong)NSNumber *fansNum; 

@property (nonatomic, strong)UIPageViewController *pageControll;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *fansUrlStr;

- (NSArray *)titleArr;

- (NSArray *)classArr;

@end

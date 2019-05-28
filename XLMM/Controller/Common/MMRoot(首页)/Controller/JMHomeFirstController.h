//
//  JMHomeFirstController.h
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMHomePageController;

@protocol JMHomeFirstControllerDelegate <NSObject>

- (void)scrollViewDeceleratingScroll:(UIScrollView *)scrollView;

@end

@interface JMHomeFirstController : UIViewController

@property (nonatomic, weak) id<JMHomeFirstControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *topImageArray;

@property (nonatomic, strong) JMHomePageController *pageController;

- (void)refresh;

@end

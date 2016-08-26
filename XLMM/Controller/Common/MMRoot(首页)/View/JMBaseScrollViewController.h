//
//  JMBaseScrollViewController.h
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseScrollViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, assign) BOOL isCanScroll;

@end

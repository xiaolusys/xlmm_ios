//
//  JMCartViewController.h
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCartViewController : UIViewController

@property (nonatomic, assign) BOOL isHideNavigationLeftItem;
@property (nonatomic, copy) NSString *cartType;
- (void)refreshCartData;

@end

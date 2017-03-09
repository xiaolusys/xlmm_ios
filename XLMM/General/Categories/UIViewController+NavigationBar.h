//
//  UIViewController+NavigationBar.h
//  XLMM
//
//  Created by younishijie on 15/10/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (NavigationBar)

- (void)createNavigationBarWithTitle:(NSString *)title selecotr:(SEL)aSelector;
- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor;



@end

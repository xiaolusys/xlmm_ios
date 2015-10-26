//
//  UIViewController+NavigationBar.m
//  XLMM
//
//  Created by younishijie on 15/10/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "UIViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)


- (void)createNavigationBarWithTitle:(NSString *)title selecotr:(SEL)aSelector{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.png"]];
    imageView.frame = CGRectMake(8, 14, 22, 22);
    [button addSubview:imageView];
    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end

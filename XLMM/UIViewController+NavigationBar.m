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
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image2.png"]];
    imageView.frame = CGRectMake(0, 14, 16, 16);
    [button addSubview:imageView];
    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    button.backgroundColor = [UIColor orangeColor];
    
//    
//    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0)){
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = -16;
//        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
//    }else {
//     self.navigationItem.leftBarButtonItem = leftItem;
//    }
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end

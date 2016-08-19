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
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
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
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    NSLog(@"downLoadWithURLString %@", url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSLog(@"downLoadWithURLString dataWithContentsOfURL %d",data==nil);
        if (data == nil) {
            return;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

@end

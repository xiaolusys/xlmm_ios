//
//  JimeiPontoUiPlugin.m
//  XLMM
//
//  Created by wulei on 5/17/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "JimeiPontoUiPlugin.h"
#import "AppDelegate.h"
#import "JMLogInViewController.h"

@implementation JimeiPontoUiPlugin


+ (id)instance {
    return [[self alloc] init];
}

- (void)showSkuPopup :(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {

        
        NSString *sku = [(NSDictionary *)params objectForKey:@"json"];

        

    }
}

- (void)callNativeLoginActivity:(id)params{
    if ([params isKindOfClass:[NSDictionary class]]) {
        
        
        NSString *url = [(NSDictionary *)params objectForKey:@"pageurl"];
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController* topViewController = appdelegate.window.rootViewController.navigationController.topViewController;
        NSLog(@"%@",topViewController);
        
        JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
        loginVC.returnUrl = url;
        [topViewController.navigationController pushViewController:loginVC animated:YES];
        
    }

}


@end

















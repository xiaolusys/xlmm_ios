//
//  JMRegisterJS.h
//  XLMM
//
//  Created by zhang on 16/12/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMYWebView;
@interface JMRegisterJS : NSObject

+ (instancetype)defaultRegister;
- (void)registerJSBridgeBeforeIOSSeven:(UIViewController *)webVC WebView:(IMYWebView *)baseWebView;


@end

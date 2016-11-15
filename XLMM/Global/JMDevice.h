//
//  JMDevice.h
//  XLMM
//
//  Created by zhang on 16/10/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDevice : NSObject

+ (instancetype)defaultDecice;

- (NSString *)getUserAgent;

- (NSString *)getDeviceName;

- (void)cerateUserAgent;

- (void)getServerIP;

@end

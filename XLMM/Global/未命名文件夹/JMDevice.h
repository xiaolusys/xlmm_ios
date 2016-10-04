//
//  JMDevice.h
//  XLMM
//
//  Created by zhang on 16/10/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDevice : NSObject

+ (JMDevice *)defaultDecice;

- (NSString *)getUserAgent;

- (NSString *)getDeviceName;

@end

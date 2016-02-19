//
//  MMLoginStatus.h
//  XLMM
//
//  Created by younishijie on 16/2/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMLoginStatus : NSObject

@property (nonatomic, copy) NSString *loginUrl;
@property (nonatomic, readonly) BOOL islogin;


+ (instancetype)shareLoginStatus;


@end

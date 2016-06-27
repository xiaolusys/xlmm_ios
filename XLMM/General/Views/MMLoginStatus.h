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
@property (nonatomic, copy) NSString *userInfoUrl;


@property (nonatomic, strong) NSDictionary *xiaolumm;

@property (nonatomic, readonly) BOOL islogin;
@property (nonatomic, readonly) BOOL isxlmm;

+ (instancetype)shareLoginStatus;


@end

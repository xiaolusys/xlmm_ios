//
//  MMLoginStatus.m
//  XLMM
//
//  Created by younishijie on 16/2/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MMLoginStatus.h"

@implementation MMLoginStatus

static  MMLoginStatus *_instance = nil;

+ (instancetype)shareLoginStatus{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    }) ;
    
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _loginUrl = [NSString stringWithFormat:@""];
    }
    return self;
}

- (BOOL)islogin{
    
    return YES;
}


@end

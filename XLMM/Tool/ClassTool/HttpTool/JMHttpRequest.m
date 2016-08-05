//
//  JMHttpRequest.m
//  XLMM
//
//  Created by zhang on 16/8/2.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHttpRequest.h"
#import "MMClass.h"

@implementation JMHttpRequest

+ (instancetype)sharedManager {
    static JMHttpRequest * httpRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpRequest = [[JMHttpRequest alloc] init];
    });
    return httpRequest;
}

+ (void)createGETRequest:(NSString *)URLString WithParaments:(id)paraments
            withSuccess:(void (^)(id))success
            Failure:(void (^)(NSError *))failure
            showProgress:(void(^)(float progress))progress {
    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
    NSString *userAgent = [defaulte objectForKey:kUserAgent];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager GET:URLString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
       
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)createPOSTRequest:(NSString *)URLString WithParaments:(id)paraments
             withSuccess:(void (^)(id))success
             Failure:(void (^)(NSError *))failure
             showProgress:(void(^)(float progress))progress {
    NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
    NSString *userAgent = [defaulte objectForKey:kUserAgent];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager POST:URLString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}


@end







































































































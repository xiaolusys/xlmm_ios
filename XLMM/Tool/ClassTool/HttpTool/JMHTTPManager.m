//
//  JMHTTPManager.m
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHTTPManager.h"
#import "MMClass.h"

@implementation JMHTTPManager

+ (instancetype)shareManager {
    static JMHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    return manager;
}


- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        
        NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
        NSString *userAgent = [defaulte objectForKey:kUserAgent];
        if (userAgent.length != 0) {
            [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        }
        
        
    }
    return self;
}

+ (void)requestWithType:(HttpRequestType)type WithURLString:(NSString *)urlString WithParaments:(id)paraments WithSuccess:(requestSuccess)success WithFail:(requestFail)fail Progress:(downloadProgress)progress {
    
    switch (type) {
        case RequestTypeGET: {
            [[JMHTTPManager shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (fail) {
                    fail(error);
                }
            }];
            break;
        }
        case RequestTypePOST: {
            [[JMHTTPManager shareManager] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (fail) {
                    fail(error);
                }
            }];
            break;
        }
        case RequestTypeDELETE: {
            [[JMHTTPManager shareManager] DELETE:urlString parameters:paraments success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (fail) {
                    fail(error);
                }
            }];
            break;
        }
        case RequestTypePUT: {
            
            break;
        }
    }
    
}






@end













































































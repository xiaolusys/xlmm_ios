//
//  JMHTTPManager.m
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHTTPManager.h"

@implementation JMHTTPManager

+ (instancetype)shareManager {
    static JMHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
        manager.requestSerializer.timeoutInterval = 10.;
    });
    return manager;
}


- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
//        NSUserDefaults *defaulte = [NSUserDefaults standardUserDefaults];
//        NSString *userAgent = [defaulte objectForKey:kUserAgent];
//        if (userAgent.length != 0) {
//            [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//        }
    }
    return self;
}

+ (void)requestWithType:(HttpRequestType)type WithURLString:(NSString *)urlString WithParaments:(id)paraments WithSuccess:(requestSuccess)success WithFail:(requestFail)fail Progress:(downloadProgress)progress {
    if ([NSString isStringEmpty:urlString]) {
        return ;
    }
    switch (type) {
        case RequestTypeGET: {
            [[JMHTTPManager shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                //通讯协议状态码
//                NSInteger statusCode = response.statusCode;
//                //服务器返回的错误信息
////                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
//                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil];
//                [MBProgressHUD showError:dictionary[@"detail"]];
                
                
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
            [[JMHTTPManager shareManager] PUT:urlString parameters:paraments success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        case RequestTypePATCH: {
            [[JMHTTPManager shareManager] PATCH:urlString parameters:paraments success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    }
    
}






@end













































































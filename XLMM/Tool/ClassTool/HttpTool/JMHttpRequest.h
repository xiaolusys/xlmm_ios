//
//  JMHttpRequest.h
//  XLMM
//
//  Created by zhang on 16/8/2.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface JMHttpRequest : NSObject



+ (instancetype)sharedManager;

/**
 *  GET请求
 *
 *  @param URLString 服务器提供的接口
 *  @param paraments 传的参数
 *  @param success   请求完成
 *  @param failure   请求失败
 *  @param progress  界面上显示的网络加载进度状态(nil为不显示)
 */
+ (void)createGETRequest:(NSString *)URLString
           WithParaments:(id)paraments
           withSuccess:(void (^)(id responseObject))success
           Failure:(void(^)(NSError *error))failure
           showProgress:(void(^)(float progressValue))progress;

/**
 *  POST请求
 *
 *  @param URLString 服务器提供的接口
 *  @param paraments 传的参数
 *  @param success   请求完成
 *  @param failure   请求失败
 *  @param progress  界面上显示的网络加载进度状态(nil为不显示)
 */
+ (void)createPOSTRequest:(NSString *)URLString
           WithParaments:(id)paraments
             withSuccess:(void (^)(id responseObject))success
                 Failure:(void(^)(NSError *error))failure
            showProgress:(void(^)(float progressValue))progress;







@end






































































































































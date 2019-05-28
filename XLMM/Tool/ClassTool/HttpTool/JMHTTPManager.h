//
//  JMHTTPManager.h
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef NS_ENUM(NSUInteger,HttpRequestType) {
    RequestTypeGET = 0,           //  GET请求
    RequestTypePOST,              //  POST请求
    RequestTypeDELETE,            //  DELETE请求
    RequestTypePUT,                //  PUT请求
    RequestTypePATCH              //  PATCH请求
};


/**
 *  成功的回调
 */
typedef void (^requestSuccess)(id responseObject);
/**
 *  失败的回调
 */
typedef void (^requestFail)(NSError *error);
/**
 *  上传的回调
 */
typedef void (^uploadProgress)(float progress);
/**
 *  下载的回调
 */
typedef void (^downloadProgress)(float progress);




@interface JMHTTPManager : AFHTTPSessionManager

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;


/**
 *  网络请求
 *
 *  @param type      网络请求类型
 *  @param urlString 请求的接口
 *  @param paraments 请求的参数
 *  @param success   请求成功
 *  @param fail      请求失败
 *  @param progress  进度
 */
+ (void)requestWithType:(HttpRequestType)type WithURLString:(NSString *)urlString WithParaments:(id)paraments WithSuccess:(requestSuccess)success WithFail:(requestFail)fail Progress:(downloadProgress)progress;






@end


































































































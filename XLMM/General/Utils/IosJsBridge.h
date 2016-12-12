//
//  IosJsBridge.h
//  XLMM
//
//  Created by wulei on 6/16/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DeviceBlock)(NSString *uuid);

@interface IosJsBridge : NSObject


@property (nonatomic, copy) DeviceBlock deviceBlock;

+ (void)dispatchJsBridgeFunc:(UIViewController *)vc name:(NSString *)name para:(NSString*)para;
+ (NSString *)getMobileSNCode;

+ (void)jumpToNativeLocation:(UIViewController *)vc para:(NSDictionary *)data;

// 分享model
+ (void) universeShare:(UIViewController *)vc para:(NSDictionary *)data;

/**
 *   统一的分享接口，注意这个jsbridge实现逻辑错误，需要重新按照接口文档的参数来重写此函数。
 */
+ (void)callNativeUniShareFunc:(UIViewController *)vc para:(NSDictionary *)data;
/**
 *   进入购物车  -- 判断是否登录
 */
+ (void)jumpToNativeLogin:(UIViewController *)vc para:(NSDictionary *)data;

+ (void)getNativeMobileSNCode;

/**
 *  返回按钮
 */
+ (void)callNativeBack:(UIViewController *)vc;

/**
 *  老的分享接口，带活动id
 */
+ (void)callNativeShareFunc:(UIViewController *)vc para:(NSDictionary *)data;

/**
 *  详情界面加载
 */
+ (void)showLoading:(NSDictionary *)data;
@end

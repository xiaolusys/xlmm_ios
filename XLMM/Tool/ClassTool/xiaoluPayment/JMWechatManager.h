//
//  JMWechatManager.h
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//
//typedef NS_ENUM(NSInteger, payErrorCode) {
//    payErrorCodeSuccess        = 0,         // -- > 成功
//    payErrorCodeCommon         = -1,        // -- > 普通错误
//    payErrorCodeCancel         = -2,        // -- > 取消
//    payErrorCodeSentFail       = -3,        // -- > 发送失败
//    payErrorCodeAuthDeny       = -4,        // -- > 授权失败
//    payErrorCodeUnsupport      = -5         // -- > 微信不支持
//    
//};
//
//@class JMWechatManager;
//
//typedef void(^wechatErrorBlock)(NSInteger errorCode);

@interface JMWechatManager : NSObject <WXApiDelegate>

//@property (nonatomic, copy) wechatErrorBlock errorBlock;



+ (instancetype)wechatManager;




@end

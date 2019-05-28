//
//  JMPayment.h
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>


typedef NS_ENUM(NSInteger, thirdPartyPayMentType) {
    thirdPartyPayMentTypeForWechat,
    thirdPartyPayMentTypeForAliPay
};
typedef NS_ENUM(NSInteger, payMentErrorStatus) {
    payMentErrorStatusSuccess       = 0,    // == > 成功
    payMentErrorStatusFail          = 1,    // == > 取消
    payMentErrorStatusCommon        = 2     // == > 失败
};

/* -- > 支付宝错误回调码
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
//WXSuccess           = 0,    /**< 成功    */
//WXErrCodeCommon     = -1,   *< 普通错误类型
//WXErrCodeUserCancel = -2,   *< 用户点击取消并返回
//WXErrCodeSentFail   = -3,   *< 发送失败
//WXErrCodeAuthDeny   = -4,   *< 授权失败
//WXErrCodeUnsupport  = -5,   *< 微信不支持
//};



@interface JMPayError : NSObject

@property (nonatomic, assign) payMentErrorStatus errorStatus;

+ (instancetype)payErrorManager;

@end


typedef void(^payMentErrorBlock)(JMPayError *error);

@interface JMPayment : NSObject <WXApiDelegate>





//@property (nonatomic, assign) thirdPartyPayMentType payMentType;
@property (nonatomic, copy) payMentErrorBlock errorCodeBlock;

+ (instancetype)payMentManager;



/**
 *  支付调用接口
 *
 *  @param payMentType      第三方支付类型. 这里不需要(可以根据后台返回的支付类型判断)
 *  @param parame           Charge 对象(JSON 格式字符串 或 NSDictionary)
 *  @param scheme           URL Scheme，支付宝渠道回调需要
 *  @param errorCodeBlock   支付结果回调 Block
 */
+ (void)createPaymentWithType:(thirdPartyPayMentType)payMentType Parame:(id)parame URLScheme:(NSString *)scheme ErrorCodeBlock:(payMentErrorBlock)errorCodeBlock;
/**
 *  回调结果接口(支付宝/微信/测试模式)
 *
 *  @param url              结果url
 *  @param completionBlock  支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 *
 *  @return                 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)url WithErrorCodeBlock:(payMentErrorBlock)errorCodeBlock;




+ (void)sendVideoURL:(NSString *)videoUrl Title:(NSString *)title DescTitle:(NSString *)descTitle ThumbImage:(UIImage *)thumbImage InScene:(enum WXScene)scene;






































@end



















































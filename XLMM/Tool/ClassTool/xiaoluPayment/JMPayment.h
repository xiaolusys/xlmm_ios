//
//  JMPayment.h
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "JMWechatManager.h"


typedef NS_ENUM(NSInteger, thirdPartyPayMentType) {
    thirdPartyPayMentTypeForWechat,
    thirdPartyPayMentTypeForAliPay
};

@interface JMPayError : NSObject
@end


typedef void(^payMentErrorBlock)(int errorCode);

@interface JMPayment : NSObject <WXApiDelegate>

//@property (nonatomic, assign) thirdPartyPayMentType payMentType;
@property (nonatomic, copy) payMentErrorBlock errorCodeBlock;

+ (instancetype)payMentManager;


+ (void)createPaymentWithType:(thirdPartyPayMentType)payMentType Parame:(id)parame URLScheme:(NSString *)scheme;



@end



















































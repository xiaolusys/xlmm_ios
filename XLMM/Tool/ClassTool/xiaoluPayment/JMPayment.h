//
//  JMPayment.h
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, thirdPartyPayMentType) {
    thirdPartyPayMentTypeForWechat,
    thirdPartyPayMentTypeForAliPay
};





@interface JMPayment : NSObject

//@property (nonatomic, assign) thirdPartyPayMentType payMentType;


+ (instancetype)payMentManager;


//+ (void)createPaymentWithType:(thirdPartyPayMentType)payMentType URLScheme:(NSString *)scheme



@end

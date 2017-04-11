//
//  JMVerificationCodeController.h
//  XLMM
//
//  Created by zhang on 17/3/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMInpotBoxBaseController.h"

typedef NS_ENUM(NSInteger, SMSVerificationCodeTpye) {
    SMSVerificationCodeWithLogin = 0,    // 短信登录
    SMSVerificationCodeWithRegistered,   // 注册新用户
    SMSVerificationCodeWithBind,         // 微信登录用户绑定手机号
    SMSVerificationCodeWithChangePWD,    // 修改密码
    SMSVerificationCodeWithForgetPWD,    // 忘记密码
};


@interface JMVerificationCodeController : JMInpotBoxBaseController

/// 短信验证码类型
@property (nonatomic, assign) SMSVerificationCodeTpye verificationCodeType;

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSDictionary *profileUserInfo;

// 提示用户不是小鹿妈妈.YES -> 不用处理滑动验证的情况
@property (nonatomic, assign) BOOL userNotXLMM;
@property (nonatomic, assign) BOOL userLoginMethodWithWechat;


@end

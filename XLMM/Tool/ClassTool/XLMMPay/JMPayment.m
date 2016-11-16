//
//  JMPayment.m
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayment.h"


@implementation JMPayError
+ (instancetype)payErrorManager {
    static JMPayError *error = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        error = [[JMPayError alloc] init];
    });
    return error;
}
@end


@interface JMPayment ()

@property (nonatomic ,copy) NSString *wxCode;
@property (nonatomic ,copy) NSString *access_token;
@property (nonatomic ,copy) NSString *openid;
@property (nonatomic, strong) NSDictionary *tokenInfo;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation JMPayment


+ (instancetype)payMentManager {
    static JMPayment *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JMPayment alloc] init];
    });
    return manager;
}


+ (void)createPaymentWithType:(thirdPartyPayMentType)payMentType Parame:(id)parame URLScheme:(NSString *)scheme ErrorCodeBlock:(payMentErrorBlock)errorCodeBlock {
    NSString *payType = parame[@"channel"];
    NSDictionary *credentialDic = parame[@"credential"];
    if ([payType isEqual:@"wx"]) {
        NSDictionary *wxDic = credentialDic[@"wx"];
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = wxDic[@"partnerId"];
        req.prepayId  = wxDic[@"prepayId"];
        req.nonceStr  = wxDic[@"nonceStr"];
        req.timeStamp = [wxDic[@"timeStamp"] intValue];
        req.package   = wxDic[@"packageValue"];
        req.sign      = wxDic[@"sign"];
        [WXApi sendReq:req];

        [JMPayment payMentManager].errorCodeBlock = errorCodeBlock;
        
    }else if ([payType isEqual:@"alipay"]) {
        
        NSDictionary *aliDic = credentialDic[@"alipay"];
        NSString *orderString = aliDic[@"orderInfo"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:kUrlScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            NSInteger errorCode = [resultDic[@"resultStatus"] integerValue];
            JMPayError *error = [[JMPayError alloc] init];
            if (errorCode == 9000) {
                error.errorStatus = payMentErrorStatusSuccess;
            }else {  // 4000 (支付失败)
                error.errorStatus = payMentErrorStatusFail;
            }
            if (errorCodeBlock) {
                errorCodeBlock(error);
            }
            /*
             {
             memo = "";
             result = "";
             resultStatus = 6001;
             }

             */
        }];
//        [[AlipaySDK defaultService] payUrlOrder:orderString fromScheme:kUrlScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"%@",resultDic);
            /*
             {
             isProcessUrlPay = 1;
             resultCode = 6001;
             returnUrl = "";
             }
             */
            
            
//        }];
    }else { }
    
}
+ (BOOL)handleOpenURL:(NSURL *)url WithErrorCodeBlock:(payMentErrorBlock)errorCodeBlock {
    /*
        微信跳转判断方法 .. kUrlScheme 根据scheme跳转.支付宝使用的scheme和微信相同.所以这里判断url.host .. : 如果不想使用这种方法,就单独为支付宝跳转设置一个scheme
        [[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",kUrlScheme]].location != NSNotFound
     */
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"]) {
        return  [WXApi handleOpenURL:url delegate:[JMPayment payMentManager]];
    }else if ([url.host isEqual:@"safepay"]) {
        //由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger errorCode = [resultDic[@"resultStatus"] integerValue];
            JMPayError *error = [[JMPayError alloc] init];
            if (errorCode == 9000) {
                error.errorStatus = payMentErrorStatusSuccess;
            }else {
                error.errorStatus = payMentErrorStatusFail;
            }
            /*
             if (errorCode == 6001) {
             error.errorStatus = payMentErrorStatusCancel;
             }else {  // 4000 (支付失败)
             error.errorStatus = payMentErrorStatusCommon;
             }
             */
            if (errorCodeBlock) {
                errorCodeBlock(error);
            }
        }];
        return YES;
    }else {
        return NO;
    }
//    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"pay"]) {
//        
//    }
}


- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]) {
//        int errorCode = resp.errCode;
        JMPayError *error = [[JMPayError alloc] init];
//        NSInteger errorStatus;
        if (resp.errCode == 0) {
            error.errorStatus = payMentErrorStatusSuccess;
        }else {
            error.errorStatus = payMentErrorStatusFail;
        }
        if ([JMPayment payMentManager].errorCodeBlock) {
            [JMPayment payMentManager].errorCodeBlock(error);
        }
//        switch (resp.errCode) {
//            case WXSuccess:
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhifuSeccessfully" object:nil];
//                break;
//                
//            default:{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CancleZhifu" object:nil];
//            }
//                
//                break;
//        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {
        //[SVProgressHUD showInfoWithStatus:@"登录中....."];
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            self.wxCode = code;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:code forKey:@"wxCode"];
            [userDefaults synchronize];
        }else {
            NSLog(@"取消登录");
            return;
        }
        //获取token和openid；
        [self getAccess_token];
    }else { }
    
    
    
}





-(void)getAccess_token
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx25fcb32689872499",@"3c7b4e3eb5ae4cfb132b2ac060a872ee",self.wxCode];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.tokenInfo = dic;
                
                NSLog(@"dic = %@", dic);
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                
                [self getUserInfo];
                //传入openID and
            }
            
        });
    });
}



-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,self.openid];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dic2 = %@", dic);
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                self.userInfo = dic;
                //                NSLog(@"tokeninfo = %@", self.tokenInfo);
                //                NSLog(@"userInfo = %@", self.userInfo);
                
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:self.userInfo forKey:@"userInfo"];
                [userdefault setBool:YES forKey:kIsLogin];
                [userdefault setObject:kWeiXinLogin forKey:kLoginMethod];
                NSDictionary *wxUserInfo = @{@"nickname":[dic objectForKey:@"nickname"],
                                             @"headimgurl":[dic objectForKey:@"headimgurl"]
                                             };
                [userdefault setObject:wxUserInfo forKey:kWeiXinUserInfo];
                [userdefault synchronize];
                
                //                NSLog(@"name = %@", [dic objectForKey:@"nickname"]);
                //  发送微信登录成功的通知
                
                NSUserDefaults *userdefault0 = [NSUserDefaults standardUserDefaults];
                NSString *author = [userdefault0 objectForKey:kWeiXinauthorize];
                
                if ([author isEqualToString:@"wxlogin"]) {
                    
                    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"login" object:self];
                    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                    [notificationCenter postNotification: broadcastMessage];
                } else if([author isEqualToString:@"binding"]){
                    NSNotification * broadcastMessage = [ NSNotification notificationWithName:@"bindingwx" object:self];
                    NSNotificationCenter * notificationCenter = [ NSNotificationCenter defaultCenter];
                    [notificationCenter postNotification: broadcastMessage];
                }
                
            }
        });
        
    });
}



@end


/*
 (lldb) po chargeDic
 {
 amount = 15790;
 "amount_refunded" = 0;
 "amount_settle" = 15790;
 app = "app_LOOajDn9u9WDjfHa";
 body = "\U7528\U6237\U8ba2\U5355\U91d1\U989d[1, 499989, 157.90]";
 channel = wx;
 "client_ip" = "180.97.163.149";
 created = 1478931975;
 credential =     {
 object = credential;
 wx =         {
 appId = wx25fcb32689872499;
 nonceStr = 7cfcb4f4b12ad3716341d9f0684d5add;
 packageValue = "Sign=WXPay";
 partnerId = 1268398601;
 prepayId = wx2016111214261632f531258e0932157650;
 sign = 3893524DA1B79C25E678C8EB9501D023;
 timeStamp = 1478931976;
 };
 };
 currency = cny;
 description = "<null>";
 extra =     {
 };
 "failure_code" = "<null>";
 "failure_msg" = "<null>";
 id = "ch_inTir554CWj9rz1SWPfXjzXP";
 livemode = 1;
 metadata =     {
 color = red;
 };
 object = charge;
 "order_no" = xd1611125826b5ff8dcee;
 paid = 0;
 refunded = 0;
 refunds =     {
 data =         (
 );
 "has_more" = 0;
 object = list;
 url = "/v1/charges/ch_inTir554CWj9rz1SWPfXjzXP/refunds";
 };
 subject = "\U5c0f\U9e7f\U7f8e\U7f8e\U5e73\U53f0\U4ea4\U6613";
 "time_expire" = 1478939175;
 "time_paid" = "<null>";
 "time_settle" = "<null>";
 "transaction_no" = "<null>";
 }

 */



/*
 (lldb) po parame
 {
 amount = 18650;
 "amount_refunded" = 0;
 "amount_settle" = 18650;
 app = "app_LOOajDn9u9WDjfHa";
 body = "\U7528\U6237\U8ba2\U5355\U91d1\U989d[863991, 503116, 186.50]";
 channel = alipay;
 "client_ip" = "180.97.163.149";
 created = 1479179755;
 credential =     {
 alipay =         {
 orderInfo = "service=\"mobile.securitypay.pay\"&_input_charset=\"utf-8\"&notify_url=\"https%3A%2F%2Fnotify.pingxx.com%2Fnotify%2Fcharges%2Fch_nDebPSCGKm18Om9OGGOCyXfP\"&partner=\"2088911223385116\"&out_trade_no=\"xd161115582a7b9ee6404\"&subject=\"\U5c0f\U9e7f\U7f8e\U7f8e\U5e73\U53f0\U4ea4\U6613\"&body=\"\U7528\U6237\U8ba2\U5355\U91d1\U989d[863991, 503116, 186.50]\"&total_fee=\"186.50\"&payment_type=\"1\"&seller_id=\"2088911223385116\"&it_b_pay=\"2016-11-16 11:15:55\"&sign=\"CT347b9ayyikBufWIP5NhaxBS6%2BqsvcT2andhcCz%2F0Xc%2FKNTHb%2By5oTAdxE8sR434RsYtwMDHgdhoLtvWE1awlQCbg7yE8AloC2%2FmDujAZ4Ss%2BjRT2vMigSi3gaJdS0gZcsJjLhwCw34CFY2dF%2FThsxIZOklfOLyz1gGJLUj3oE%3D\"&sign_type=\"RSA\"";
 };
 object = credential;
 };
 currency = cny;
 description = "<null>";
 extra =     {
 };
 "failure_code" = "<null>";
 "failure_msg" = "<null>";
 id = "ch_nDebPSCGKm18Om9OGGOCyXfP";
 livemode = 1;
 metadata =     {
 color = red;
 };
 object = charge;
 "order_no" = xd161115582a7b9ee6404;
 paid = 0;
 refunded = 0;
 refunds =     {
 data =         (
 );
 "has_more" = 0;
 object = list;
 url = "/v1/charges/ch_nDebPSCGKm18Om9OGGOCyXfP/refunds";
 };
 subject = "\U5c0f\U9e7f\U7f8e\U7f8e\U5e73\U53f0\U4ea4\U6613";
 "time_expire" = 1479266155;
 "time_paid" = "<null>";
 "time_settle" = "<null>";
 "transaction_no" = "<null>";
 }
 

 */






























































































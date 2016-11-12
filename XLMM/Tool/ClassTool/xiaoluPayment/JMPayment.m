//
//  JMPayment.m
//  XLMM
//
//  Created by zhang on 16/11/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayment.h"


@implementation JMPayError
@end




@implementation JMPayment


+ (instancetype)payMentManager {
    static JMPayment *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    return manager;
}


+ (void)createPaymentWithType:(thirdPartyPayMentType)payMentType Parame:(id)parame URLScheme:(NSString *)scheme PayMentComplection:(payMentBlock)complection {
    switch (payMentType) {
        case thirdPartyPayMentTypeForWechat: {
            /*
             *  微信支付调用方法
             *
             *  @param prepay_id 后台提供的prepay_id
             *  @param nonce_str 后台提供的nonce_str
             
             
             */
            NSDictionary *credentialDic = parame[@"credential"];
            NSDictionary *wxDic = credentialDic[@"wx"];
            NSString *parepayID = wxDic[@"partnerId"];
            NSString *nonceStr = wxDic[@"nonceStr"];
            
            
            
            
            
            
            
            
            
        }
            break;
        
        
        
        case thirdPartyPayMentTypeForAliPay: {
            /**
             *  支付宝支付调用方法
             *
             *  @param orderId    订单id（一般是后台生成之后返给你，你把这个id填到这里）
             *  @param totalMoney 钱数
             *  @param payTitle   支付页面的标题（说白了就是让客户知道这是花得什么钱，买了什么）
             */
            
            
        }
            break;
        default:
            break;
    }
    


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


































































































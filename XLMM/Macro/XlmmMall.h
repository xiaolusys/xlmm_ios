//
//  XlmmMall.h
//  XLMM
//
//  Created by wulei on 4/25/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#ifndef XlmmMall_h
#define XlmmMall_h


#define TYPE_JUMP_CHILD  1
#define TYPE_JUMP_WOMAN  2

#define ORDER_STATUS_CREATE  0
#define ORDER_STATUS_WAITPAY  1
#define ORDER_STATUS_PAYED  2
#define ORDER_STATUS_SENDED  3
#define ORDER_STATUS_CONFIRM_RECEIVE  4
#define ORDER_STATUS_TRADE_SUCCESS  5
#define ORDER_STATUS_REFUND_CLOSE  6
#define ORDER_STATUS_TRADE_CLOSE  7

#define REFUND_STATUS_NO_REFUND  0
#define REFUND_STATUS_BUYER_APPLY  3
#define REFUND_STATUS_SELLER_AGREED  4
#define REFUND_STATUS_BUYER_RETURNED_GOODS  5
#define REFUND_STATUS_REFUND_CLOSE  1
#define REFUND_STATUS_SELLER_REJECTED  2
#define REFUND_STATUS_WAIT_RETURN_FEE  6
#define REFUND_STATUS_REFUND_SUCCESS 7




// url
#define kTODAY_POSTERS_URL [NSString stringWithFormat:@"%@/rest/v1/posters/today.json",Root_URL]
#define kPREVIOUS_POSTERS_URL [NSString stringWithFormat:@"%@/rest/v1/posters/previous.json",Root_URL]
#define kTODAY_PROMOTE_URL [NSString stringWithFormat:@"%@/rest/v1/products/promote_today.json",Root_URL]
#define kPREVIOUS_PROMOTE_URL [NSString stringWithFormat:@"%@/rest/v1/products/promote_previous.json",Root_URL]
#define kCHILD_LIST_URL [NSString stringWithFormat:@"%@/rest/v1/products/childlist?page_size=10",Root_URL]
#define kLADY_LIST_URL [NSString stringWithFormat:@"%@/rest/v1/products/ladylist?page_size=10",Root_URL]
#define kLOGIN_URL [NSString stringWithFormat:@"%@/rest/v1/register/customer_login",Root_URL]
#define kModel_List_URL [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json",Root_URL]
#define kCart_URL [NSString stringWithFormat:@"%@/rest/v2/carts.json",Root_URL]
#define kCHILD_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/childlist?order_by=price&page_size=10",Root_URL]
#define kLADY_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/ladylist?order_by=price&page_size=10",Root_URL]
#define kCart_History_URL [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_history.json",Root_URL]
#define kCart_Number_URL [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json",Root_URL]
#define kAddress_List_URL [NSString stringWithFormat:@"%@/rest/v1/address.json",Root_URL]
#define kQuanbuDingdan_URL [NSString stringWithFormat:@"%@/rest/v2/trades.json",Root_URL]
#define kWaitpay_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitpay.json",Root_URL]
#define kWaitsend_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitsend.json",Root_URL]
#define kIntegrallogURL [NSString stringWithFormat:@"%@/rest/v1/integrallog.json",Root_URL]
#define kRefunds_URL [NSString stringWithFormat:@"%@/rest/v1/refunds.json",Root_URL]
#define KUserCoupins_URL [NSString stringWithFormat:@"%@/rest/v1/usercoupons.json",Root_URL]

//新的注册登录验证码接口/ j
#define TPasswordLogin_URL [NSString stringWithFormat:@"%@/rest/v2/passwordlogin",Root_URL]
#define TSendCode_URL [NSString stringWithFormat:@"%@/rest/v2/send_code",Root_URL]
#define TVerifyCode_URL [NSString stringWithFormat:@"%@/rest/v2/verify_code",Root_URL]
#define TResetPwd_URL [NSString stringWithFormat:@"%@/rest/v2/reset_password",Root_URL]

//加载的webView链接
#define ABOUTFANS_URL [NSString stringWithFormat:@"%@/pages/fans-explain.html",Root_URL]
#define COMMONPROBLEM_URL [NSString stringWithFormat:@"%@/mall/faq", Root_URL] //http://m.xiaolumeimei.com/mall/faq
#define HISTORYCOMMONPROBLEM_URL [NSString stringWithFormat:@"%@/mall/complaint/history", Root_URL]
#define LOGINFORAPP_URL [NSString stringWithFormat:@"%@/sale/promotion/activity/", Root_URL]

#define UPDATE_URLSTRING [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",@"1051166985"]


#endif /* XlmmMall_h */

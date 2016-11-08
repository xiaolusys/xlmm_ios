//
//  MMClass.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "UIColor+RGBColor.h"
#import "UIImage+ImageWithUrl.h"
#import "NSArray+Log.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <Masonry.h>
#import "UIViewController+NavigationBar.h"
#import "NSString+URL.h"
#import <MJRefresh.h>
#import "JMHTTPManager.h"
#import "MBProgressHUD+JMHUD.h"
#import "UMMobClick/MobClick.h"
#import "NSString+CSCommon.h"
#import "MJAnimationHeader.h"
#import "JMGlobal.h"




//#import "NSDictionary+Log.h"


#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif

#ifdef DEBUG
#define JMString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define NSLog(...) printf("%s -> [ %s ] 第%d行: %s\n\n",[[NSString jm_stringDate] UTF8String],[JMString UTF8String],__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define NSLog(...)
#endif


#define JMKeyWindow [UIApplication sharedApplication].keyWindow
/**
 *  循环引用
 */
#define kWeakSelf __weak typeof (self) weakSelf = self;
// 当前版本
#define FSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SSystemVersion ([[UIDevice currentDevice] systemVersion])
// 当前语言
#define CURRENTLANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])
// 获得屏幕宽高
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
// ios7之上的系统
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
// ios8之上的系统
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define kUrlScheme @"wx25fcb32689872499" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#define kVisitorDay @14      // 加载访客记录(天数)
#define KTITLENAME @"小鹿美美"
#define PERSONCENTER(a) [self.navigationController pushViewController:[[a alloc] init] animated:YES]
#define LOADIMAGE(a) [UIImage imageNamed:a]
#define kLoansRRL(a) [NSURL URLWithString:a]
#define MMLOG(a) NSLog(@"%@ = %@", [a class], a)
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define NumberOfCart @"NumberOfCart"
#define kIsLogin @"login"
#define kUserName @"userName"
#define kPassWord @"password"
#define kPhoneLogin @"phonelogin"
#define kLoginMethod @"loginMethod"
#define kWeiXinLogin @"weixinlogin"
#define kAppLoadNum @"kAppLoadNum"

#define kWeiXinauthorize @"kWeiXinauthorize"
#define kPhoneNumberUserInfo @"phoneUserInfo"
#define kWeiXinUserInfo @"weixinUserInfo"
#define kIsReceivePushTZ @"isReceivePush"

#define kISXLMM @"isXLMM"

#define kUserAgent @"userAgent"

#define LOGINDEVTYPE @"ios"



//#define Root_URL @"http://youni.huyi.so"
//  Root_URL @"http://192.168.1.31:9000"

//  Root_URL @"http://192.168.1.57:8000"
//#define Share_Root_Url @"http://m.xiaolumeimei.com"
//c32f391fw




extern NSString *Root_URL;


@protocol MenuVCPushSideDelegate <NSObject>

- (void)menuVCPushSide;

@end

#pragma mark --URLs--


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

//新的注册登录验证码接口
#define TPasswordLogin_URL [NSString stringWithFormat:@"%@/rest/v2/passwordlogin",Root_URL]
#define TSendCode_URL [NSString stringWithFormat:@"%@/rest/v2/send_code",Root_URL]
#define TVerifyCode_URL [NSString stringWithFormat:@"%@/rest/v2/verify_code",Root_URL]
#define TResetPwd_URL [NSString stringWithFormat:@"%@/rest/v2/reset_password",Root_URL]

//加载的webView链接
#define ABOUTFANS_URL [NSString stringWithFormat:@"%@/pages/fans-explain.html",Root_URL]
#define COMMONPROBLEM_URL [NSString stringWithFormat:@"%@/mall/faq", Root_URL] //http://m.xiaolumeimei.com/mall/faq
#define HISTORYCOMMONPROBLEM_URL [NSString stringWithFormat:@"%@/mall/complaint/history", Root_URL]
#define LOGINFORAPP_URL [NSString stringWithFormat:@"%@/sale/promotion/activity/", Root_URL]

#define UPDATE_URLSTRING [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1051166985"]

#endif





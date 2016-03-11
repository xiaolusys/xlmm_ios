//
//  MMClass.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//
#import "PosterModel.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "UIImageView+WebCache.h"
#import "ChildViewController.h"
#import "CollectionModel.h"
#import "DetailsModel.h"
#import "PeopleModel.h"
#import "UIColor+RGBColor.h"
#import "UIImage+ImageWithUrl.h"
#import "NSArray+Log.h"

//#import "NSDictionary+Log.h"


#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
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

#define kWeiXinauthorize @"kWeiXinauthorize"
#define kPhoneNumberUserInfo @"phoneUserInfo"
#define kWeiXinUserInfo @"weixinUserInfo"

//#define Root_URL @"http://youni.huyi.so"
//  Root_URL @"http://192.168.1.31:9000"

//  Root_URL @"http://192.168.1.57:8000"
//#define Share_Root_Url @"http://m.xiaolumeimei.com"


#if 1
//#define Root_URL @"http://192.168.1.31:9000"
#define Root_URL @"http://dev.xiaolumeimei.com:8000"
#else


#define Root_URL @"http://m.xiaolumeimei.com"

#endif

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
#define kCart_URL [NSString stringWithFormat:@"%@/rest/v1/carts.json",Root_URL]
#define kCHILD_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/childlist?order_by=price",Root_URL]
#define kLADY_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/ladylist?order_by=price",Root_URL]
#define kCart_History_URL [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_history.json",Root_URL]
#define kCart_Number_URL [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num.json",Root_URL]
#define kAddress_List_URL [NSString stringWithFormat:@"%@/rest/v1/address.json",Root_URL]
#define kQuanbuDingdan_URL [NSString stringWithFormat:@"%@/rest/v1/trades.json",Root_URL]
#define kWaitpay_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitpay.json",Root_URL]
#define kWaitsend_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitsend.json",Root_URL]
#define kIntegrallogURL [NSString stringWithFormat:@"%@/rest/v1/integrallog.json",Root_URL]
#define kRefunds_URL [NSString stringWithFormat:@"%@/rest/v1/refunds.json",Root_URL]
#define KUserCoupins_URL [NSString stringWithFormat:@"%@/rest/v1/usercoupons.json",Root_URL]



#endif





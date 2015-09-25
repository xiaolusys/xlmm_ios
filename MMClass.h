//
//  MMClass.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//
#import "PosterView.h"
#import "GoodsView.h"
#import "LadyView.h"
#import "PosterModel.h"

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "UIImageView+WebCache.h"
#import "ChildViewController.h"
#import "PersonCenterViewController.h"
#import "DetailViewController.h"
#import "PurchaseViewController.h"
#import "CollectionModel.h"
#import "DetailsModel.h"
#import "PeopleModel.h"
#import "UIColor+RGBColor.h"
#import "UIImage+ImageWithUrl.h"

#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

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

//#define Root_URL @"http://192.168.1.61:8000"
//#define Root_URL @"http://youni.huyi.so"


#define Root_URL @"http://m.xiaolu.so"

#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"

@protocol MenuVCPushSideDelegate <NSObject>

- (void)menuVCPushSide;

@end
#pragma mark --URLs--

#define kTODAY_POSTERS_URL [NSString stringWithFormat:@"%@/rest/v1/posters/today.json",Root_URL]
#define kPREVIOUS_POSTERS_URL [NSString stringWithFormat:@"%@/rest/v1/posters/previous.json",Root_URL]
#define kTODAY_PROMOTE_URL [NSString stringWithFormat:@"%@/rest/v1/products/promote_today.json",Root_URL]
#define kPREVIOUS_PROMOTE_URL [NSString stringWithFormat:@"%@/rest/v1/products/promote_previous.json",Root_URL]
#define kCHILD_LIST_URL [NSString stringWithFormat:@"%@/rest/v1/products/childlist",Root_URL]
#define kLADY_LIST_URL [NSString stringWithFormat:@"%@/rest/v1/products/ladylist",Root_URL]
#define kLOGIN_URL [NSString stringWithFormat:@"%@/rest/v1/register/customer_login",Root_URL]
#define kModel_List_URL [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@",Root_URL]
#define kCart_URL [NSString stringWithFormat:@"%@/rest/v1/carts",Root_URL]
#define kCHILD_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/childlist?order_by=price",Root_URL]
#define kLADY_LIST_ORDER_URL [NSString stringWithFormat:@"%@/rest/v1/products/ladylist?order_by=price",Root_URL]
#define kCart_History_URL [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_history",Root_URL]
#define kCart_Number_URL [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num",Root_URL]
#define kAddress_List_URL [NSString stringWithFormat:@"%@/rest/v1/address",Root_URL]
#define kQuanbuDingdan_URL [NSString stringWithFormat:@"%@/rest/v1/trades",Root_URL]
#define kWaitpay_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitpay",Root_URL]
#define kWaitsend_List_URL [NSString stringWithFormat:@"%@/rest/v1/trades/waitsend",Root_URL]
#define kIntegrallogURL [NSString stringWithFormat:@"%@/rest/v1/integrallog",Root_URL]
#define kRefunds_URL [NSString stringWithFormat:@"%@/rest/v1/refunds",Root_URL]
#define KUserCoupins_URL [NSString stringWithFormat:@"%@/rest/v1/usercoupons",Root_URL]

#endif


#if 0
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

NSLog(@"phoneNumber = %@\n", _numberTextField.text);
NSDictionary *parameters = @{@"vmobile": phoneNumber};

[manager POST:@"http://youni.huyi.so/rest/v1/register" parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSLog(@"JSON: %@", responseObject);
     
          
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          NSLog(@"Error: %@", error);
          
      }];

UITouch ;
UIGestureRecognizer  ;
UIPageViewController;

NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);

NSString *plistPath1 = [paths objectAtIndex:0];

NSLog(@"%@", plistPath1);

//得到完整的文件名

NSString *filename=[plistPath1 stringByAppendingPathComponent:@"aera.plist"];

//输入写入

BOOL fl = [addressArray writeToFile:filename atomically:YES]; //写入

NSLog(@"ls = %d", fl);



#endif
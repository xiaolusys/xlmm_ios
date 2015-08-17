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
#import "WomanViewController.h"
#import "PersonCenterViewController.h"
#import "DetailViewController.h"
#import "PurchaseViewController.h"
#import "CollectionModel.h"
#import "CollectionViewController.h"
#import "DetailsModel.h"
#import "PeopleModel.h"
#import "UIColor+RGBColor.h"

#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define KTITLENAME @"小鹿美美"
#define PERSONCENTER(a) [self.navigationController pushViewController:[[a alloc] init] animated:YES]
#define LOADIMAGE(a) [UIImage imageNamed:a]
#define kLoansRRL(a) [NSURL URLWithString:a]
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define NumberOfCart @"NumberOfCart"

#define kIsLogin @"isLogin"
#define kUserName @"userName"
#define kPassWord @"password"

#if 1
#define kTODAY_POSTERS_URL @"http://youni.huyi.so/rest/v1/posters/today"
#define kPREVIOUS_POSTERS_URL @"http://youni.huyi.so/rest/v1/posters/previous"
#define kTODAY_PROMOTE_URL @"http://youni.huyi.so/rest/v1/products/promote_today"
#define kPREVIOUS_PROMOTE_URL @"http://youni.huyi.so/rest/v1/products/promote_previous"
#define kCHILD_LIST_URL @"http://youni.huyi.so/rest/v1/products/childlist"
#define kLADY_LIST_URL @"http://youni.huyi.so/rest/v1/products/ladylist"
#define kLOGIN_URL @"http://youni.huyi.so/rest/v1/register/customer_login"
#define kModel_List_URL @"http://youni.huyi.so/rest/v1/products/modellist/%@"
#define kCart_URL @"http://youni.huyi.so/rest/v1/carts"
#define kCHILD_LIST_ORDER_URL @"http://youni.huyi.so/rest/v1/products/childlist?order_by=price"

#define kCart_Number_URL @"http://youni.huyi.so/rest/v1/carts/show_carts_num"


#endif 


#if 0

#define kTODAY_POSTERS_URL @"http://192.168.1.131:8000/rest/v1/posters/today"
#define kPREVIOUS_POSTERS_URL @"http://192.168.1.131:8000/rest/v1/posters/previous"
#define kTODAY_PROMOTE_URL @"http://192.168.1.131:8000/rest/v1/products/promote_today"
#define kPREVIOUS_PROMOTE_URL @"http://192.168.1.131:8000/rest/v1/products/promote_previous"
#define kCHILD_LIST_URL @"http://192.168.1.131:8000/rest/v1/products/childlist"
#define kLADY_LIST_URL @"http://192.168.1.131:8000/rest/v1/products/ladylist"
#define kLOGIN_URL @"http://192.168.1.131:8000/rest/v1/register/customer_login"
#define kModel_List_URL @"http://192.168.1.131:8000/rest/v1/products/modellist/%@"
#define kCart_URL @"http://192.168.1.131:8000/rest/v1/carts"
#define kCHILD_LIST_ORDER_URL @"http://192.168.1.131:8000/rest/v1/products/childlist?order_by=price"

#define kCart_Number_URL @"http://192.168.1.131:8000/rest/v1/carts/show_carts_num"


#endif



#define MMLOG(a) NSLog(@"%@ = %@", [a class], a)

#endif

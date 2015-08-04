//
//  MMClass.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define KTITLENAME @"小鹿美美"
#define PERSONCENTER(a) [self.navigationController pushViewController:[[a alloc] init] animated:YES]
#define LOADIMAGE(a) [UIImage imageNamed:a]
#define kLoansRRL(a) [NSURL URLWithString:a]
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kIsLogin @"isLogin"
#define kUserName @"userName"
#define kPassWord @"password"

#define kTODAY_POSTERS_URL @"http://youni.huyi.so/rest/v1/posters/today"
#define kPREVIOUS_POSTERS_URL @"http://youni.huyi.so/rest/v1/posters/previous"
#define kTODAY_PROMOTE_URL @"http://youni.huyi.so/rest/v1/products/promote_today"
#define kPREVIOUS_PROMOTE_URL @"http://youni.huyi.so/rest/v1/products/promote_previous"


#define kCHILD_LIST_URL @"http://youni.huyi.so/rest/v1/products/childlist"
#define kLADY_LIST_URL @"http://youni.huyi.so/rest/v1/products/ladylist"

#define MMLOG(a) NSLog(@"%@ = %@", [a class], a)

#endif

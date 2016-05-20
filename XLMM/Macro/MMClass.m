//
//  MMClass.m
//  XLMM
//
//  Created by wulei on 5/10/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "MMClass.h"

#if 0
//#define Root_URL @"http://192.168.1.57:8000"
//#define Root_URL @"http://192.168.1.31:9000"
//#define Root_URL @"http://192.168.1.13:8000"
//#define Root_URL @"http://192.168.1.11:9000"
//#define Root_URL @"http://dev.xiaolumeimei.com"
NSString *Root_URL =  @"http://staging.xiaolumeimei.com";
#else


NSString *Root_URL = @"http://m.xiaolumeimei.com";



//http://m.xiaolumeimei.com/rest/v1/pmt/cashout?page=1

//取消提现的接口
     //http://m.xiaolumeimei.com/rest/v1/pmt/cashout/cancal_cashout


//   http://m.xiaolumeimei.com/rest/v2/mama/activevalue


//妈妈主页接口 http://m.xiaolumeimei.com/rest/v2/mama/fortune


//   http://m.xiaolumeimei.com/rest/v1/activitys/12975/get_share_params

#endif
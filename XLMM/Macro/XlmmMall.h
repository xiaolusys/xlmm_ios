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

#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIColor+RGBColor.h"
#import "UMMobClick/MobClick.h"


#endif /* XlmmMall_h */

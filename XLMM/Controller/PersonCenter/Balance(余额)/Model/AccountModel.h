//
//  AccountModel.h
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject
@property (nonatomic, strong)NSNumber *budget_type;
@property (nonatomic, copy)NSString *budget_log_type;
@property (nonatomic, copy)NSString *budget_date;
@property (nonatomic, copy)NSString *get_status_display;
@property (nonatomic, strong)NSNumber *budeget_detail_cash;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, copy)NSString *status;

@property (nonatomic, assign) CGFloat cellHeight;


@end



/**
 *  {
 "desc":"您通过代理提现至余额收入100.0元.",
 "budget_type":0,
 "budget_log_type":"mmcash",
 "budget_date":"2016-09-20",
 "get_status_display":"已确定",
 "status":0,
 "budeget_detail_cash":100.0
 }
 */


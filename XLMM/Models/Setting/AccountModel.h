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
@property (nonatomic, strong)NSString *budget_log_type;
@property (nonatomic, strong)NSString *budget_date;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, strong)NSNumber *budeget_detail_cash;
@property (nonatomic, strong)NSString *desc;
@end

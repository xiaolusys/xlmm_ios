//
//  CarryLogModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarryLogModel : NSObject

//@property (nonatomic, strong)NSNumber *carryId;
//@property (nonatomic, strong)NSString *carry_type;
//@property (nonatomic, strong)NSNumber *xlmm;
@property (nonatomic, strong)NSNumber *value_money;
//@property (nonatomic, strong)NSString *carry_type_name;
//@property (nonatomic, strong)NSString *log_type_name;
//@property (nonatomic, strong)NSString *carry_date;
@property (nonatomic, strong)NSString *created;


@property (nonatomic, strong)NSNumber *type_count;
@property (nonatomic, strong)NSNumber *sum_value;
@property (nonatomic, strong)NSString *log_type;
@property (nonatomic, strong)NSString *carry_date;

@end

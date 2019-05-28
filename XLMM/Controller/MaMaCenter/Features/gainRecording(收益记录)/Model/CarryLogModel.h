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
//@property (nonatomic, strong)NSString *carry_type;

@property (nonatomic, strong)NSNumber *dayly_in_amount;
@property (nonatomic, strong)NSNumber *dayly_clk_amount;

@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *get_log_type_display;

@property (nonatomic, strong)NSNumber *today_carry;
@property (nonatomic, strong)NSString *carry_type_name;
@property (nonatomic, strong)NSNumber *carry_value;
@property (nonatomic, strong)NSNumber *carry_type;
@property (nonatomic, strong)NSString *carry_description;
@property (nonatomic, strong)NSString *date_field;
@property (nonatomic, strong)NSString *status_display;
@property (nonatomic, strong)NSString *contributor_img;
@property (nonatomic, strong)NSString *contributor_nick;


@end


/*
 {
 "carry_description" = "\U606d\U559c\Uff0c\U53c8\U589e\U52a0\U4e00\U540d\U7c89\U4e1d\Uff01";
 "carry_num" = "0.1";
 "carry_type" = 3;
 "carry_type_name" = "\U5956\U91d1";
 "carry_value" = "0.1";
 created = "2017-03-01T20:14:45";
 "date_field" = "2017-03-01";
 "mama_id" = 1;
 modified = "2017-03-01T20:14:45";
 status = 2;
 "status_display" = "\U786e\U5b9a\U6536\U76ca";
 "today_carry" = "0.1";
 },

 */









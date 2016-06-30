//
//  JMAlreadyChooseModel.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAlreadyChooseModel : NSObject


@property (nonatomic, strong) NSString *agent_price;

@property (nonatomic, strong) NSString *carry_amount;

@property (nonatomic, strong) NSString *created;

@property (nonatomic, strong) NSString *goodsID;

@property (nonatomic, strong) NSString *model;

@property (nonatomic, strong) NSString *modified;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *offshelf_time;

@property (nonatomic, strong) NSString *pic_path;

@property (nonatomic, strong) NSString *position;

@property (nonatomic, strong) NSString *pro_status;

@property (nonatomic, strong) NSString *product;

@property (nonatomic, strong) NSString *sale_num;

@property (nonatomic, strong) NSString *std_sale_price;


@end


/**
 *   results =     (
 {
 "agent_price" = "79.90000000000001";
 "carry_amount" = "15.98";
 created = "2016-06-30T15:39:22";
 id = 68000;
 model = 11804;
 modified = "2016-06-30T15:39:22";
 name = "\U751c\U7f8e\U7eaf\U8272\U7f51\U7eb1\U80a9\U5e26\U8fde\U8863\U88d9/\U9ec4\U8272";
 "offshelf_time" = "2016-05-04T00:00:00";
 "pic_path" = "https://cbu01.alicdn.com/img/ibank/2016/255/833/2911338552_2062850098.400x400.jpg";
 position = 430;
 "pro_status" = 1;
 product = 41349;
 "sale_num" = 2665;
 "std_sale_price" = 399;
 },
 */

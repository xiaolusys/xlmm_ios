//
//  MaMaOrderModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaMaOrderModel : NSObject

@property (nonatomic, strong)NSNumber *linkid;
@property (nonatomic, strong)NSString *linkname;
@property (nonatomic, strong)NSString *wxorderid;
@property (nonatomic, strong)NSString *wxordernick;
@property (nonatomic, strong)NSNumber *order_cash;
@property (nonatomic, strong)NSNumber *rebeta_cash;
@property (nonatomic, strong)NSNumber *ticheng_cash;
@property (nonatomic, strong)NSString *time_display;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, strong)NSString *get_status_display;
@property (nonatomic, strong)NSString *pic_path;
@property (nonatomic, copy) NSString *shoptime;
@property (nonatomic, strong)NSNumber *dayly_amount;


//新接口
@property (nonatomic, strong)NSNumber *carry_num;
@property (nonatomic, strong)NSString *sku_img;
@property (nonatomic, strong)NSNumber *today_carry;
@property (nonatomic, strong)NSString *status_display;
@property (nonatomic, strong)NSString *contributor_nick;
@property (nonatomic, strong)NSString *date_field;
@property (nonatomic, strong)NSString *created;
@property (nonatomic, strong)NSString *carry_type_name;
@property (nonatomic, strong)NSString *carry_type;
@property (nonatomic, strong)NSString *order_value;


@end

//
//  JMPackAgeModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/2.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMPackAgeModel : NSObject
/**
 *  物流状态
 */
@property (nonatomic,copy) NSString *assign_status_display;

@property (nonatomic,copy) NSString *logistics_company_code;

@property (nonatomic,copy) NSString *logistics_company_name;

@property (nonatomic,copy) NSString *num;

@property (nonatomic,copy) NSString *out_sid;

@property (nonatomic,copy) NSString *package_group_key;

@property (nonatomic,copy) NSString *payment;

@property (nonatomic,copy) NSString *pic_path;
/**
 *  时间
 */
@property (nonatomic,copy) NSString *process_time;
/**
 *  商品标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  仓库编号
 */
@property (nonatomic,copy) NSString *ware_by_display;

@end

/*
 <__NSCFArray 0x146976270>(
 
 {
 
 "assign_status_display" = "\U5df2\U53d6\U6d88”;         状态 === > 已取消
 
 "logistics_company_code" = "";
 
 "logistics_company_name" = "";
 
 num = 1;
 
 "out_sid" = "";
 
 " " = "3-1-“;
 
 payment = "87.90000000000001";
 
 "pic_path" = "http://image.xiaolu.so/MG_14640585064122.jpg";
 
 "process_time" = "2016-05-27 09:44:45";
 
 title = "\U5c0f\U6e05\U65b0\U4f11\U95f2\U4e24\U4ef6\U5957/\U9ed1\U8272”;   === > 商品title
 
 "ware_by_display" = "1\U53f7\U4ed3”;     === > 1号仓库
 

 */
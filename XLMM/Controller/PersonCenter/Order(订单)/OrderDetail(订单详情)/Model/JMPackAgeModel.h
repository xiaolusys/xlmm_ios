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
/**
 *  发货时间
 */
@property (nonatomic,copy) NSString *finish_time;

@property (nonatomic,copy) NSString *weight_time;

@property (nonatomic,copy) NSString *cancel_time;
/**
 *  订货时间
 */
@property (nonatomic,copy) NSString *book_time;
/**
 *  入仓分配/质检时间
 */
@property (nonatomic,copy) NSString *assign_time;
/**
 *  包裹ID
 */
@property (nonatomic, copy) NSString *packageID;
@property (nonatomic, copy) NSDictionary *logistics_company;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *out_sid;
/**
 *  时间
 */
@property (nonatomic,copy) NSString *process_time;
/**
 *  仓库编号
 */
@property (nonatomic,copy) NSString *ware_by_display;
/**
 *  支付时间
 */
@property (nonatomic,copy) NSString *pay_time;




@end


/**
 *  === 新数据 === 
 "package_orders" =     (
 {
 "assign_status_display" = "\U5df2\U53d6\U6d88";
 "assign_time" = "<null>";
 "book_time" = "<null>";
 "cancel_time" = "<null>";
 "finish_time" = "<null>";
 id = "";
 "logistics_company" = "<null>";
 note = "";
 "out_sid" = "";
 "pay_time" = "2016-06-28T20:33:22";
 "process_time" = "2016-06-28T20:33:22";
 "ware_by_display" = "\U5e7f\U5dde\U4ed3";
 "weight_time" = "2017-02-14 17:27:59";
 }
 );

 */


/* ======= 老数据 ===
 //需要查物流信息，查询到信息后
 AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
 NSString *str = [NSString stringWithFormat:@"%@/rest/packageskuitem?sale_trade_id=%@", Root_URL,[dicJson objectForKey:@"tid"]];
 [manage GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 if(!responseObject) return;
 [self setWuLiuMsg:responseObject];
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 }];
 <__NSCFArray 0x7fa1e1c87a50>(
 {
 "assign_status_display" = "\U5df2\U53d6\U6d88";
 "assign_time" = "<null>";
 "book_time" = "<null>";
 "cancel_time" = "<null>";
 "finish_time" = "<null>";
 "logistics_company_code" = "";
 "logistics_company_name" = "";
 num = 1;
 "out_sid" = "";
 "package_group_key" = "3-1-0-";
 "pay_time" = "2016-06-22T13:08:55";
 payment = "17.9";
 "pic_path" = "http://image.xiaolu.so/MG_14614007656646.jpg";
 "process_time" = "2016-06-22 13:08:55";
 title = "\U65b0\U6b3e\U9632\U6652\U8d85\U5927\U96ea\U7eba\U62ab\U80a9/\U5929\U84dd\U8272";
 "ware_by_display" = "1\U53f7\U4ed3";
 "weight_time" = "2017-02-14 17:27:59";
 }
 )

 */
























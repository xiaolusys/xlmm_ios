//
//  LogisticsModel.h
//  XLMM
//
//  Created by wulei on 5/19/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsModel : NSObject
//{
//    "title": "宽松破洞牛仔裤/图片色",
//    "pic_path": "http://image.xiaolu.so/MG_1458790075314头图背景1.png",
//    "assign_status_display": "已发货",
//    "ware_by_display": "广州/上海2号仓",
//    "out_sid": "3101031503285",
//    "logistics_company_name": "韵达热敏",
//    "process_time": "2016-05-18 13:10:27",
//    "package_group_key": "2-2-3101031503285"
//}

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *pic_path;
@property (nonatomic, copy)NSString *assign_status_display;
@property (nonatomic, copy)NSString *ware_by_display;
@property (nonatomic, copy)NSString *out_sid;
@property (nonatomic, copy)NSString *logistics_company_name;
@property (nonatomic, copy)NSString *process_time;
@property (nonatomic, copy)NSString *package_group_key;
@property (nonatomic, copy)NSString *payment;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *logistics_company_code;


@end

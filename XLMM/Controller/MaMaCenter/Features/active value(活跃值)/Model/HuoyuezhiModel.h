//
//  HuoyuezhiModel.h
//  XLMM
//
//  Created by younishijie on 16/3/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuoyuezhiModel : NSObject

@property (nonatomic, strong) NSNumber *mama_id;
@property (nonatomic, strong) NSNumber *value_num;
@property (nonatomic, strong) NSNumber *value_type;

@property (nonatomic, copy) NSString *value_type_name;
@property (nonatomic, copy) NSString *uni_key;
@property (nonatomic, copy) NSString *value_description;
@property (nonatomic, copy) NSString *date_field;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *status_display;
@property (nonatomic, strong) NSNumber *today_carry;

@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *created;





@end
/*{
 "mama_id": 5,
 "value_num": 10,
 "value_type": 2,
 "value_type_name": "订单",
 "uni_key": "active-5-2-2016-02-23-xo16022356cc287c4767f",
 "date_field": "2016-02-23",
 "status": 3,
 "status_display": "已取消",
 "today_carry": null,
 "modified": "2016-03-10T18:39:57",
 "created": "2016-03-10T18:31:36"
 },
*/

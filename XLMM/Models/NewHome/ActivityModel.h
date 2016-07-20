//
//  ActivityModel.h
//  XLMM
//
//  Created by zhang on 16/4/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (nonatomic, strong)NSNumber *activityID;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)BOOL login_required;
@property (nonatomic, strong)NSString *act_desc;
@property (nonatomic, strong)NSString *act_img;
@property (nonatomic, strong)NSString *act_logo;
@property (nonatomic, strong)NSString *mask_link;
@property (nonatomic, strong)NSString *act_link;
@property (nonatomic, strong)NSString *act_type;
@property (nonatomic, strong)NSString *act_applink;
@property (nonatomic, strong)NSString *start_time;
@property (nonatomic, strong)NSString *end_time;
@property (nonatomic, strong)NSNumber *order_val;
@property (nonatomic, strong)NSDictionary *extras;
@property (nonatomic, strong)NSNumber *total_member_num;
@property (nonatomic, strong)NSNumber *friend_member_num;
@property (nonatomic, assign)BOOL is_active;
@end
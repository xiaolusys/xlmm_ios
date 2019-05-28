//
//  JMHomeActiveModel.h
//  XLMM
//
//  Created by zhang on 16/8/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface JMHomeActiveModel : NSObject


@property (nonatomic, copy) NSString *act_applink;
@property (nonatomic, copy) NSString *act_desc;
@property (nonatomic, copy) NSString *act_img;
@property (nonatomic, copy) NSString *act_link;
@property (nonatomic, copy) NSString *act_logo;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, strong) NSDictionary *extras;
@property (nonatomic, copy) NSString *friend_member_num;
@property (nonatomic, copy) NSString *activeID;
@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *login_required;
@property (nonatomic, copy) NSString *mask_link;
@property (nonatomic, copy) NSString *order_val;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *total_member_num;

@property (nonatomic, assign) CGFloat cellHeight;


@end



/**
 *  {
 "act_applink" = "";
 "act_desc" = "\U4f18\U8d28\U6cd5\U5170\U7ed2\Uff0c\U8010\U7a7f\U4e0d\U6389\U8272\Uff0c\U5361\U901a\U6b3e\U5f0f\Uff0c\U7a7f\U4e0a\U79d2\U53d8\U840c\U5b9d\Uff01";
 "act_img" = "http://7xrst8.com1.z0.glb.clouddn.com/%E5%84%BF%E7%AB%A5%E5%8D%A1%E9%80%9A%E7%9D%A1%E8%A1%A3.jpg?imageMogr2/thumbnail/640/format/jpg/quality/90";
 "act_link" = "http://m.xiaolumeimei.com/mall/activity/topTen/model/2?id=73";
 "act_logo" = "";
 "act_type" = topic;
 "end_time" = "2016-09-03T06:00:00";
 extras =     {
 };
 "friend_member_num" = 16;
 id = 73;
 "is_active" = 1;
 "login_required" = 0;
 "mask_link" = "";
 "order_val" = 33;
 "start_time" = "2016-08-31T06:00:00";
 title = "\U8fd9\U4e48\U53ef\U7231\U7684\U5361\U901a\U7761\U8863\Uff0c\U5b9d\U5b9d\U4e00\U5b9a\U4f1a\U7231\U4e0a>>";
 "total_member_num" = 2000;
 }
 */

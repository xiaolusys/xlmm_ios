//
//  SharePicModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharePicModel : NSObject

@property (nonatomic, strong)NSNumber* piID;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* descriptionTitle;
@property (nonatomic, copy)NSString* start_time;
@property (nonatomic, strong)NSNumber* turns_num;
@property (nonatomic, strong)NSArray* pic_arry;
@property (nonatomic, strong)NSNumber* could_share;


@property (nonatomic, copy)NSString* save_times;
@property (nonatomic, copy)NSString* share_times;
@property (nonatomic, copy)NSString* sale_category;

@property (nonatomic, assign) CGFloat headerHeight;


@end



/**
 *  
 
 {
 "could_share" = 1;
 description = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U725b\U4ed4\U88e4\U6b63\U5f53\U65f6\Uff01
 \n\Ud83c\Udf83\U8170\U90e8\U62fc\U63a5\Uff0c\U65f6\U5c1a\U649e\U8272\Uff0c\U4fee\U8eab\U663e\U7626\Uff1b\U2615\U79cb\U5b63\U4e0a\U65b0\Uff0c\U8fd8\U6709\U52a0\U7ed2\U6b3e\U53ef\U4ee5\U9009\U62e9\U54e6~\Ud83d\Udea4\U90fd\U662f\U5927\U724c\U7684\U54c1\U8d28\Uff0c\U53ea\U5356\U5446\U840c\U7684\U4ef7\U683c\Uff01\Ud83c\Udfa7http://m.xiaolumeimei.com/m/24275/?next=mall/activity/topTen/model/2?id=221";
 id = 2850;
 "pic_arry" =     (
 "http://img.xiaolumeimei.com/nine_pic1476360805981",
 "http://img.xiaolumeimei.com/nine_pic1476360806119",
 "http://img.xiaolumeimei.com/nine_pic1476360806194",
 "http://img.xiaolumeimei.com/nine_pic1476360806271",
 "http://img.xiaolumeimei.com/nine_pic1476360806347",
 "http://img.xiaolumeimei.com/nine_pic1476360806401",
 "http://img.xiaolumeimei.com/nine_pic1476360806493",
 "http://img.xiaolumeimei.com/nine_pic1476360806628",
 "http://img.xiaolumeimei.com/nine_pic1476360806687"
 );
 "sale_category" = "<null>";
 "save_times" = 2;
 "share_times" = 0;
 "start_time" = "2016-10-14T06:00:00";
 title = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U725b\U4ed4\U88e4\U6b63\U5f53\U65f6\Uff01
 \n\Ud83c\Udf83\U8170\U90e8\U62fc\U63a5\Uff0c\U65f6\U5c1a\U649e\U8272\Uff0c\U4fee\U8eab\U663e\U7626\Uff1b\U2615\U79cb\U5b63\U4e0a\U65b0\Uff0c\U8fd8\U6709\U52a0\U7ed2\U6b3e\U53ef\U4ee5\U9009\U62e9\U54e6~\Ud83d\Udea4\U90fd\U662f\U5927\U724c\U7684\U54c1\U8d28\Uff0c\U53ea\U5356\U5446\U840c\U7684\U4ef7\U683c\Uff01\Ud83c\Udfa7http://m.xiaolumeimei.com/m/24275/?next=mall/activity/topTen/model/2?id=221";
 "turns_num" = 1;
 }
 
 
 
 */

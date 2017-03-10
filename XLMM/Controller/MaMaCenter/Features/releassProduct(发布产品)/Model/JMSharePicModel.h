//
//  SharePicModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMSharePicModel : NSObject

@property (nonatomic, strong)NSNumber* piID;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy) NSString *title_content;
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
 description = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U6211\U7684\U7cbe\U5fc3\U51c6\U5907\Uff0c\U53ea\U60f3\U8ba9\U4f60\U653e\U5fc3\Uff01
 \n\U5065\U5eb7\U6c34\U676f\Uff0c\U751f\U6d3b\U56e0\U4f60\U7684\U966a\U4f34\U800c\U7f8e\U4e3d~ \U5b89\U5168\U65e0\U6bd2\U65e0\U5bb3\Uff0c\U5f02\U5473\U5c0f\Uff0c\U5bc6\U5c01\U6027\U6781\U5f3a\U3002\U5706\U6da6\U8d34\U5408\U5507\U5f62\Uff0c\U559d\U6c34\U66f4\U8212\U9002\Uff01http://staging.xiaolumeimei.com/m/44/";
 id = 2551;
 "pic_arry" =     (
 "http://img.xiaolumeimei.com/nine_pic1474106605777",
 "http://img.xiaolumeimei.com/nine_pic1474106605919",
 "http://img.xiaolumeimei.com/nine_pic1474106605990",
 "http://img.xiaolumeimei.com/nine_pic1474106606039",
 "http://img.xiaolumeimei.com/nine_pic1474106606076",
 "http://img.xiaolumeimei.com/nine_pic1474106606161",
 "http://img.xiaolumeimei.com/nine_pic1474106606204",
 "http://img.xiaolumeimei.com/nine_pic1474106606302",
 "http://img.xiaolumeimei.com/nine_pic1474106606374"
 );
 "sale_category" = 2;
 "save_times" = 7;
 "share_times" = 0;
 "start_time" = "2016-10-17T11:00:00";
 title = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U6211\U7684\U7cbe\U5fc3\U51c6\U5907\Uff0c\U53ea\U60f3\U8ba9\U4f60\U653e\U5fc3\Uff01
 \n\U5065\U5eb7\U6c34\U676f\Uff0c\U751f\U6d3b\U56e0\U4f60\U7684\U966a\U4f34\U800c\U7f8e\U4e3d~ \U5b89\U5168\U65e0\U6bd2\U65e0\U5bb3\Uff0c\U5f02\U5473\U5c0f\Uff0c\U5bc6\U5c01\U6027\U6781\U5f3a\U3002\U5706\U6da6\U8d34\U5408\U5507\U5f62\Uff0c\U559d\U6c34\U66f4\U8212\U9002\Uff01http://staging.xiaolumeimei.com/m/44/";
 "title_content" = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011";
 "turns_num" = 2;
 }
 
 
 */

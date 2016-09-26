//
//  SharePicModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharePicModel : NSObject

@property (nonatomic, strong)NSNumber* piID;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* start_time;
@property (nonatomic, strong)NSNumber* turns_num;
@property (nonatomic, strong)NSArray* pic_arry;
@property (nonatomic, strong)NSNumber* could_share;

@end



/**
 *  
 
 {
 "could_share" = 1;
 description = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U65f6\U5c1a\U6709\U5ea6\Uff0c\U7a7f\U8863\U6709\U672f\Uff01
 \n\Ud83c\Udf89\U6c47\U96c6\U4e09\U6b3e\U4e0d\U540c\U7c7b\U578b\U7684\U886c\U886b\Uff0c\U7eaf\U8272\U68c9\U9ebb\U7684\U901a\U900f\U8212\U9002\Uff1b\Ud83c\Udf81\U5f69\U8272\U6761\U7eb9\U7684\U968f\U6027\U767e\U642d\Uff1b\Ud83c\Udf70\U8fd8\U6709\U5a03\U5a03\U8138\U96ea\U7eba\U7684\U53ef\U7231\U4e56\U5de7\Uff0c\U7b80\U76f4\U6bcf\U4e00\U4ef6\U90fd\U503c\U5f97\U6536\U85cf\U554a\Uff01 \Ud83c\Udfb8http://m.xiaolumeimei.com/m/44/";
 id = 2652;
 "pic_arry" =     (
 "http://img.xiaolumeimei.com/nine_pic1474728008327",
 "http://img.xiaolumeimei.com/nine_pic1474728008359",
 "http://img.xiaolumeimei.com/nine_pic1474728008420",
 "http://img.xiaolumeimei.com/nine_pic1474728008450",
 "http://img.xiaolumeimei.com/nine_pic1474728008482",
 "http://img.xiaolumeimei.com/nine_pic1474728008511",
 "http://img.xiaolumeimei.com/nine_pic1474728008551",
 "http://img.xiaolumeimei.com/nine_pic1474728008606",
 "http://img.xiaolumeimei.com/nine_pic1474728008637"
 );
 "start_time" = "2016-09-25T21:30:00";
 title = "\U3010\U5c0f\U9e7f\U7f8e\U7f8e\U3011\U65f6\U5c1a\U6709\U5ea6\Uff0c\U7a7f\U8863\U6709\U672f\Uff01
 \Ud83c\Udf89\U6c47\U96c6\U4e09\U6b3e\U4e0d\U540c\U7c7b\U578b\U7684\U886c\U886b\Uff0c\U7eaf\U8272\U68c9\U9ebb\U7684\U901a\U900f\U8212\U9002\Uff1b\Ud83c\Udf81\U5f69\U8272\U6761\U7eb9\U7684\U968f\U6027\U767e\U642d\Uff1b\Ud83c\Udf70\U8fd8\U6709\U5a03\U5a03\U8138\U96ea\U7eba\U7684\U53ef\U7231\U4e56\U5de7\Uff0c\U7b80\U76f4\U6bcf\U4e00\U4ef6\U90fd\U503c\U5f97\U6536\U85cf\U554a\Uff01 \Ud83c\Udfb8http://m.xiaolumeimei.com/m/44/";
 "turns_num" = 13;
 },
 
 
 
 
 */

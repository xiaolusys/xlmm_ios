//
//  JMHomeHourModel.h
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHomeHourModel : NSObject

@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSDictionary *profit;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *activity_id;


@end

/*
 {
 hour = 13;
 items =     (
 {
 "activity_id" = 825;
 hour = 13;
 "model_id" = 24847;
 name = "\U767e\U642d\U4fdd\U6696\U957f\U6b3e\U7f8a\U6bdb\U62ab\U80a9";
 pic = "http://img.xiaolumeimei.com/MG_1480582697321.jpg";
 price = 168;
 profit =             {
 max = 60;
 min = 20;
 };
 "start_time" = "2017-02-16T13:00:00";
 }
 );
 }

 
 
 */


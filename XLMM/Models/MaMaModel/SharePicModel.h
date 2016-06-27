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

//
//  DingdanModel.h
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingdanModel : NSObject


@property (nonatomic, copy)NSString *dingdanID;
@property (nonatomic, copy)NSString *dingdanURL;
@property (nonatomic, copy)NSString *dingdanTime;
@property (nonatomic, copy)NSString *imageURLString;
@property (nonatomic, copy)NSString *dingdanbianhao;
@property (nonatomic, copy)NSString *dingdanZhuangtai;
@property (nonatomic, copy)NSString *dingdanJine;
@property (nonatomic, copy)NSString *status_display;

@property (nonatomic, copy) NSArray *ordersArray;



@end

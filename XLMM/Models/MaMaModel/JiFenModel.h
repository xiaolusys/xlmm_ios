//
//  JiFenModel.h
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiFenModel : NSObject


@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *integral_user;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *log_value;
@property (nonatomic, copy)NSString *log_status;
@property (nonatomic, copy)NSString *log_type;
@property (nonatomic, copy)NSString *in_out;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *modified;
@property (nonatomic, strong)NSDictionary *order;

@end

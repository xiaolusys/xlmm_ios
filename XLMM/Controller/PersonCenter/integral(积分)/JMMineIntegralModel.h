//
//  JMMineIntegralModel.h
//  XLMM
//
//  Created by zhang on 16/9/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMineIntegralModel : NSObject


/**
 *  积分创建时间
 */
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *in_out;
@property (nonatomic, copy) NSString *integral_user;
@property (nonatomic, copy) NSString *log_status;
@property (nonatomic, copy) NSString *log_type;
/**
 *  积分分数
 */
@property (nonatomic, copy) NSString *log_value;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *modified;


@property (nonatomic, strong) NSDictionary *order_info;


@end

























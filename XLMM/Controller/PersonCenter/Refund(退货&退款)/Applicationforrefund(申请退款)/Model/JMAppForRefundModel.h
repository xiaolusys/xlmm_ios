//
//  JMAppForRefundModel.h
//  XLMM
//
//  Created by zhang on 16/6/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAppForRefundModel : NSObject
/**
 *  退款方式
 */
@property (nonatomic,copy) NSString *refund_channel;
/**
 *  退款类型名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  退款说明
 */
@property (nonatomic,copy) NSString *desc;

@end

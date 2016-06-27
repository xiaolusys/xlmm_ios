//
//  JMUserAddressModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMUserAddressModel : NSObject
/**
 *  姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  手机号
 */
@property (nonatomic,copy) NSString *phone;
/**
 *  地址
 */
@property (nonatomic,copy) NSString *address;

//+ (instancetype)modelWithModel:(JMUserAddressModel *)addressModel;
//
//- (instancetype)initWithModel:(JMUserAddressModel *)addressModel;

@end

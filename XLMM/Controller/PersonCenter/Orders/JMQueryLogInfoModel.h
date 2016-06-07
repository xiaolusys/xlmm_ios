//
//  JMQueryLogInfoModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMQueryLogInfoModel : NSObject

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *errcode;

@property (nonatomic,copy) NSString *expressID;

@property (nonatomic,copy) NSString *message;

@property (nonatomic,copy) NSString *order;

@property (nonatomic,strong) NSArray *data;


@end

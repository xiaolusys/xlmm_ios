//
//  JMProvince.h
//  XLMM
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMProvince : NSObject


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provinceWithDict:(NSDictionary *)dict;


+(NSMutableArray *)provinceList;

@end

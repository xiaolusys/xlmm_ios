//
//  JMProvince.h
//  XLMM
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMProvince : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provinceWithDict:(NSDictionary *)dict;


+(NSMutableArray *)provinceList;

@end

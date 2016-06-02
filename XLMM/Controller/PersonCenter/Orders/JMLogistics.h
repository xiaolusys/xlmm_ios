//
//  JMLogistics.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLogistics : NSObject

@property (nonatomic,copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *) dict;
+ (instancetype )logisticsWithDict:(NSDictionary *) dict;

@end

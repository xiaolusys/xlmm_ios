//
//  AddressModel.h
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, retain)NSString *provinceName;
@property (nonatomic, retain)NSString *cityName;
@property (nonatomic, retain)NSString *countyName;
@property (nonatomic, copy)NSString *streetName;
@property (nonatomic, copy)NSString *buyerName;
@property (nonatomic, copy)NSString *phoneNumber;

@end

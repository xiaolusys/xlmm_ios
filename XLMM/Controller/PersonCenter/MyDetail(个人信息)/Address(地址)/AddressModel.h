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

@property (nonatomic, copy)NSString *addressURL;
@property (nonatomic, copy)NSString *buyerID;
@property (nonatomic, assign)BOOL isDefault;
@property (nonatomic, copy)NSString *addressID;
@property (nonatomic, copy)NSString *identification_no;

@end



/*
 {
 created = "2016-10-20T20:52:12";
 "cus_uid" = 864138;
 default = 0;
 id = 151920;
 "identification_no" = "";
 "logistic_company_code" = "";
 "receiver_address" = pingllu;
 "receiver_city" = "\U6768\U6d66\U533a";
 "receiver_district" = "\U5185\U73af\U4e2d\U73af\U4e4b\U95f4";
 "receiver_mobile" = 18676720901;
 "receiver_name" = asdfasdf;
 "receiver_phone" = "";
 "receiver_state" = "\U4e0a\U6d77";
 "receiver_zip" = "";
 status = normal;
 url = "http://staging.xiaolumm.com/rest/v1/address/151920.json";
 }
 
 */








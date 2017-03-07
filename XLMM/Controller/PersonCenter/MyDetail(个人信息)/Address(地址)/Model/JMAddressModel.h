//
//  JMAddressModel.h
//  XLMM
//
//  Created by zhang on 17/2/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAddressModel : NSObject

@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *cus_uid;
@property (nonatomic, copy) NSNumber *defaultValue;
@property (nonatomic, copy) NSString *addressID;
@property (nonatomic, copy) NSString *identification_no;
@property (nonatomic, copy) NSString *logistic_company_code;
@property (nonatomic, copy) NSString *receiver_address;
@property (nonatomic, copy) NSString *receiver_city;
@property (nonatomic, copy) NSString *receiver_district;
@property (nonatomic, copy) NSString *receiver_mobile;
@property (nonatomic, copy) NSString *receiver_name;
@property (nonatomic, copy) NSString *receiver_phone;
@property (nonatomic, copy) NSString *receiver_state;
@property (nonatomic, copy) NSString *receiver_zip;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *personalinfo_level;



@end



/*
 {
 created = "2016-09-13T13:55:32";
 "cus_uid" = 1;
 default = 1;
 id = 141309;
 "identification_no" = "";
 "logistic_company_code" = "";
 "receiver_address" = "\U5e73\U51c9\U8def988\U53f7\U4e09\U53f7\U697c3241";
 "receiver_city" = "\U6768\U6d66\U533a";
 "receiver_district" = "\U5185\U73af\U4ee5\U5185";
 "receiver_mobile" = 18621623915;
 "receiver_name" = "\U6885\U79c0\U9752";
 "receiver_phone" = "";
 "receiver_state" = "\U4e0a\U6d77";
 "receiver_zip" = "";
 status = normal;
 url = "http://m.xiaolumeimei.com/rest/v1/address/141309.json";
 },
 */



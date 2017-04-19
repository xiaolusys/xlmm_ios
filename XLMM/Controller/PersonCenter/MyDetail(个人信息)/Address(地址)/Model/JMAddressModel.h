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
@property (nonatomic, strong) NSDictionary *idcard;


@end



/*
 {
 created = "2017-04-12T13:41:09";
 "cus_uid" = 864138;
 default = 0;
 id = 186132;
 idcard =     {
 back = "http://7xrpt3.com2.z0.glb.qiniucdn.com/ocr/idcard_864138_back_20170412134105.jpg?e=1492577279&token=M7M4hlQTLlz_wa5-rGKaQ2sh8zzTrdY8JNKNtvKN:0R-uSEF3_yG_pLS4mE9_bqprd0I=";
 face = "http://7xrpt3.com2.z0.glb.qiniucdn.com/ocr/idcard_864138_face_20170412134033.jpg?e=1492577279&token=M7M4hlQTLlz_wa5-rGKaQ2sh8zzTrdY8JNKNtvKN:fc6rZjNZqNQnTYPPy1NWy-KCKqE=";
 };
 "identification_no" = 429006198305285475;
 "logistic_company_code" = "";
 "personalinfo_level" = 3;
 "receiver_address" = "\U5927\U8fde\U8def";
 "receiver_city" = "\U6768\U6d66\U533a";
 "receiver_district" = "\U5185\U73af\U4e2d\U73af\U4e4b\U95f4";
 "receiver_mobile" = 18676720901;
 "receiver_name" = "\U4f0d\U78ca";
 "receiver_phone" = "";
 "receiver_state" = "\U4e0a\U6d77";
 "receiver_zip" = "";
 status = normal;
 url = "http://m.xiaolumeimei.com/rest/v1/address/186132.json";
 }
 */



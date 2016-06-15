//
//  NewCartsModel.h
//  XLMM
//
//  Created by younishijie on 15/10/19.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCartsModel : NSObject

@property (nonatomic, assign)int status;
@property (nonatomic, copy)NSString * sku_id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, assign)float price;
@property (nonatomic, assign)BOOL is_sale_out;
@property (nonatomic, copy)NSString * buyer_nick;
@property (nonatomic, assign)int num;
@property (nonatomic, copy)NSString * remain_time;
@property (nonatomic, assign)float std_sale_price;
@property (nonatomic, copy)NSString * item_weburl;
@property (nonatomic, assign)float total_fee;
@property (nonatomic, copy)NSString * item_id;
@property (nonatomic, copy)NSString * pic_path;
@property (nonatomic, copy)NSString * sku_name;
//@property (nonatomic, copy)NSString * is_sale_out;

@property (nonatomic, assign)int ID;
@property (nonatomic, assign)int buyer_id;

@end
/**
 *  <__NSCFArray 0x127e95710>(
 {
 "buyer_id" = 1;
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 created = "2016-06-15T18:58:36";
 id = 423265;
 "is_repayable" = 0;
 "item_id" = 40471;
 "item_weburl" = "http://staging.xiaolumeimei.com/mall/product/details/11468";
 num = 2;
 "pic_path" = "http://image.xiaolu.so/MG_14614007618135.jpg";
 price = "19.9";
 "sku_id" = 163262;
 "sku_name" = "\U5747\U7801";
 status = 0;
 "std_sale_price" = 99;
 title = "\U65b0\U6b3e\U9632\U6652\U8d85\U5927\U96ea\U7eba\U62ab\U80a9/\U897f\U74dc\U7ea2";
 "total_fee" = "39.8";
 url = "http://staging.xiaolumeimei.com/rest/v1/carts/423265.json";
 }
 )
 */





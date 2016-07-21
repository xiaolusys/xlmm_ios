//
//  CartListModel.h
//  XLMM
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CartListModel : NSObject

@property (nonatomic,copy) NSString *buyer_id;

@property (nonatomic,copy) NSString *buyer_nick;
/**
 *  商品购买创建时间
 */
@property (nonatomic,copy) NSString *created;
/**
 *  商品ID
 */
@property (nonatomic,copy) NSString *cartID;

@property (nonatomic,copy) NSString *is_repayable;

@property (nonatomic,copy) NSString *item_id;

@property (nonatomic, copy) NSString *item_weburl;
/**
 *  购买数量
 */
@property (nonatomic,copy) NSString *num;
/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *pic_path;
/**
 *  商品价格
 */
@property (nonatomic,copy) NSString *price;

@property (nonatomic,copy) NSString *sku_id;
/**
 *  商品规格型号
 */
@property (nonatomic,copy) NSString *sku_name;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *std_sale_price;
/**
 *  商品名称
 */
@property (nonatomic,copy) NSString *title;
/**
 *  商品支付价格
 */
@property (nonatomic,copy) NSString *total_fee;

@property (nonatomic,copy) NSString *url;


@end


/**
 *  "buyer_id" = 1;
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
 url = "http://staging.xiaolumeimei.com/rest/v2/carts/423265.json";
 }

 */
























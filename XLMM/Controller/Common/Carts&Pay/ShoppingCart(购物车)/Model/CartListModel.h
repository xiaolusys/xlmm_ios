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

@property (nonatomic,assign) NSInteger cartID;

@property (nonatomic,copy) NSString *is_repayable;

@property (nonatomic,copy) NSString *item_id;

@property (nonatomic, copy) NSString *item_weburl;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString *model_id;
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
 *  {
 "buyer_id" = 1;
 "buyer_nick" = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";
 created = "2016-08-18T22:51:55";
 id = 615936;
 "is_repayable" = 0;
 "item_id" = 42260;
 "item_weburl" = "http://m.xiaolumeimei.com/mall/product/details/12212";
 "model_id" = 12212;
 num = 1;
 "pic_path" = "http://image.xiaolu.so/MG_14623511416531.jpg";
 price = "69.90000000000001";
 "sku_id" = 171067;
 "sku_name" = M;
 status = 1;
 "std_sale_price" = 259;
 title = "\U6ce2\U897f\U7c73\U4e9a\U788e\U82b1\U5ea6\U5047\U88d9/\U73ab\U7ea2\U8272";
 "total_fee" = "69.90000000000001";
 url = "http://m.xiaolumeimei.com/rest/v1/carts/615936.json";
 },
 */






















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
/**
 *  是否为保税商品
 */
@property (nonatomic,copy) NSString *is_bonded_goods;

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
 *   {
 "buyer_id" = 864138;
 "buyer_nick" = "\U4f0d\U78ca";
 created = "2016-11-25T11:43:39";
 id = 776653;
 "is_bonded_goods" = 0;
 "is_repayable" = 0;
 "item_id" = 75775;
 "item_weburl" = "http://staging.xiaolumm.com/mall/product/details/23488";
 "model_id" = 23488;
 num = 1;
 "pic_path" = "http://img.xiaolumeimei.com/MG_1476884602962.jpg";
 price = 128;
 "sku_id" = 281290;
 "sku_name" = "\U4e00\U76d2";
 status = 0;
 "std_sale_price" = 640;
 title = "\U7ea4\U4e4b\U97f5\U724c\U51cf\U80a5\U80f6\U56ca\Uff08\U8f7b\U76c81\U53f7\Uff090.45g*60\U7c92/\U7ecf\U5178";
 "total_fee" = 128;
 type = 0;
 url = "http://staging.xiaolumm.com/rest/v1/carts/776653";
 },

 */






















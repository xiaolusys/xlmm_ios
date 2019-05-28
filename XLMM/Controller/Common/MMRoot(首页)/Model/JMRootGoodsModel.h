//
//  JMRootGoodsModel.h
//  XLMM
//
//  Created by zhang on 16/8/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMRootGoodsModel : NSObject



@property (nonatomic, copy) NSString *category_id;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *head_img;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString *goodsID;
/**
 *  是否有库存
 */
@property (nonatomic, copy) NSString *is_saleout;
/**
 *  现价
 */
@property (nonatomic, copy) NSString *lowest_agent_price;
/**
 *  原价
 */
@property (nonatomic, copy) NSString *lowest_std_sale_price;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  结束时间
 */
@property (nonatomic, copy) NSString *offshelf_time;
/**
 *  开始时间
 */
@property (nonatomic, copy) NSString *onshelf_time;
/**
 *  是否上架
 */
@property (nonatomic, copy) NSString *sale_state;
/**
 *  商品详情接口
 */
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *watermark_op;
/**
 *  H5页面链接
 */
@property (nonatomic, copy) NSString *web_url;





@end




/**
 * "category_id" = 64;
 "head_img" = "http://img.xiaolumeimei.com/MG_1471226658247-.jpg";
 id = 18738;
 "is_saleout" = 0;
 "lowest_agent_price" = "59.9";
 "lowest_std_sale_price" = 199;
 name = "\U4f18\U96c5\U8377\U53f6\U8fb9\U516c\U4e3b\U88d9";
 "offshelf_time" = "2016-08-20T00:00:00";
 "onshelf_time" = "2016-08-18T10:00:00";
 "sale_state" = will;
 url = "http://m.xiaolumeimei.com/rest/v2/modelproducts/18738";
 "watermark_op" = "";
 "web_url" = "http://m.xiaolumeimei.com/mall/product/details/18738";
 */






































//
//  JMGoodsInfoModel.h
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMGoodsInfoModel : NSObject
/**
 *  现价
 */
@property (nonatomic, copy) NSString *agent_price;

@property (nonatomic, copy) NSString *lowest_price;
/**
 *  颜色名称
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *outer_id;

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *product_img;
/**
 *  尺码的数组
 */
@property (nonatomic, strong) NSMutableArray *sku_items;
/**
 *  原价
 */
@property (nonatomic, copy) NSString *std_sale_price;
/**
 *  商品属性的类型 --> (颜色)
 */
@property (nonatomic, copy) NSString *type;



@end



/**
 *  {
 "agent_price" = "89.90000000000001";
 "lowest_price" = "89.90000000000001";
 name = "\U9ed1\U8272";
 "outer_id" = 915287210021;
 "product_id" = 33097;
 "product_img" = "http://image.xiaolu.so/MG_14558670230841.png";
 "sku_items" =             (
 {
 "agent_price" = "89.90000000000001";
 "free_num" = 15;
 "is_saleout" = 0;
 name = 120;
 "sku_id" = 130025;
 "std_sale_price" = 449;
 type = size;
 },
 {
 "agent_price" = "89.90000000000001";
 "free_num" = 15;
 "is_saleout" = 0;
 name = 130;
 "sku_id" = 130026;
 "std_sale_price" = 449;
 type = size;
 },
 {
 "agent_price" = "89.90000000000001";
 "free_num" = 13;
 "is_saleout" = 0;
 name = 140;
 "sku_id" = 130027;
 "std_sale_price" = 449;
 type = size;
 },
 {
 "agent_price" = "89.90000000000001";
 "free_num" = 13;
 "is_saleout" = 0;
 name = 150;
 "sku_id" = 130028;
 "std_sale_price" = 449;
 type = size;
 },
 {
 "agent_price" = "89.90000000000001";
 "free_num" = 13;
 "is_saleout" = 0;
 name = 160;
 "sku_id" = 130029;
 "std_sale_price" = 449;
 type = size;
 }
 );
 "std_sale_price" = 449;
 type = color;
 },
 */


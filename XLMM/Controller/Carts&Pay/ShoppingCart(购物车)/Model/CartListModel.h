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

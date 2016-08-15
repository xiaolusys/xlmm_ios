//
//  JMgoodsSizeModel.h
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMgoodsSizeModel : NSObject

@property (nonatomic, copy) NSString *agent_price;
/**
 *  存货数量
 */
@property (nonatomic, copy) NSString *free_num;
/**
 *  是否有货
 */
@property (nonatomic, copy) NSString *is_saleout;

@property (nonatomic, copy) NSString *sku_id;
/**
 *  尺码
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *std_sale_price;
/**
 *  类型 (尺寸)
 */
@property (nonatomic, copy) NSString *type;

@end

//
//  MaMaSelectProduct.h
//  XLMM
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaMaSelectProduct : NSObject

@property (nonatomic, strong)NSNumber *productId;
@property (nonatomic, strong)NSString *pic_path;
@property (nonatomic, strong)NSString *name;
//@property (nonatomic, assign)BOOL in_customer_shop;

@property (nonatomic, strong)NSNumber *in_customer_shop;

//@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, strong) NSNumber *rebet_amount;

@property (nonatomic, strong)NSNumber *sale_num;
@property (nonatomic, strong) NSNumber *agent_price;
@property (nonatomic, strong)NSNumber *std_sale_price;

@end

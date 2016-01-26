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
@property (nonatomic, strong)NSString *head_img;
@property (nonatomic, strong)NSString *name;
//@property (nonatomic, assign)BOOL in_customer_shop;

@property (nonatomic, strong)NSNumber *in_customer_shop;

@property (nonatomic, strong)NSNumber *status;

@end

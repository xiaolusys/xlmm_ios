//
//  BrandGoodsModel.h
//  XLMM
//
//  Created by wulei on 5/4/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandGoodsModel : NSObject
@property (nonatomic, assign)NSNumber *brandID;
@property (nonatomic, copy)NSString *product_id;
@property (nonatomic, copy)NSString *product_name;
@property (nonatomic, copy)NSString *product_img;
@property (nonatomic, copy)NSString *product_lowest_price;
@property (nonatomic, copy)NSString *product_std_sale_price;

@end

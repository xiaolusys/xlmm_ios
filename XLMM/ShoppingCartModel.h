//
//  ShoppingCartModel.h
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject

@property (nonatomic, copy)NSString *imageURL;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *oldPrice;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *cartID;
@property (nonatomic, copy)NSString *buyerID;
@property (nonatomic, assign)NSInteger number;


@property (nonatomic, copy)NSString *sizeName;



@end

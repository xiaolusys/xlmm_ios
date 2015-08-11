//
//  CollectionModel.h
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic, copy)NSString *urlStirng;
@property (nonatomic, copy)NSString *productID;
@property (nonatomic, copy)NSString *outerID;
@property (nonatomic, copy)NSString *imageURL;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *oldPrice;
@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSDictionary *productModel;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSArray *headImageURLArray;
@property (nonatomic, copy)NSArray *contentImageURLArray;

@end
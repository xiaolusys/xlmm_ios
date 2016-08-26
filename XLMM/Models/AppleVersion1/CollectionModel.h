//
//  CollectionModel.h
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic ,copy) NSString *web_url;
@property (nonatomic, copy)NSString *agentPrice;
@property (nonatomic, strong)NSDictionary * category;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy)NSString *isNewgood;
@property (nonatomic, copy)NSString *isSaleopen;
@property (nonatomic, copy)NSString *isSaleout;
@property (nonatomic, copy)NSString *memo;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *outerId;
@property (nonatomic, copy)NSString *picPath;
@property (nonatomic, copy)NSString *remainNum;
@property (nonatomic, copy)NSString *saleTime;
@property (nonatomic, copy)NSString *stdSalePrice;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *wareBy;
@property (nonatomic, strong)NSDictionary *productModel;

@property (nonatomic, copy)NSString *urlStirng;
@property (nonatomic, copy)NSString *productID;
@property (nonatomic, copy)NSString *outerID;
@property (nonatomic, copy)NSString *imageURL;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *oldPrice;

@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSArray *headImageURLArray;
@property (nonatomic, copy)NSArray *contentImageURLArray;

@property (nonatomic, copy)NSString *offShelfTime;

@property (nonatomic, copy)NSString *watermark_op;

- (instancetype)initWithDiction:(NSDictionary *)dic;


@end

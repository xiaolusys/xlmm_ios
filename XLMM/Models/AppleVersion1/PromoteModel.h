//
//  PromoteModel.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoteModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *Url;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *outerID;
@property (nonatomic, strong)NSDictionary *category;
@property (nonatomic, copy)NSString *picPath;
@property (nonatomic, copy)NSString *remainNum;
@property (nonatomic, copy)NSString *isSaleout;
@property (nonatomic, copy)NSString *isSaleopen;
@property (nonatomic, copy)NSString *isNewgood;
@property (nonatomic, copy)NSString *stdSalePrice;
@property (nonatomic, copy)NSString *agentPrice;
@property (nonatomic, copy)NSString *wareBy;
@property (nonatomic, strong)NSDictionary *productModel;
@property (nonatomic, copy)NSString *saleTime;
@property (nonatomic, copy)NSString *memo;
@property (nonatomic, copy)NSString *offshelfTime;
@property (nonatomic, copy) NSString *watermark_op;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

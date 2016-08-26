//
//  CollectionModel.m
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype)initWithDiction:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _web_url = [dic objectForKey:@"web_url"];
        _agentPrice = [dic objectForKey:@"product_lowest_price"];
        _category = [dic objectForKey:@"category"];
        _ID = [dic objectForKey:@"id"];
        _model_id = [dic objectForKey:@"model_id"];
        _isNewgood = [dic objectForKey:@"is_newgood"];
        _isSaleopen = [dic objectForKey:@"is_saleopen"];
        _isSaleout = [dic objectForKey:@"is_saleout"];
        _memo = [dic objectForKey:@"memo"];
        _name = [dic objectForKey:@"name"];
        _outerId = [dic objectForKey:@"outer_id"];
        _picPath = [dic objectForKey:@"pic_path"];
        _remainNum = [dic objectForKey:@"remain_num"];
        _saleTime = [dic objectForKey:@"sale_time"];
        _stdSalePrice = [dic objectForKey:@"std_sale_price"];
        _url = [dic objectForKey:@"url"];
        _wareBy = [dic objectForKey:@"ware_by"];
        _productModel = [dic objectForKey:@"product_model"];
        _offShelfTime = [dic objectForKey:@"offshelf_time"];
        _watermark_op = [dic objectForKey:@"watermark_op"];

    }
    return self;
}

@end

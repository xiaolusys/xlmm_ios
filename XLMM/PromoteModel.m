//
//  PromoteModel.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PromoteModel.h"

@implementation PromoteModel


- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _ID = [dic objectForKey:@"id"];
        _name = [dic objectForKey:@"name"];
        _Url = [dic objectForKey:@"url"];
        _agentPrice = [dic objectForKey:@"lowest_price"];
        _stdSalePrice = [dic objectForKey:@"std_sale_price"];
        _outerID = [dic objectForKey:@"outer_id"];
        _isSaleopen = [dic objectForKey:@"is_saleopen"];
        _isSaleout = [dic objectForKey:@"is_saleout"];
        _category = [dic objectForKey:@"category"];
        _remainNum = [dic objectForKey:@"remain_num"];
        _saleTime = [dic objectForKey:@"sale_time"];
        _wareBy = [dic objectForKey:@"ware_by"];
        _productModel = [dic objectForKey:@"product_model"];
        _watermark_op = [dic objectForKey:@"watermark_op"];
        if ([_productModel class] == [NSNull class]) {
            _picPath = [dic objectForKey:@"head_img"];
            _productModel = nil;
            return self;
        }
        if ([[_productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
            _picPath = [dic objectForKey:@"head_img"];
        } else{
            if ([[_productModel objectForKey:@"head_imgs"] count] != 0) {
                _picPath = [[_productModel objectForKey:@"head_imgs"] objectAtIndex:0];
            }
            else {
                _picPath = [dic objectForKey:@"head_img"];
            }
            _name = [_productModel objectForKey:@"name"];
        }
        return self;
    }
    return self;
}


@end

//
//  NSObject+FillDataModel.m
//  XLMM
//
//  Created by younishijie on 15/9/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NSObject+FillDataModel.h"
#import "PromoteModel.h"


@implementation NSObject (FillDataModel)

- (PromoteModel *)fillModel:(NSDictionary *)dic{
    PromoteModel *model = [PromoteModel new];
    model.name = [dic objectForKey:@"name"];
    
    // model.picPath = [childInfo objectForKey:@"pic_path"];
    model.Url = [dic objectForKey:@"url"];
    model.agentPrice = [dic objectForKey:@"agent_price"];
    model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
    model.outerID = [dic objectForKey:@"outer_id"];
    model.isNewgood = [dic objectForKey:@"is_newgood"];
    model.isSaleopen = [dic objectForKey:@"is_saleopen"];
    model.isSaleout = [dic objectForKey:@"is_saleout"];
    model.ID = [dic objectForKey:@"id"];
    model.category = [dic objectForKey:@"category"];
    model.remainNum = [dic objectForKey:@"remain_num"];
    model.saleTime = [dic objectForKey:@"sale_time"];
    model.wareBy = [dic objectForKey:@"ware_by"];
    model.picPath = [dic objectForKey:@"head_img"];
    
    if ([[dic objectForKey:@"product_model"] class] == [NSNull class]) {
        // NSLog(@"没有集合页");
        model.productModel = nil;
        
    } else{
        model.productModel = [dic objectForKey:@"product_model"];
        model.name = [model.productModel objectForKey:@"name"];
        // NSLog(@"*************");
    }
    return model;
    
    
}

@end

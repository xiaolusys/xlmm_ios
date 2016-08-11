//
//  JMGoodsInfoModel.m
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsInfoModel.h"
#import "JMgoodsSizeModel.h"


@implementation JMGoodsInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sku_items":[JMgoodsSizeModel class]};
}

@end

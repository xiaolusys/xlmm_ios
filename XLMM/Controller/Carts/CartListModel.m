//
//  CartListModel.m
//  XLMM
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CartListModel.h"

@implementation CartListModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"cartID":@"id"};
}


@end

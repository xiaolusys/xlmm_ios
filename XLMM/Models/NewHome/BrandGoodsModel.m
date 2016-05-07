//
//  BrandGoodsModel.m
//  XLMM
//
//  Created by wulei on 5/4/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "BrandGoodsModel.h"

@implementation BrandGoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.brandID = value;
    }
}
@end

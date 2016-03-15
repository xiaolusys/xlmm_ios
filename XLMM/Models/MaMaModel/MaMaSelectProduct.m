
//
//  MaMaSelectProduct.m
//  XLMM
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaSelectProduct.h"

@implementation MaMaSelectProduct

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.productId = value;
    }
}
@end

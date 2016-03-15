//
//  SharePicModel.m
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "SharePicModel.h"

@implementation SharePicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _piID = value;
    }
}

@end

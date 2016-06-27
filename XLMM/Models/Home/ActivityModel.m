//
//  ActivityModel.m
//  XLMM
//
//  Created by zhang on 16/4/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.activityId = value;
    }
}
@end

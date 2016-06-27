//
//  ActivityModel.m
//  XLMM
//
//  Created by zhang on 16/4/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.activityID = value;
    }
}
@end

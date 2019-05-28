//
//  SharePicModel.m
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSharePicModel.h"

@implementation JMSharePicModel

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        _piID = value;
//    }
//    if ([key isEqualToString:@"description"]) {
//        _descriptionTitle = value;
//    }
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"piID":@"id",
             @"descriptionTitle":@"description"};
}

- (CGFloat)headerHeight {
    if (!_headerHeight) {
        CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat contentH = [self.descriptionTitle boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.]} context:nil].size.height;
        _headerHeight = contentH + 60;
    }
    return _headerHeight;
}





@end

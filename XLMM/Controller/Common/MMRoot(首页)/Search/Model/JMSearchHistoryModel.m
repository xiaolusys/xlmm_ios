//
//  JMSearchHistoryModel.m
//  XLMM
//
//  Created by zhang on 17/1/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchHistoryModel.h"

@implementation JMSearchHistoryModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"searchID":@"id"};
}

- (CGFloat)cellWidth {
    if (!_cellWidth) {
        CGFloat contentW = [self.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.]} context:nil].size.width;
        _cellWidth = contentW + 30;
        
        
    }
    return _cellWidth;
}


@end
















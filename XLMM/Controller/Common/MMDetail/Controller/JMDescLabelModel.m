//
//  JMDescLabelModel.m
//  XLMM
//
//  Created by zhang on 16/8/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMDescLabelModel.h"

@implementation JMDescLabelModel


- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 90;
        CGFloat contentH = [self.value boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil].size.height;
        _cellHeight = contentH + 20;
    }
    return _cellHeight;
}





@end

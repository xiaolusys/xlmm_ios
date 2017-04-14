//
//  AccountModel.m
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}


- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = SCREENWIDTH - 20;
        CGFloat contentH = [self.desc boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:CS_UIFontSize(14.)} context:nil].size.height;
        _cellHeight = contentH + 50;
    }
    return _cellHeight;
}





@end

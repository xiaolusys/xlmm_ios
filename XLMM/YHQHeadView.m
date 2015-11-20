//
//  YHQHeadView.m
//  XLMM
//
//  Created by younishijie on 15/11/20.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "YHQHeadView.h"

@implementation YHQHeadView

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YHQHeadView" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

@end

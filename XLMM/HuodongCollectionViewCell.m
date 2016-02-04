//
//  HuodongCollectionViewCell.m
//  XLMM
//
//  Created by younishijie on 16/2/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HuodongCollectionViewCell.h"

@implementation HuodongCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HuodongCollectionViewCell" owner:self options:nil];
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

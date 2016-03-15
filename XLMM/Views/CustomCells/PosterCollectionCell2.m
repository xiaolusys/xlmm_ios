//
//  PosterCollectionCell2.m
//  XLMM
//
//  Created by younishijie on 15/10/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "PosterCollectionCell2.h"

@implementation PosterCollectionCell2

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PosterCollectionCell2" owner:self options:nil];
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

//
//  JifenReusableView.m
//  XLMM
//
//  Created by younishijie on 15/11/21.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "JifenReusableView.h"

@implementation JifenReusableView

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JifenReusableView" owner:self options:nil];
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

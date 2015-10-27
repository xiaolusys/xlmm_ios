//
//  CartCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/9/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartCollectionCell.h"

@implementation CartCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CartCollectionCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.cornerRadius = 8;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1].CGColor;
    
    [self.mybutton.layer setMasksToBounds:YES];
    [self.mybutton.layer setBorderWidth:1.0];
    [self.mybutton.layer setBorderColor:[UIColor redColor].CGColor];
    return self;
}


@end

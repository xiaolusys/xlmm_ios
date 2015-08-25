//
//  PeopleCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PeopleCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "MMClass.h"

@implementation PeopleCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PeopleCollectionCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

- (void)fillData:(PeopleModel *)model{
    [self.imageView setImageWithURL:kLoansRRL(model.imageURL)];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.oldPrice];
    self.backView.layer.cornerRadius = 40;
    if (!model.isSaleOut) {
        NSLog(@"%d", model.isSaleOut);
        self.backView.hidden = YES;
        self.frontView.hidden = YES;
    } else{
        NSLog(@"%d", model.isSaleOut);
        self.backView.hidden = NO;
        self.frontView.hidden = NO;
 
    }
}

@end

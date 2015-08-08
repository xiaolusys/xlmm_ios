//
//  ClothesCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ClothesCollectionCell.h"
#import "MMClass.h"
#import "UIImageView+WebCache.h"
@implementation ClothesCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ClothesCollectionCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)fillData:(CollectionModel *)model{
    [self.imageView sd_setImageWithURL:kLoansRRL(model.imageURL)];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.oldPrice];
}

@end

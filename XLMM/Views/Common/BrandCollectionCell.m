//
//  BrandCollectionCell.m
//  XLMM
//
//  Created by wulei on 5/4/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "BrandCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BrandGoodsModel.h"
#import "ImageUtils.h"

@implementation BrandCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BrandCollectionCell" owner:self options:nil];
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

- (void)fillDataWithModel:(BrandGoodsModel *)model{
    
    [ImageUtils loadImage:self.imageView url:model.product_img];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.product_lowest_price floatValue]];

    self.oldPriceLabel.text = [NSString stringWithFormat:@"/¥%@",model.product_std_sale_price];
    
}
@end

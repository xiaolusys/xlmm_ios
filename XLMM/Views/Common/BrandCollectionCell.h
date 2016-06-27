//
//  BrandCollectionCell.h
//  XLMM
//
//  Created by wulei on 5/4/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
#import "BrandGoodsModel.h"

@interface BrandCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleateLine;

- (void)fillDataWithModel:(BrandGoodsModel *)model;

@end

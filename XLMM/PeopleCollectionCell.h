//
//  PeopleCollectionCell.h
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromoteModel.h"
#import "CollectionModel.h"
@interface PeopleCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

- (void)fillDataWithCollectionModel:(CollectionModel *)model;
- (void)fillData:(PromoteModel *)model;

@end

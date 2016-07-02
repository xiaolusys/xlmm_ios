//
//  JMRootgoodsCell.h
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionModel;
@class PromoteModel;
@interface JMRootgoodsCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *curreLabel;

@property (nonatomic, strong) UILabel *oldPriceLabel;

@property (nonatomic, strong) UILabel *deletLine;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *backLabel;

- (void)fillDataWithCollectionModel:(CollectionModel *)model;

- (void)fillData:(PromoteModel *)model;

@end

//
//  JMRootgoodsCell.h
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cacleStoreBlock)(NSString *storID);

@class CollectionModel;
@class PromoteModel;
@class JMStoreUpModel;
@interface JMRootgoodsCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *curreLabel;

@property (nonatomic, strong) UILabel *oldPriceLabel;

@property (nonatomic, strong) UILabel *deletLine;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *backLabel;

@property (nonatomic, strong) UIButton *storeUpButton;

@property (nonatomic, strong) UIImageView *storeUpImage;

@property (nonatomic, copy)  cacleStoreBlock block;

- (void)fillDataWithCollectionModel:(CollectionModel *)model;

- (void)fillData:(PromoteModel *)model;

- (void)fillStoreUpData:(JMStoreUpModel *)model;

@end

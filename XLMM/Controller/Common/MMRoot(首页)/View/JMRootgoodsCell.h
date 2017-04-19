//
//  JMRootgoodsCell.h
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cacleStoreBlock)(NSString *storID);

@class CollectionModel,JMRootGoodsModel,JMStoreUpModel;
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

- (void)fillDataWithCollectionModel:(CollectionModel *)model; // 没有用到

- (void)fillDataWithGoodsList:(JMRootGoodsModel *)model;      // 商品展示列表

@property (nonatomic, strong) NSDictionary *itemDict;

@end




























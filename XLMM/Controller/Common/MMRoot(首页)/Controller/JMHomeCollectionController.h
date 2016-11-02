//
//  JMHomeCollectionController.h
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBaseScrollViewController.h"
#import "JMRootGoodsModel.h"
#import "JMRootgoodsCell.h"

@interface JMHomeCollectionController : JMBaseScrollViewController


//- (NSString *)urlString;

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) UICollectionView *collectionView;


@end

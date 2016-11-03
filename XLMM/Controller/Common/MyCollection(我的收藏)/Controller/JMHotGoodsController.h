//
//  JMHotGoodsController.h
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPageViewBaseController.h"

@interface JMHotGoodsController : JMPageViewBaseController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, copy) NSString *nextPageUrlString;

- (void)loadDataSource;

- (void)loadMore;


@end

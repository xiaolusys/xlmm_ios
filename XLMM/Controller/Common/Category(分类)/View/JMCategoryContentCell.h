//
//  JMCategoryContentCell.h
//  XLMM
//
//  Created by zhang on 16/9/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMCategoryListCell.h"

@interface JMContentCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *ContentCollectionIndexPath;

@end

static NSString *ContentCollectionViewIndentifier = @"ContentCollectionViewIndentifier";

@interface JMCategoryContentCell : UITableViewCell


@property (nonatomic, strong) JMContentCollectionView *contentCollecionView;


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate IndexPath:(NSIndexPath *)indexPath;



@end

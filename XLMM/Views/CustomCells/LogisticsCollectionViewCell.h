//
//  LogisticsCollectionViewCell.h
//  XLMM
//
//  Created by wulei on 5/21/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderGoodsModel;
@interface LogisticsCollectionViewCell : UICollectionViewCell

- (void)configData:(JMOrderGoodsModel *)model;

@end

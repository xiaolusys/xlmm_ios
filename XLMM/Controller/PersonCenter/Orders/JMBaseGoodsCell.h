//
//  JMBaseGoodsCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMOrderGoodsModel.h"

@class JMBaseGoodsCell;
@class JMOrderGoodsModel;
@protocol JMBaseGoodsCellDelegate <NSObject>

- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row;

- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row;

@end

@class JMOrderGoodsModel;
@interface JMBaseGoodsCell : UITableViewCell



- (void)configWithModel:(JMOrderGoodsModel *)goodsModel SectionCount:(NSInteger)sectionCount RowCount:(NSInteger)rowCount;

@property (nonatomic, weak) id<JMBaseGoodsCellDelegate>delegate;

@end

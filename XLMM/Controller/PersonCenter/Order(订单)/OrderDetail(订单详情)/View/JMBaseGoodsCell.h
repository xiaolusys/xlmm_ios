//
//  JMBaseGoodsCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMOrderGoodsModel.h"
#import "CartListModel.h"

@class JMBaseGoodsCell;
//@class JMOrderGoodsModel;
@protocol JMBaseGoodsCellDelegate <NSObject>

@optional
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row;

- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row;

@end

//@class JMOrderGoodsModel;
@class JMPackAgeModel;
@interface JMBaseGoodsCell : UITableViewCell

@property (nonatomic, assign) BOOL isTeamBuy;
@property (nonatomic, assign) bool isCanRefund;

- (void)configWithAllOrder:(JMOrderGoodsModel *)goodsModel;

- (void)configWithModel:(JMOrderGoodsModel *)goodsModel SectionCount:(NSInteger)sectionCount RowCount:(NSInteger)rowCount;
//- (void)configWithModel:(JMOrderGoodsModel *)goodsModel PackageModel:(JMPackAgeModel *)packageModel SectionCount:(NSInteger)sectionCount RowCount:(NSInteger)rowCount;

- (void)configPurchaseModel:(CartListModel *)cartModel;

@property (nonatomic, weak) id<JMBaseGoodsCellDelegate>delegate;


@end

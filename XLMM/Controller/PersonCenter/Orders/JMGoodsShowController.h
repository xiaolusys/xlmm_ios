//
//  JMGoodsShowController.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsShowController;
@class JMOrderGoodsModel;
@protocol JMGoodsShowControllerDelegate <NSObject>

- (void)composeWithLogistics:(JMGoodsShowController *)logistics didClickButton:(NSInteger)index;

- (void)composeOptionBtnClick:(JMGoodsShowController *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row;

- (void)composeOptionTapClick:(JMGoodsShowController *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row;

@end


@class JMOrderGoodsModel;
@interface JMGoodsShowController : UIViewController

@property (nonatomic,strong) JMOrderGoodsModel *goodsModel;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *logisticsArr;

@property (nonatomic, weak) id<JMGoodsShowControllerDelegate>delegate;

@end

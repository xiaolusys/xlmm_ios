//
//  JMPurchaseHeaderView.h
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@class JMPurchaseHeaderView;
@protocol JMPurchaseHeaderViewDelegate <NSObject>

- (void)composeHeaderTapView:(JMPurchaseHeaderView *)headerView TapClick:(NSInteger)index;

@end


@interface JMPurchaseHeaderView : UIView

@property (nonatomic, strong) UIView *addressView;

@property (nonatomic, strong) UIView *logisticsView;

@property (nonatomic, strong) NSArray *addressArr;
/**
 *  地址信息数据源
 */
@property (nonatomic, strong) AddressModel *addressModel;
/**
 *  物流选择
 */
@property (nonatomic, strong) UILabel *logisticsLabel;

@property (nonatomic, weak) id<JMPurchaseHeaderViewDelegate> delegate;

@end

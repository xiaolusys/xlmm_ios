//
//  JMOrderDetailHeaderView.h
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMOrderDetailModel.h"

@class JMOrderDetailHeaderView;
@protocol JMOrderDetailHeaderViewDelegate <NSObject>

- (void)composeHeaderTapView:(JMOrderDetailHeaderView *)headerView TapClick:(NSInteger)index;

@end

@interface JMOrderDetailHeaderView : UIView

@property (nonatomic, strong) UIView *addressView;

@property (nonatomic, strong) UIView *logisticsView;

@property (nonatomic, copy) NSString *logisticsStr;

@property (nonatomic, assign) BOOL isTimeLineView;

@property (nonatomic, strong) JMOrderDetailModel *orderDetailModel;

@property (nonatomic, weak) id<JMOrderDetailHeaderViewDelegate> delegate;

+ (instancetype)enterHeaderView;

@end

//
//  JMNORefundView.h
//  XLMM
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMNORefundView;

@protocol JMNORefundViewDelegate <NSObject>

@optional

- (void)composeNoRefundButton:(JMNORefundView *)refundButton didClick:(NSInteger)index;
@end

@interface JMNORefundView : UIView

@property (nonatomic, weak) id<JMNORefundViewDelegate> delegate;

+ (instancetype)defaultPopView;


@end


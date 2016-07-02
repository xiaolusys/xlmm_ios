//
//  JMRefundView.h
//  XLMM
//
//  Created by zhang on 16/6/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRefundView;

@protocol JMRefundViewDelegate <NSObject>

@optional

- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index;
@end

@interface JMRefundView : UIView

@property (nonatomic, weak) id<JMRefundViewDelegate> delegate;

+ (instancetype)defaultPopView;

@property (nonatomic, copy) NSString *titleStr;

@end

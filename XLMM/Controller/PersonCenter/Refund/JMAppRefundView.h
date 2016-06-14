//
//  JMAppRefundView.h
//  XLMM
//
//  Created by zhang on 16/6/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAppRefundView;
@protocol JMAppRefundViewDelegate <NSObject>

- (void)composeRefundButton:(JMAppRefundView *)refundButton didClick:(NSInteger)index;

@end

@interface JMAppRefundView : UIView

@property (nonatomic,weak) id<JMAppRefundViewDelegate> delegate;

@property (nonatomic,copy) NSMutableArray *payMentArr;

@end

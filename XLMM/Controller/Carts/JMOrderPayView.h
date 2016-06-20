//
//  JMOrderPayView.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderPayView;
@protocol JMOrderPayViewDelegate <NSObject>

- (void)composePayButton:(JMOrderPayView *)payButton didClick:(NSInteger)index;

@end

@interface JMOrderPayView : UIView

@property (nonatomic,copy) NSString *payMent;

@property (nonatomic,weak) id<JMOrderPayViewDelegate> delegate;


@end

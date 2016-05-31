//
//  JMOrderPayView.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderPayView;
@protocol JMOrderPayViewDelegate <NSObject>

@optional
- (void)composePayBtn:(JMOrderPayView *)payBtn didClickBtn:(NSInteger)index;

@end


@interface JMOrderPayView : UIView

@property (nonatomic,weak) id<JMOrderPayViewDelegate> delegate;


@end

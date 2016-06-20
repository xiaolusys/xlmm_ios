//
//  JMRepopView.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRepopView;

@protocol JMRepopViewDelegate <NSObject>

@optional

- (void)composePayButton:(JMRepopView *)payButton didClick:(NSInteger)index;
@end

@interface JMRepopView : UIView

@property (nonatomic, weak) id<JMRepopViewDelegate> delegate;

+ (instancetype)defaultPopView;


@end

//
//  JMOrderPayOutdateView.h
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderPayOutdateView;
@protocol JMOrderPayOutdateViewDelegate <NSObject>

- (void)composeOutDateView:(JMOrderPayOutdateView *)outDateView Index:(NSInteger)index;

@end

@interface JMOrderPayOutdateView : UIView

@property (nonatomic, copy) NSString *createTimeStr;

@property (nonatomic, assign) NSInteger statusCount;
@property (nonatomic, assign) BOOL isTeamBuy;

@property (nonatomic, weak) id<JMOrderPayOutdateViewDelegate> delegate;

@end

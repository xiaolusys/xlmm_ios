//
//  JMMaMaHomeHeaderView.h
//  XLMM
//
//  Created by zhang on 16/11/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLineChart.h"
#import "JMAutoLoopPageView.h"

@class JMMaMaCenterModel,JMMaMaExtraModel,JMMaMaHomeHeaderView;
//typedef void(^mamaButtonAction)(UIButton *button);
typedef void(^autoLoopPage)(JMAutoLoopPageView *loopPageView, NSMutableDictionary *dic);

@protocol JMMaMaHomeHeaderViewDelegte <NSObject>

- (void)composeHomeHeader:(JMMaMaHomeHeaderView *)headerView ButtonActionClick:(UIButton *)button;

@end

@interface JMMaMaHomeHeaderView : UIView

@property (nonatomic, weak) id <JMMaMaHomeHeaderViewDelegte> delegate;
//@property (nonatomic, copy) mamaButtonAction buttonActionBlock;
@property (nonatomic, copy) autoLoopPage loopPageBlock;
@property (nonatomic, strong) JMMaMaCenterModel *centerModel;
@property (nonatomic, strong) JMMaMaExtraModel *extraModel;
@property (nonatomic, copy) NSString *currentTurnsNum;
@property (nonatomic, strong) NSArray *mamaResults;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) NSDictionary *messageDic;
@property (nonatomic, strong) NSString *mamaNotReadNotice;
@property (nonatomic, strong) JMAutoLoopPageView *pageView;

@property (nonatomic, strong) NSDictionary *userInfoDic;

@property (nonatomic, copy) NSString *withDrawMoney;





@end


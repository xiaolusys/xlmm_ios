//
//  JMPageContentView.h
//  XLMM
//
//  Created by zhang on 17/2/24.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSegmentedControl;
@interface JMPageContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray DescTitleArray:(NSArray *)descTitleArray PageController:(UIViewController *)pageVC;

@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) int lastSelectedIndex;
@property (nonatomic, strong) NSArray *dataSource;


@end

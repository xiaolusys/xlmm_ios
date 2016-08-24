//
//  JMSegmentView.h
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSegmentView : UIView

@property (nonatomic, strong) UIScrollView *segmentScrollView;

@property (nonatomic, strong) NSArray *timeArray;

- (instancetype)initWithFrame:(CGRect)frame Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray PageController:(UIViewController *)pageVC DataArray:(NSArray *)dataArray;


@end





























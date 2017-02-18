//
//  JMHomeSegmentView.h
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMHomeSegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSMutableArray *)dataSource Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray PageController:(UIViewController *)pageVC;

@property (nonatomic, strong) UIScrollView *segmentScrollView;


@end

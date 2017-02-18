//
//  JMHomeSegmentView.m
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeSegmentView.h"
#import "HMSegmentedControl.h"
#import "JMHomeHourController.h"


@interface JMHomeSegmentView ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *controllArray;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation JMHomeSegmentView



- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSMutableArray *)dataSource Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray PageController:(UIViewController *)pageVC {
    if (self == [super initWithFrame:frame]) {
        self.segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, frame.size.height)];
        self.segmentScrollView.pagingEnabled = YES;
        self.segmentScrollView.showsHorizontalScrollIndicator = NO;
        self.segmentScrollView.scrollEnabled = NO;
        [self addSubview:self.segmentScrollView];
        // 添加子视图两种方法
//        for (int i = 0; i < controller.count; i ++) {
////            JMHomeHourController *hourVC = [[JMHomeHourController alloc] init];
//            UIViewController *control = controller[i];
//            control.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, frame.size.height);
//            [self.segmentScrollView addSubview:control.view];
//        }
        for (int i = 0 ; i < controller.count; i++) {
            UIViewController *control = controller[i];
            [self.segmentScrollView addSubview:control.view];
            control.view.frame = CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, frame.size.height); // 整理高度 - 64 --> 是否需要添加???
            [pageVC addChildViewController:control];
            [control didMoveToParentViewController:pageVC];
        }
        self.segmentScrollView.contentSize = CGSizeMake(SCREENWIDTH * controller.count, frame.size.height);
        JMHomeHourController *control = controller[0];
        control.dataSource = dataSource[0];
        
        
    }
    return self;
}
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
//    NSInteger page = segmentedControl.selectedSegmentIndex;
//    self.segmentScrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
//    JMHomeHourController *control = self.controllArray[page];
//    control.dataSource = self.dataSource[page];
//    
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.frame.size.width;
//    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    
//}









@end

































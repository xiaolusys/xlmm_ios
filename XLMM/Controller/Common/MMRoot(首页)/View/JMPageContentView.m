//
//  JMPageContentView.m
//  XLMM
//
//  Created by zhang on 17/2/24.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMPageContentView.h"
#import "JMHomeHourController.h"
#import "HMSegmentedControl.h"


@interface JMPageContentView () <UIScrollViewDelegate>{
    NSArray *_controllersArray;
}




@end

@implementation JMPageContentView


- (instancetype)initWithFrame:(CGRect)frame Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray DescTitleArray:(NSArray *)descTitleArray PageController:(UIViewController *)pageVC {
    if (self == [super initWithFrame:frame]) {
        
        _controllersArray = controller;
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        self.segmentedControl.sectionTitles = titleArray;
        self.segmentedControl.sectionDescTitles = descTitleArray;
        self.segmentedControl.selectedSegmentIndex = 0;
        self.segmentedControl.backgroundColor = [UIColor whiteColor];
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18.]};
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:20.]};
//        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        self.segmentedControl.selectionIndicatorHeight = 2.f;
        self.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.segmentedControl];
        
        self.segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREENWIDTH, frame.size.height - 60 - 45)];
        self.segmentScrollView.pagingEnabled = YES;
        self.segmentScrollView.showsHorizontalScrollIndicator = NO;
        self.segmentScrollView.contentSize = CGSizeMake(SCREENWIDTH * controller.count, frame.size.height - 60);
        self.segmentScrollView.delegate = self;
        self.segmentScrollView.scrollEnabled = NO;
        //        [self.segmentScrollView scrollRectToVisible:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT) animated:NO];
        [self addSubview:self.segmentScrollView];
        self.segmentScrollView.contentOffset = CGPointMake(self.segmentedControl.selectedSegmentIndex * SCREENWIDTH, 0);
        
        for (int i = 0 ; i < controller.count; i++) {
            UIViewController *control = controller[i];
            [self.segmentScrollView addSubview:control.view];
            control.view.frame = CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, frame.size.height); // 整理高度 - 64 --> 是否需要添加???
            [pageVC addChildViewController:control];
            [control didMoveToParentViewController:pageVC];
            
        }
        
        
    }
    return self;
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    self.segmentScrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    _lastSelectedIndex = (int)page;
//    JMHomeHourController *pageVC = _controllersArray[page];
//    [pageVC refresh];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    _lastSelectedIndex = (int)page;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];

}

- (void)setLastSelectedIndex:(int)lastSelectedIndex {
    _lastSelectedIndex = lastSelectedIndex;
    self.segmentedControl.selectedSegmentIndex = lastSelectedIndex;
    
}

@end







































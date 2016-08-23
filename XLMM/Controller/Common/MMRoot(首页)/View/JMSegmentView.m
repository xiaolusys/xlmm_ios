//
//  JMSegmentView.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSegmentView.h"
#import "HMSegmentedControl.h"
#import "MMClass.h"

@interface JMSegmentView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIScrollView *segmentScrollView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation JMSegmentView


- (instancetype)initWithFrame:(CGRect)frame Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray PageController:(UIViewController *)pageVC {
    if (self == [super initWithFrame:frame]) {
        self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        [self addSubview:self.segmentView];
        
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        self.segmentedControl.sectionTitles = titleArray;
        self.segmentedControl.selectedSegmentIndex = 1;
        self.segmentedControl.backgroundColor = [UIColor whiteColor];
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonTitleColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
        self.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        [self.segmentView addSubview:self.segmentedControl];
        
        // == 倒计时 == //
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 45)];;
        timeLabel.backgroundColor = [UIColor redColor];
        [self.segmentView addSubview:timeLabel];
        
        self.segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT - 80)];
        self.segmentScrollView.backgroundColor = [UIColor redColor];
        self.segmentScrollView.pagingEnabled = YES;
        self.segmentScrollView.showsHorizontalScrollIndicator = NO;
        self.segmentScrollView.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
        self.segmentScrollView.delegate = self;
        [self.segmentScrollView scrollRectToVisible:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) animated:NO];
        [self addSubview:self.segmentScrollView];
        
        for (int i = 0 ; i < controller.count; i++) {
            UIViewController *control = controller[i];
            [self.segmentScrollView addSubview:control.view];
            control.view.frame = CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - 80);
            [pageVC addChildViewController:control];
            [control didMoveToParentViewController:pageVC];
        }
        
    }
    return self;
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

- (void)createSegment {
    
    
    
}







@end































































































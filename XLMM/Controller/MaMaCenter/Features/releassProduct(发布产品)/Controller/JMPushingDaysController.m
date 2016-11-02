//
//  JMPushingDaysController.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDaysController.h"
#import "HMSegmentedControl.h"
#import "JMPushingCategoryController.h"
#import "PublishNewPdtViewController.h"


@interface JMPushingDaysController ()
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) JMPushingCategoryController *pushingCategoryVC;
@property (nonatomic, strong) PublishNewPdtViewController *pushingNewVC;


@end

@implementation JMPushingDaysController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(btnClicked:)];
    [self createSegmentView];
    [self createSegement];
    
}

- (void)createSegmentView {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    self.segmentedControl.backgroundColor = [UIColor sectionViewColor];
    self.segmentedControl.sectionTitles = @[@"按日期展示",@"按分类展示"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonTitleColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 64, SCREENWIDTH, SCREENHEIGHT) animated:YES];
    }];
    [self.view addSubview:self.segmentedControl];
}
- (void)createSegement {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, SCREENHEIGHT);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) animated:NO];
    [self.view addSubview:self.scrollView];
    
    
    self.pushingNewVC = [[PublishNewPdtViewController alloc] init];
    self.pushingNewVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.pushingNewVC];
    [self.scrollView addSubview:self.pushingNewVC.view];
    
    
    self.pushingCategoryVC = [[JMPushingCategoryController alloc] init];
    self.pushingCategoryVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.pushingCategoryVC];
    [self.scrollView addSubview:self.pushingCategoryVC.view];
    

    
    
    
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}
- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}
- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMPushingDaysController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMPushingDaysController"];
}


@end









































































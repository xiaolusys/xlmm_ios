//
//  JMOrderListController.m
//  XLMM
//
//  Created by zhang on 17/3/1.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMOrderListController.h"
#import "UIImage+UIImageExt.h"
#import "JMPersonAllOrderController.h"
#import "HMSegmentedControl.h"


@interface JMOrderListController () <UIScrollViewDelegate> {
    NSArray *_itemArr;
    NSArray *_urlArr;
}
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;


@end

@implementation JMOrderListController

#pragma mark 懒加载
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 45)];
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.sectionTitles = _itemArr;
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 2.f;
        _segmentControl.selectionIndicatorColor = [UIColor orangeColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.delegate = self;
    }
    return _baseScrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"订单列表" selecotr:@selector(backClick)];
    
    _itemArr = @[@"全部订单",@"待支付",@"待收货"];
    _urlArr = @[kQuanbuDingdan_URL,kWaitpay_List_URL,kWaitsend_List_URL];
    
    [self.view addSubview:self.segmentControl];
    _segmentControl.selectedSegmentIndex = self.currentIndex;
    
    [self.view addSubview:self.baseScrollView];
    [self addChildController];
    [self removeToPage:self.currentIndex];
}
- (void)addChildController {
    for (int i = 0 ; i < _itemArr.count; i++) {
        JMPersonAllOrderController *fineVC = [[JMPersonAllOrderController alloc] init];
        [self addChildViewController:fineVC];
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * _itemArr.count, self.baseScrollView.frame.size.height);
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    [self removeToPage:page];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    _lastSelectedIndex = (int)page;
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
    [self removeToPage:page];
    
}
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    JMPersonAllOrderController *homeFirst = self.childViewControllers[index];
    homeFirst.urlString = _urlArr[index];
    homeFirst.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:homeFirst.view];
    [homeFirst didMoveToParentViewController:self];
}
- (void)backClick {
    if (self.ispopToView) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



@end
























































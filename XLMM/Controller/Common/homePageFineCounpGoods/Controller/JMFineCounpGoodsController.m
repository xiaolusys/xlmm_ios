//
//  JMFineCounpGoodsController.m
//  XLMM
//
//  Created by zhang on 16/12/2.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFineCounpGoodsController.h"
#import "HMSegmentedControl.h"
#import "JMFineCounpContentController.h"

@interface JMFineCounpGoodsController () <UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;



//@property (nonatomic, strong) JMSelecterButton *selectedButton;

@end



@implementation JMFineCounpGoodsController

- (NSArray *)setUrlData {
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/boutique", Root_URL];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/boutique?order_by=price", Root_URL];
    NSArray *arr = @[urlStr1,urlStr2];
    return arr;
}
- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
        NSArray *arr = [self setUrlData];
        for (int i = 0; i < arr.count; i++) {
            [_urlArray addObject:arr[i]];
        }
    }
    return _urlArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    
    [self createSegmentControl];
    
}
/*
 创建分页控制器
 */
- (void)createSegmentControl {
    self.segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 37)];
    [self.view addSubview:self.segmentControl];
    self.segmentControl.backgroundColor = [UIColor whiteColor];
    self.segmentControl.sectionTitles = @[@"推荐排序",@"价格排序"];
    self.segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = 1.f;
    self.segmentControl.verticalDividerEnabled = YES;
    self.segmentControl.selectionIndicatorColor = [UIColor buttonEnabledBackgroundColor];
    self.segmentControl.verticalDividerColor = [UIColor buttonDisabledBackgroundColor];
    self.segmentControl.verticalBottomLineColor = [UIColor lineGrayColor];
    self.segmentControl.verticalDividerWidth = 1.0f;
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13.],
                                                NSForegroundColorAttributeName : [UIColor buttonTitleColor]};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                        NSForegroundColorAttributeName : [UIColor buttonEnabledBackgroundColor]};
    [self createScrollView];
    kWeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf removeToPage:index];
    }];
}
- (void)createScrollView {
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - self.segmentControl.frame.size.height - 64 - 49)];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, self.baseScrollView.frame.size.height);
    [self.view addSubview:self.baseScrollView];
    
    [self addChildController];
    
    UIViewController *firstVC = [self.childViewControllers firstObject];
    firstVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:firstVC.view];
    
}
/*
 添加子视图
 */
- (void)addChildController {
    for (int i = 0 ; i < self.urlArray.count; i++) {
        JMFineCounpContentController *goodsVC = [[JMFineCounpContentController alloc] init];
        goodsVC.urlString = self.urlArray[i];
        [self addChildViewController:goodsVC];
    }
    self.baseScrollView.contentOffset = CGPointMake(0, 0);
}
/*
 scrollView代理方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self removeToPage:page];
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
}
/*
 移动到某个子视图
 */
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    JMFineCounpContentController *goodsVC = self.childViewControllers[index];
    goodsVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:goodsVC.view];
//    [goodsVC refresh];
}






- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMFineCounpGoodsController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMFineCounpGoodsController"];
}








@end







































































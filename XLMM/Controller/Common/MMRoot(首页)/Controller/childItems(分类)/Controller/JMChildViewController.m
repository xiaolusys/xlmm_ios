//
//  JMChildViewController.m
//  XLMM
//
//  Created by zhang on 16/12/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChildViewController.h"
#import "JMHomeRootCategoryController.h"
#import "HMSegmentedControl.h"
#import "JMFineCounpContentController.h"


@interface JMChildViewController () <UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;


@end

@implementation JMChildViewController


- (void)setCategoryCid:(NSString *)categoryCid {
    _categoryCid = categoryCid;
    
}

- (NSArray *)setSegmentArr {
    return @[@"推荐排序",@"价格排序"];
}
- (NSArray *)setUrlData {
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@", Root_URL,self.categoryCid];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?order_by=price&cid=%@", Root_URL,self.categoryCid];
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
//    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];
    [self createSegmentControl];
//    [self craeteRight];
}
/*
 创建分页控制器
 */
- (void)createSegmentControl {
    self.segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    [self.view addSubview:self.segmentControl];
    self.segmentControl.backgroundColor = [UIColor whiteColor];
    self.segmentControl.sectionTitles = [self setSegmentArr];
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
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - self.segmentControl.frame.size.height - 45 - 64)];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.scrollEnabled = NO;
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


- (void)craeteRight {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}



- (void)rightClicked:(UIButton *)button {
    JMHomeRootCategoryController *rootCategoryVC = [[JMHomeRootCategoryController alloc] init];
    rootCategoryVC.cidString = self.categoryCid;
    rootCategoryVC.titleString = self.titleString;
    rootCategoryVC.categoryUrl = self.categoryUrlString;
    [self.navigationController pushViewController:rootCategoryVC animated:YES];
    
}


- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMChildViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMChildViewController"];
}





@end









































































































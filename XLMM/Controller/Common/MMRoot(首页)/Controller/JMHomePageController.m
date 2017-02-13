//
//  JMHomePageController.m
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomePageController.h"
#import "HMSegmentedControl.h"
#import "JMChildViewController.h"
#import "JMHomeFirstController.h"
#import "JMHomeRootCategoryController.h"


@interface JMHomePageController () <UIScrollViewDelegate> {
    NSMutableArray *_categoryNameArray;
    NSMutableArray *_categoryCidArray;
    NSString *_currentCidString;
    NSString *_currentNameString;
}

@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSMutableArray *urlArray;


@property (nonatomic, strong) UIButton *navRightButton;

@end

@implementation JMHomePageController
- (instancetype)init {
    if (self == [super init]) {
        _categoryNameArray = [NSMutableArray array];
        _categoryCidArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"main"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"main"];
}
- (void)didReceiveMemoryWarning {
    [[JMGlobal global] clearAllSDCache];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick)];
    [self createSegmentControl];
    [self createRightItem];
    [self loadCategoryData];

}
- (void)loadCategoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/categorys",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchCategoryData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchCategoryData:(NSArray *)categoryArr {
    [_categoryNameArray addObject:@"今日特卖"];
    for (NSDictionary *dic in categoryArr) {
        [_categoryNameArray addObject:dic[@"name"]];
        [_categoryCidArray addObject:dic[@"cid"]];
    }
    self.segmentControl.sectionTitles = [_categoryNameArray copy];
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * _categoryNameArray.count, self.baseScrollView.frame.size.height);
    [self addChildController];
}

/*
 创建分页控制器
 */
- (void)createSegmentControl {
    self.segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 45)];
    [self.view addSubview:self.segmentControl];
    self.segmentControl.backgroundColor = [UIColor colorWithRed:244 / 255. green:244 / 255. blue:244 / 255. alpha:1.];
    
    self.segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.verticalDividerEnabled = YES;
    self.segmentControl.verticalDividerColor = [UIColor blackColor];
    self.segmentControl.verticalDividerWidth = 1.0f;
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
    [self createScrollView];
    kWeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf removeToPage:index];
    }];
}
- (void)createScrollView {
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    [self.view addSubview:self.baseScrollView];

}
/*
 添加子视图
 */
- (void)addChildController {
    for (int i = 0 ; i < _categoryNameArray.count; i++) {
//        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,_categoryCidArray[i]];
//        CSGoodsViewController *goodsVC = [[CSGoodsViewController alloc] init];
//        goodsVC.urlString = self.urlArray[i];
//        [self addChildViewController:goodsVC];
        if (i == 0) {
            JMHomeFirstController *homeFirst = [[JMHomeFirstController alloc] init];
            [self addChildViewController:homeFirst];
        }else {
            JMChildViewController *childCategoryVC = [[JMChildViewController alloc] init];
            childCategoryVC.categoryCid = _categoryCidArray[i - 1];
            [self addChildViewController:childCategoryVC];
        }
    }
    self.baseScrollView.contentOffset = CGPointMake(0, 0);
    
    UIViewController *firstVC = [self.childViewControllers firstObject];
    firstVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:firstVC.view];
    _currentCidString = _categoryCidArray[0];
    _currentNameString = _categoryNameArray[1];
    
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
    if (index == 0) {
        _currentCidString = _categoryCidArray[index];
        _currentNameString = _categoryNameArray[index];
    }else {
        _currentCidString = _categoryCidArray[index - 1];
        _currentNameString = _categoryNameArray[index - 1];
    }
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
//    CSGoodsViewController *goodsVC = self.childViewControllers[index];
//    goodsVC.view.frame = self.baseScrollView.bounds;
//    [self.baseScrollView addSubview:goodsVC.view];
    if (index == 0) {
        JMHomeFirstController *homeFirst = self.childViewControllers[index];
        homeFirst.view.frame = self.baseScrollView.bounds;
        [self.baseScrollView addSubview:homeFirst.view];
    }else {
        JMChildViewController *childCategoryVC = self.childViewControllers[index];
        childCategoryVC.view.frame = self.baseScrollView.bounds;
        [self.baseScrollView addSubview:childCategoryVC.view];
    }
}

- (void)createRightItem {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton addTarget:self action:@selector(searchBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBarImage"]];
    rightImageview.frame = CGRectMake(20, 13, 18, 18);
    [rightButton addSubview:rightImageview];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
- (void)searchBarClick:(UIButton *)button {
    JMHomeRootCategoryController *rootCategoryVC = [[JMHomeRootCategoryController alloc] init];
    rootCategoryVC.cidString = _currentCidString;
    rootCategoryVC.titleString = _currentNameString;
//    rootCategoryVC.categoryUrl = self.categoryUrlString;
    [self.navigationController pushViewController:rootCategoryVC animated:YES];
}









@end

















































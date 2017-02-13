//
//  JMHomePageController.m
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomePageController.h"
#import "HMSegmentedControl.h"


@interface JMHomePageController () <UIScrollViewDelegate> {
    NSMutableArray *_categoryNameArray;
    NSMutableArray *_categoryCidArray;
}

@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSMutableArray *urlArray;


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
    for (NSDictionary *dic in categoryArr) {
        [_categoryNameArray addObject:dic[@"name"]];
        [_categoryCidArray addObject:dic[@"cid"]];
    }
    self.segmentControl.sectionTitles = [_categoryNameArray copy];
    
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
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - self.segmentControl.frame.size.height - 64 - 49)];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * 10, self.baseScrollView.frame.size.height);
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
//        CSGoodsViewController *goodsVC = [[CSGoodsViewController alloc] init];
//        goodsVC.urlString = self.urlArray[i];
//        [self addChildViewController:goodsVC];
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
//    CSGoodsViewController *goodsVC = self.childViewControllers[index];
//    goodsVC.view.frame = self.baseScrollView.bounds;
//    [self.baseScrollView addSubview:goodsVC.view];
    
}












@end

//
//  JMHomeFirstController.m
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeFirstController.h"
#import "HMSegmentedControl.h"
#import "JMMainTableView.h"
#import "JMHomeSegmentCell.h"
#import "JMHomeSegmentView.h"
#import "JMHomeHourController.h"
#import "JMHomeHourModel.h"
#import "JMAutoLoopPageView.h"
#import "JMHomeHeaderCell.h"
#import "JumpUtils.h"
#import "JMHomePageController.h"


@interface JMHomeFirstController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, JMAutoLoopPageViewDataSource, JMAutoLoopPageViewDelegate> {
    /**
     *  主页视图滚动位置判断
     */
    BOOL _canScroll;
    BOOL _isTopIsCanNotMoveTabView;
    BOOL _isTopIsCanNotMoveTabViewPre;
    
    BOOL _isPullDown;                        //下拉的标志
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *itemNameArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) JMHomeSegmentView *segmentView;
@property (nonatomic, strong) JMAutoLoopPageView *pageView;

@property (nonatomic, strong) UIScrollView *segmentScrollView;

@property(nonatomic,strong)NSMutableArray *tableViews;
@property (nonatomic, strong) UICollectionView *currentTableView;

@property (nonatomic, strong) JMHomePageController *pageVC;

@end

@implementation JMHomeFirstController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)itemNameArr {
    if (!_itemNameArr) {
        _itemNameArr = [NSMutableArray array];
    }
    return _itemNameArr;
}
- (NSMutableArray *)controllArr {
    if (!_controllArr) {
        _controllArr = [NSMutableArray array];
    }
    return _controllArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"main"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"main"];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [[JMGlobal global] clearAllSDCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//     self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    _currentIndex = 0;
    [self createTabelView];
    self.tableViews = [NSMutableArray array];
    
    [self createPullHeaderRefresh];
//    [self loadDataSource];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@",self.parentViewController);
//    
//    NSLog(@"%@",scrollView);
    if (self.tableView == scrollView) {
        CGFloat offsetY = self.tableView.contentOffset.y;
        
        
        if (offsetY > 150) {
            self.pageController.baseScrollView.scrollEnabled = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.pageController.segmentControl.mj_y = 0;
                self.pageController.baseScrollView.mj_y = 64;
            }];
//            scrollView.contentOffset = CGPointMake(0, 150);
        }else {
            self.pageController.baseScrollView.scrollEnabled = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.pageController.segmentControl.mj_y = 64;
                self.pageController.baseScrollView.mj_y = 64 + 45;
            }];
            
            
        }
        
    }
    
}

#pragma mark 数据请求
// 请求整点上新数据
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/today",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchData:(NSArray *)dataArray {
    for (NSDictionary *itemDic in dataArray) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        NSArray *items = itemDic[@"items"];
        for (NSDictionary *itemD in items) {
            JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:itemD];
            [itemsArr addObject:model];
        }
        [self.dataSource addObject:itemsArr];
        int hourInt = [itemDic[@"hour"] intValue];
        NSString *hourStr = [NSString stringWithFormat:@"%02d:00\n抢购中",hourInt];
        
        [self.itemNameArr addObject:hourStr];
    }
//    [self initUI];
//    self.segmentedControl.sectionTitles = self.itemNameArr;
}


#pragma mark 创建tableView
- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JMHomeSegmentCell class] forCellReuseIdentifier:JMHomeSegmentCellIdentifier];
    
    self.pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 0.4)];
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    self.pageView.isCreatePageControl = YES;
    [self.pageView registerCellWithClass:[JMHomeHeaderCell class] identifier:@"JMHomeHeaderCell"];
    self.pageView.scrollStyle = JMAutoLoopScrollStyleHorizontal;
    self.pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
    self.pageView.scrollForSingleCount = YES;
    self.pageView.atuoLoopScroll = YES;
    self.pageView.scrollFuture = YES;
    self.pageView.autoScrollInterVal = 4.0f;
    
    self.tableView.tableHeaderView = self.pageView;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREENHEIGHT - 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeSegmentCellIdentifier];
    if (!cell) {
        cell = [[JMHomeSegmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeSegmentCellIdentifier];
    }
    if (self.itemNameArr.count != 0) {
        [cell addSubview:self.segmentView];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    if (self.itemNameArr.count != 0) {
        self.segmentedControl.sectionTitles = self.itemNameArr;
    }
    self.segmentedControl.selectedSegmentIndex = _currentIndex;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedControl.selectionIndicatorHeight = 1.0f;
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //        self.segmentedControl.shouldAnimateUserSelection = NO;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    //        __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        //            [weakSelf.segmentScrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 80, SCREENWIDTH, SCREENHEIGHT) animated:YES];
    }];
    return self.segmentedControl;
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    _currentIndex = segmentedControl.selectedSegmentIndex;
    [self.segmentedControl setSelectedSegmentIndex:_currentIndex animated:YES];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
    self.segmentView.segmentScrollView.contentOffset = CGPointMake(_currentIndex * SCREENWIDTH, 0);
    JMHomeHourController *control = self.controllArr[_currentIndex];
    control.dataSource = self.dataSource[_currentIndex];
    
}


#pragma mark 添加segmentViewController
- (JMHomeSegmentView *)segmentView {
    if (!_segmentView) {
        self.controllArr = [NSMutableArray array];
        for (int i = 0; i < self.itemNameArr.count; i ++) {
            JMHomeHourController *hourVC = [[JMHomeHourController alloc] init];
            [self.controllArr addObject:hourVC];
        }
        self.segmentView = [[JMHomeSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) DataSource:self.dataSource Controllers:self.controllArr TitleArray:self.itemNameArr PageController:self];
    }
    return _segmentView;
    
}
#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return self.topImageArray.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMHomeHeaderCell *testCell = cell;
    NSDictionary *dict = self.topImageArray[index];
    testCell.topDic = dict;
}
- (NSString *)cellIndentifierWithIndex:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    return @"JMHomeHeaderCell"; // 返回自定义cell的identifier
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidScrollToIndex:(NSUInteger)index {
    //    NSLog(@"JMHomeRootController ---> pageView滚动");
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index {
    [MobClick event:@"banner_click"];
    NSDictionary *topDic = _topImageArray[index];
    [JumpUtils jumpToLocation:topDic[@"app_link"] viewController:self];
}










@end



























































































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
#import "JMHomeHourController.h"
#import "JMHomeHourModel.h"
#import "JMAutoLoopPageView.h"
#import "JMHomeHeaderCell.h"
#import "JumpUtils.h"
#import "JMHomePageController.h"
#import "UIImage+UIImageExt.h"
#import "JMRichTextTool.h"
#import "JMPageContentView.h"

#define contentOffsetY SCREENWIDTH * 0.4

NSString *const JMPageScrollControllerLeaveTopNotifition = @"JMPageScrollControllerLeaveTopNotifition";


@interface JMHomeFirstController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, JMAutoLoopPageViewDataSource, JMAutoLoopPageViewDelegate, JMPageScrollControllerDelegate> {
    BOOL _isPullDown;                        //下拉的标志
    int _currentIndex;
    int _currentTimeHour;
    int _qiangouCurrentTimeHour;
    NSMutableArray *_timeHourArr;
}
@property (nonatomic, strong) JMHomePageController *pageVC;

@property (nonatomic, strong) JMMainTableView *tableView;
@property (nonatomic, strong) JMPageContentView *pageContentView;
@property (nonatomic, strong) JMAutoLoopPageView *pageView;
@property (strong, nonatomic) UIScrollView *childScrollView;

@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) NSMutableArray *itemNameArr;
@property (nonatomic, strong) NSMutableArray *itemDescNameArr;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation JMHomeFirstController
#pragma mark 懒加载
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
- (NSMutableArray *)itemDescNameArr {
    if (!_itemDescNameArr) {
        _itemDescNameArr = [NSMutableArray array];
    }
    return _itemDescNameArr;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[JMMainTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = SCREENHEIGHT;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.pageView;
    }
    return _tableView;
}
- (JMAutoLoopPageView *)pageView {
    if (!_pageView) {
        _pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, contentOffsetY)];
        _pageView.dataSource = self;
        _pageView.delegate = self;
        _pageView.isCreatePageControl = YES;
        [_pageView registerCellWithClass:[JMHomeHeaderCell class] identifier:@"JMHomeHeaderCell"];
        _pageView.scrollStyle = JMAutoLoopScrollStyleHorizontal;
        _pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
        _pageView.scrollForSingleCount = YES;
        _pageView.atuoLoopScroll = YES;
        _pageView.scrollFuture = YES;
        _pageView.autoScrollInterVal = 4.0f;
    }
    return _pageView;
}
- (JMPageContentView *)pageContentView {
    if (!_pageContentView) {
        // 移除已经添加的子控制器
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
        }];
        _pageContentView = [[JMPageContentView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) Controllers:self.controllArr TitleArray:self.itemNameArr DescTitleArray:self.itemDescNameArr PageController:self];
    }
    return _pageContentView;
}
#pragma mark  视图生命周期函数
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"main"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"main"];
    if (self.pageView) {
        [self.pageView endAutoScroll];
    }
}
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
    if (self.pageView) {
        [self.pageView removeFromSuperview];
        self.pageView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [[JMGlobal global] clearAllSDCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    [JMNotificationCenter addObserver:self selector:@selector(loginOut) name:@"logout" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(updataAfterLogin) name:@"weixinlogin" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(phoneNumberLogin) name:@"phoneNumberLogin" object:nil];

    self.pageController.baseScrollView.delegate = self;
    [self.view addSubview:self.tableView];
    [self createPullHeaderRefresh];
    [self.tableView.mj_header beginRefreshing];

}
#pragma mrak 刷新界面
- (void)refresh {
//    int currentHourInt = [self getCurrentTimeHour];
//    if (self.pageContentView == nil) {
//        return ;
//    }
//    int qianggouCurrentTime = 0, yureCurrentTime = 0 , lastSelectedTime = 0;
//    if (_timeHourArr.count > 0 && self.pageContentView != nil) {
//        qianggouCurrentTime = [_timeHourArr[_currentIndex] intValue];
//        if (_currentIndex + 1 >= _timeHourArr.count) {
//            yureCurrentTime = [_timeHourArr[_currentIndex] intValue];
//        }else {
//            yureCurrentTime = [_timeHourArr[_currentIndex + 1] intValue];
//        }
//        
//        
//        lastSelectedTime = [_timeHourArr[self.pageContentView.lastSelectedIndex] intValue];
//        if ((currentHourInt >= yureCurrentTime) || (qianggouCurrentTime != lastSelectedTime)) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_header beginRefreshing];
//            });
//        }
//    }
}
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
#pragma mark 数据请求,处理
// 请求整点上新数据
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/today",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.itemNameArr removeAllObjects];
        [self.itemDescNameArr removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.controllArr removeAllObjects];
        self.pageContentView = nil;
        [self fetchData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
- (void)fetchData:(NSArray *)dataArray {
    _currentIndex = 0;
    _currentTimeHour = -1;
    _qiangouCurrentTimeHour = 0;
    _timeHourArr = [NSMutableArray array];
    int currentHourInt = [self getCurrentTimeHour];
    for (NSDictionary *itemDic in dataArray) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        NSArray *items = itemDic[@"items"];
        for (NSDictionary *itemD in items) {
            JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:itemD];
            [itemsArr addObject:model];
        }
        [self.dataSource addObject:itemsArr];
        
        int hourInt = [itemDic[@"hour"] intValue];
        
        NSString *hourStr = [NSString stringWithFormat:@"%02d:00",hourInt];
        NSString *descStr;
        if (currentHourInt >= hourInt) {
            descStr = @"热卖中";
            _currentIndex ++;
            _qiangouCurrentTimeHour = hourInt;
        }else {
            if (_currentTimeHour == -1) {
                _currentTimeHour = hourInt;
            }
            descStr = @"热卖中";
        }
        [_timeHourArr addObject:@(hourInt)];
        [self.itemNameArr addObject:hourStr];
        [self.itemDescNameArr addObject:descStr];
        
    }
    for (int i = 0; i < self.itemNameArr.count; i ++) {
        JMHomeHourController *ceshiVC = [[JMHomeHourController alloc] init];
        [self.controllArr addObject:ceshiVC];
        ceshiVC.delegate = self;
        ceshiVC.dataSource = self.dataSource[i];
    }

    
}
- (int)getCurrentTimeHour {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return [strHour intValue];
}
#pragma mark- JMPageScrollControllerDelegate
- (void)scrollViewIscanScroll:(UIScrollView *)scrollView { //    CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
    _childScrollView = scrollView;
    if (self.tableView.contentOffset.y < contentOffsetY) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        self.tableView.contentOffset = CGPointMake(0.0f, contentOffsetY);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}
#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pageController.baseScrollView) {
    }else {
        if (self.childScrollView && _childScrollView.contentOffset.y > 0) {
            self.tableView.contentOffset = CGPointMake(0.0f, contentOffsetY);
        }else {
        }
        CGFloat scrollOffsetY = scrollView.contentOffset.y;
        if(scrollOffsetY < contentOffsetY) {
            [UIView animateWithDuration:0.3 animations:^{
                self.pageController.segmentControl.mj_y = 64;
                self.pageController.baseScrollView.frame = CGRectMake(0, 64 + 45, SCREENWIDTH, SCREENHEIGHT - 64 - 45);
            }];
            [JMNotificationCenter postNotificationName:JMPageScrollControllerLeaveTopNotifition object:nil];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                self.pageController.segmentControl.mj_y = 64 - 45;
                self.pageController.baseScrollView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
            }];
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.pageController.baseScrollView) {
        self.tableView.scrollEnabled = NO;
    }else { }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.tableView.scrollEnabled = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageController.baseScrollView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDeceleratingScroll:)]) {
            [_delegate scrollViewDeceleratingScroll:scrollView];
        }
    }
}
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.itemNameArr.count > 0) {
        [cell.contentView addSubview:self.pageContentView];
        self.pageContentView.segmentedControl.sectionTitles = self.itemNameArr;
        self.pageContentView.segmentedControl.sectionDescTitles = self.itemDescNameArr;
        if (_currentIndex > 0) {
            _currentIndex -= 1;
        }
        self.pageContentView.lastSelectedIndex = _currentIndex;
        self.pageContentView.segmentScrollView.contentOffset = CGPointMake(_currentIndex * SCREENWIDTH, 0);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
#pragma mark 监听通知事件
- (void)loginOut {
    [self.tableView.mj_header beginRefreshing];
}
- (void)updataAfterLogin {
    [self.tableView.mj_header beginRefreshing];
}
- (void)phoneNumberLogin {
    [self.tableView.mj_header beginRefreshing];
}







@end



























































































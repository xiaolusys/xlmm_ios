//
//  JMHomeRootController.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeRootController.h"
#import "MMClass.h"
#import <RESideMenu.h>
#import "JMAutoLoopScrollView.h"
#import "JMHomeHeaderView.h"
#import "JMHomeActiveCell.h"
#import "JMHomeCategoryCell.h"
#import "JMHomeGoodsCell.h"
#import "WebViewController.h"
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "HMSegmentedControl.h"
#import "JMRootGoodsModel.h"
#import "JMSegmentView.h"
#import "JMHomeCollectionController.h"
#import "JMHomeYesterdayController.h"
#import "JMHomeTomorrowController.h"
#import "JMMainTableView.h"

@interface JMHomeRootController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,JMAutoLoopScrollViewDatasource,JMAutoLoopScrollViewDelegate>

@property (nonatomic, strong) JMMainTableView *tableView;
@property (nonatomic, strong) JMAutoLoopScrollView *goodsScrollView;

@property (nonatomic, strong) NSMutableArray *activeArray;


@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *DataSource;

@property (nonatomic, strong) JMSegmentView *segmentView;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMHomeRootController {
    NSMutableArray *_topImageArray;
    NSMutableArray *_categorysArray;
    
    BOOL _loginRequired;                  // ??????
    NSMutableDictionary *_webDiction;
//    NSArray *_buttonTitleArr;
    NSInteger _currentIndex;              // 选择展示第几个视图 (昨,今,明)
//    NSString *_nextPage;                 // 下一页数据
    
    NSArray *_yestodayArr;
    NSArray *_todayArr;
    NSArray *_tomorrowArr;
    
}
- (NSMutableArray *)DataSource {
    if (_DataSource == nil) {
        _DataSource = [NSMutableArray array];
    }
    return _DataSource;
}
- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}
//- (void)createPullFooterRefresh {
//    kWeakSelf
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _isLoadMore = YES;
//        [weakSelf loadMoreData];
//    }];
//}
//- (void)endRefresh {
//    if (_isLoadMore) {
//        _isLoadMore = NO;
//        [self.tableView.mj_footer endRefreshing];
//    }
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMessage:) name:@"leaveTop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick:)];
    
//    _buttonTitleArr = @[@"昨日热卖",@"今日特卖",@"即将上新"];
    
    _topImageArray = [NSMutableArray array];
    _categorysArray = [NSMutableArray array];
    [self createNavigaView];
    [self createTabelView];
    [self loadActiveData];
//    [self loadDataSource];
//    [self createPullFooterRefresh];
    
}

//- (void)loadDataSource {
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/today?page=1&page_size=10",Root_URL];
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject) return;
//        [self fetchGoodsInfo:responseObject];
//    } WithFail:^(NSError *error) {
//    } Progress:^(float progress) {
//        
//    }];
//    
//}
//- (void)fetchGoodsInfo:(NSDictionary *)goodsDic {
//    _nextPage = goodsDic[@"next"];
//    NSArray *resultsArr = goodsDic[@"results"];
//    for (NSDictionary *dic in resultsArr) {
//        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
////        [self.todayDataSource addObject:model];
//    }
//}
//- (void)loadMoreData {
//    if ([_nextPage class] == [NSNull class]) {
//        [self endRefresh];
//        [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
//        return;
//    }
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPage WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject) return;
//        [self fetchGoodsInfo:responseObject];
//        [self endRefresh];
//    } WithFail:^(NSError *error) {
//        [self endRefresh];
//    } Progress:^(float progress) {
//    }];
//}

- (void)createTabelView {
    self.tableView = [[JMMainTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JMHomeActiveCell class] forCellReuseIdentifier:JMHomeActiveCellIdentifier];
    [self.tableView registerClass:[JMHomeCategoryCell class] forCellReuseIdentifier:JMHomeCategoryCellIdentifier];
    [self.tableView registerClass:[JMHomeGoodsCell class] forCellReuseIdentifier:JMHomeGoodsCellIdentifier];
    
    JMAutoLoopScrollView *scrollView = [[JMAutoLoopScrollView alloc] initWithStyle:JMAutoLoopScrollStyleHorizontal];
    self.goodsScrollView = scrollView;
    scrollView.jm_scrollDataSource = self;
    scrollView.jm_scrollDelegate = self;
    
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 120);
    
    scrollView.jm_isStopScrollForSingleCount = YES;
    scrollView.jm_autoScrollInterval = 3.;
    [scrollView jm_registerClass:[JMHomeHeaderView class]];
    self.tableView.tableHeaderView = scrollView;
    
    
    
    
}
- (void)createNavigaView {
//    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
//    naviView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:naviView];
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 83, 44)];
    UIImageView *titleImage = [UIImageView new];
    titleImage.image = [UIImage imageNamed:@"name"];
    [naviView addSubview:titleImage];
    self.navigationItem.titleView = naviView;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(naviView.mas_centerX);
        make.centerY.equalTo(naviView.mas_centerY);
        make.width.mas_equalTo(@83);
        make.height.mas_equalTo(@20);
    }];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles"]];
    leftImageview.frame = CGRectMake(0, 11, 26, 26);
    [leftButton addSubview:leftImageview];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category"]];
    rightImageview.frame = CGRectMake(18, 11, 26, 26);
    [rightButton addSubview:rightImageview];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)loadActiveData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/portal", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:self WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchActive:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchActive:(NSDictionary *)dic {
    // 头部滚动视图
    NSArray *postersArr = dic[@"posters"];
    for (NSDictionary *dic in postersArr) {
        [_topImageArray addObject:dic];
    }
    NSArray *categoryArr = dic[@"categorys"];
    for (NSDictionary *dicts in categoryArr) {
        [_categorysArray addObject:dicts[@"cat_img"]];
    }
    NSArray *activeArr = dic[@"activitys"];
    for (NSDictionary *dict in activeArr) {
        [self.activeArray addObject:dict];
    }
    
    [self.goodsScrollView jm_reloadData];
    [self.tableView reloadData];
    
}
#pragma mark tableView 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.activeArray.count;
    }else {
        return 1;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }else if (section == 1){
//        return 0;
//    }else {
//        return 0;
//    }
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
//    sectionView.backgroundColor = [UIColor whiteColor];
//    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
//    buttonView.layer.masksToBounds = YES;
//    buttonView.layer.borderWidth = 0.5;
//    buttonView.layer.borderColor = [UIColor lineGrayColor].CGColor;
//    
//    [sectionView addSubview:buttonView];
//    for (int i = 0; i < _buttonTitleArr.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(i * SCREENWIDTH / 3, 0, SCREENWIDTH / 3, 35);
//        button.titleLabel.font =  [UIFont systemFontOfSize: 14];
//        [button setTitle:_buttonTitleArr[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateSelected];
//        button.tag = 100 + i;
//        [button addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        [buttonView addSubview:button];
//        if (button.tag == 101) {
//            button.selected = YES;
//        }
//    }
//
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 45)];
//    timeLabel.font = [UIFont systemFontOfSize:13.];
//    timeLabel.textColor = [UIColor orangeColor];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.text = @"距本场结束还有16时16分16秒";
//    [sectionView addSubview:timeLabel];
//    
//    return sectionView;
//}
//- (void)titleBtnClickAction:(UIButton *)button {
//    NSLog(@"%ld",(long)button.tag);
//    NSInteger index = button.tag - 100;
//    
//    for (int i = 0 ; i < _buttonTitleArr.count; i++) {
//        NSInteger j = 100 + i;
//        UIButton *btni = (UIButton *)[self.view viewWithTag:j];
//        if (i == index) {
//            btni.selected = YES;
//        }else {
//            btni.selected = NO;
//        }
//    }
//    
//    
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else if (indexPath.section == 1) {
        return SCREENWIDTH * 0.5 + 10;
    }else if (indexPath.section == 2) {
        return SCREENHEIGHT - 64;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeCategoryCellIdentifier];
        if (!cell) {
            cell = [[JMHomeCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeCategoryCellIdentifier];
        }
        cell.imageArray = _categorysArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
//        JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
        JMHomeActiveCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activeDic = _activeArray[indexPath.row];
        return cell;
    }else {
        JMHomeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeGoodsCellIdentifier];
        if (!cell) {
            cell = [[JMHomeGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeGoodsCellIdentifier];
        }
        [cell.contentView addSubview:self.setPageViewControllers];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)skipWebView:(NSString *)title WebDic:(NSDictionary *)dic{
    WebViewController *huodongVC = [[WebViewController alloc] init];
    _webDiction = [NSMutableDictionary dictionary];
    _webDiction[@"type_title"] = @"active";
    _webDiction[@"activity_id"] = dic[@"id"];
    _webDiction[@"web_url"] = dic[@"act_link"];
    huodongVC.webDiction = _webDiction;
    huodongVC.isShowNavBar = true;
    huodongVC.isShowRightShareBtn = true;
    huodongVC.titleName = dic[@"title"];
    [self.navigationController pushViewController:huodongVC animated:YES];
}
#pragma mark 添加pageViewController
- (UIView *)setPageViewControllers {
    if (!_segmentView) {
        JMHomeYesterdayController *yesterdayVC = [[JMHomeYesterdayController alloc] init];
        JMHomeCollectionController *todayVC = [[JMHomeCollectionController alloc] init];
        JMHomeTomorrowController *tomorrowVC = [[JMHomeTomorrowController alloc] init];
        
        NSArray *controllers = @[yesterdayVC,todayVC,tomorrowVC];
        NSArray *titleArray = @[@"昨日热卖",@"今日特卖",@"即将上新"];//@[@"yesterday",@"today",@"tomorrow"];
        
        self.segmentView = [[JMSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) Controllers:controllers TitleArray:titleArray PageController:self];
    }
    return _segmentView;
}

-(void)scrollMessage:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"isCanScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [self.tableView rectForSection:2].origin.y - 64;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTop" object:nil userInfo:@{@"isCanScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}
#pragma mark 左滑进入个人中心界面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((scrollView.contentInset.left < 0) && velocity.x < 0) {
        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil withObject:self];
    }
}
- (void)rightNavigationClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - LPAutoScrollViewDatasource
- (NSUInteger)jm_numberOfNewViewInScrollView:(JMAutoLoopScrollView *)scrollView {
    return _topImageArray.count;
}
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView newViewIndex:(NSUInteger)index forRollView:(JMHomeHeaderView *)rollView {
    rollView.topDic = _topImageArray[index];
}
#pragma mark LPAutoScrollViewDelegate
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didSelectedIndex:(NSUInteger)index {
    NSLog(@"%@", _topImageArray[index]);
    [MobClick event:@"banner_click"];
    NSDictionary *topDic = _topImageArray[index];
    [JumpUtils jumpToLocation:topDic[@"app_link"] viewController:self];
}
- (void)backClick:(UIButton *)button {
}


@end

































































































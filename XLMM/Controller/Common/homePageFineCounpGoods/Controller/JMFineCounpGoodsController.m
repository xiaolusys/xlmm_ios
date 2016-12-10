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
#import "JMHomeActiveCell.h"
#import "JMAutoLoopPageView.h"
#import "JMHomeHeaderCell.h"
#import "JumpUtils.h"
#import "JMLogInViewController.h"
#import "WebViewController.h"


@interface JMFineCounpGoodsController () <UITableViewDelegate,UITableViewDataSource,JMAutoLoopPageViewDataSource,JMAutoLoopPageViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMAutoLoopPageView *pageView;
@property (nonatomic, strong) NSMutableArray *topImageSource;
@property (nonatomic, strong) NSMutableArray *activeSource;
@property (nonatomic, strong) NSMutableDictionary *webDic;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
@property (nonatomic,strong) UIButton *topButton;

@end



@implementation JMFineCounpGoodsController

- (NSMutableDictionary *)webDic {
    if (!_webDic) {
        _webDic = [NSMutableDictionary dictionary];
    }
    return _webDic;
}
- (NSMutableArray *)topImageSource {
    if (!_topImageSource) {
        _topImageSource = [NSMutableArray array];
    }
    return _topImageSource;
}
- (NSMutableArray *)activeSource {
    if (!_activeSource) {
        _activeSource = [NSMutableArray array];
    }
    return _activeSource;
}
- (JMAutoLoopPageView *)pageView {
    if (!_pageView) {
        _pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 0.4)];
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
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
//        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadActiveData];
    }];
}

- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    
    [self createTableView];
    [self createTopButton];
    [self createPullHeaderRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    
}
#pragma mark 获取活动,分类,滚动视图网络请求
- (void)loadActiveData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/portal?category=jingpin", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:self WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.topImageSource removeAllObjects];
        [self.activeSource removeAllObjects];
        [self fetchActive:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
- (void)fetchActive:(NSDictionary *)dic {
    NSArray *postersArr = dic[@"posters"];
    for (NSDictionary *dic in postersArr) {
        [self.topImageSource addObject:dic];
    }
    [self.pageView reloadData];
    
    NSArray *activeArr = dic[@"activitys"];
    for (NSDictionary *dict in activeArr) {
        JMHomeActiveModel *model = [JMHomeActiveModel mj_objectWithKeyValues:dict];
        [self.activeSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 113) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = SCREENWIDTH * 0.5 + 10;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JMHomeActiveCell class] forCellReuseIdentifier:JMHomeActiveCellIdentifier];
    self.tableView.tableHeaderView = self.pageView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
    if (!cell) {
        cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.activeSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"ROOT_activitys"];
    JMHomeActiveModel *model = self.activeSource[indexPath.row];
    NSDictionary *dic = model.mj_keyValues;
    NSString *appLink = model.act_applink;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self skipWebView:appLink activeDic:dic];
    }else {
        if ([model.login_required boolValue]) {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else {
            [self skipWebView:appLink activeDic:dic];
        }
    }
}
- (void)skipWebView:(NSString *)appLink activeDic:(NSDictionary *)dic {
    if(appLink.length == 0){
        WebViewController *huodongVC = [[WebViewController alloc] init];
        NSString *active = @"active";
        [self.webDic setValue:active forKey:@"type_title"];
        [self.webDic setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
        [self.webDic setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
        huodongVC.webDiction = self.webDic;
        huodongVC.isShowNavBar = true;
        huodongVC.isShowRightShareBtn = true;
        huodongVC.titleName = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:huodongVC animated:YES];
    }else{
        [JumpUtils jumpToLocation:appLink viewController:self];
    }
}


#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return self.topImageSource.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMHomeHeaderCell *testCell = cell;
    NSDictionary *dict = self.topImageSource[index];
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
    NSDictionary *topDic = self.topImageSource[index];
    [JumpUtils jumpToLocation:topDic[@"app_link"] viewController:self];
}


#pragma mark -- 添加返回顶部按钮
- (void)createTopButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.height.mas_equalTo(@50);
    }];
    //    self.topButton.frame = CGRectMake(SCREENWIDTH - 70, SCREENHEIGHT - 70, 50, 50);
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    self.topButton.hidden = YES;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[JMGlobal global] clearAllSDCache];
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







































































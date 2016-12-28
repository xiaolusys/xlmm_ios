//
//  JMHomeRootController.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeRootController.h"
#import <RESideMenu.h>
#import "JMHomeActiveCell.h"
#import "JMHomeCategoryCell.h"
#import "JMHomeGoodsCell.h"
#import "WebViewController.h"
#import "JMLogInViewController.h"
#import "JumpUtils.h"
#import "JMRootGoodsModel.h"
#import "JMSegmentView.h"
#import "JMHomeCollectionController.h"
#import "JMHomeYesterdayController.h"
#import "JMHomeTomorrowController.h"
#import "JMMainTableView.h"
#import "JMStoreupController.h"
#import "JMPopViewAnimationSpring.h"
#import "JMRepopView.h"
#import "JMUpdataAppPopView.h"
#import "AppDelegate.h"
#import "MJPullGifHeader.h"
#import "JMClassifyListController.h"
#import "JMHomeActiveModel.h"
#import "JMAutoLoopPageView.h"
#import "JMHomeHeaderCell.h"
#import "JMHomeRootCategoryController.h"
#import "JMStoreManager.h"
#import "JMLaunchView.h"
#import "JMCartViewController.h"
#import "JMGoodsCountTime.h"
#import "CSTabBarController.h"
#import "JMChildViewController.h"


static BOOL isFirstPOP = YES;

@interface JMHomeRootController ()<JMHomeCategoryCellDelegate,JMUpdataAppPopViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,JMAutoLoopPageViewDataSource,JMAutoLoopPageViewDelegate> {
    NSTimer *_cartTimer;            // 购物定时器
    NSString *_cartTimeString;      // 购物车时间
    NSInteger oneRowCellH;
    NSInteger twoRowCellH;
    NSString *_dayDifferString;     // 上架时间与结束时间相差天数
    NSMutableArray *_topImageArray;     // 主页头部滚动视图数据
    NSMutableArray *_categorysArray;    // 主页分类数据
    NSMutableArray *flageArr;           // 判断商品请求是否加载完成的标志
    NSArray *_urlArray;                 // 商品url -> (昨天,今天,明天)
    BOOL isCreateSegment;               // 商品请求是否全部完成
    NSMutableArray *_timeArray;         // 商品结束(开始)时间参数
    NSMutableDictionary *_webDict;      // webView需要的一些参数
    BOOL _isFirstOpenApp;               // 判断是否是第一次打开
    NSString *_releaseNotes;            // 版本升级信息
    NSString *_hash;                    // 判断是否需要重新下载的哈希值
    NSString *_downloadURLString;       // 地址下载链接
    NSString *urlCategory;              // 下载分类json文件
}
/**
 *  主页tableView,活动数据源,顶部商品滚动视图,自定义cell上添加的segment
 */
@property (nonatomic, strong) JMMainTableView *tableView;
@property (nonatomic, strong) NSMutableArray *activeArray;
@property (nonatomic, strong) JMSegmentView *segmentView;
/**
 *  主页视图滚动位置判断
 */
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
@property (nonatomic, strong) JMHomeYesterdayController *yesterdayVC;
@property (nonatomic, strong) JMHomeCollectionController *todayVC;
@property (nonatomic, strong) JMHomeTomorrowController *tomorrowVC;
/**
 *  返回顶部按钮,购物车视图,导航视图,弹出视图
 */
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *navRightButton;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) JMRepopView *popView;
/**
 *  版本更新弹出视图
 */
@property (nonatomic, strong) JMUpdataAppPopView *updataPopView;
/**
 *  是否弹出更新视图
 */
@property (nonatomic, assign) BOOL isPopUpdataView;
@property (nonatomic, copy) NSString *latestVersion;
@property (nonatomic, copy) NSString *trackViewUrl1;
@property (nonatomic, copy) NSString *trackName;

@property (nonatomic, strong) JMAutoLoopPageView *pageView;
@property (nonatomic, strong) JMLaunchView *launchView;
@end

@implementation JMHomeRootController

- (JMUpdataAppPopView *)updataPopView {
    if (_updataPopView == nil) {
        _updataPopView = [JMUpdataAppPopView defaultUpdataPopView];
    }
    return _updataPopView;
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
    }
    return _maskView;
}
- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [JMGoodsCountTime initCountDownWithCurrentTime:0];
    [MBProgressHUD hideHUD];
//    [self endAutoScroll];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.cartsCountLabel.hidden = YES;
//    self.pageView.atuoLoopScroll = YES;
//    if (self.pageView) {
//        [self.pageView reloadData];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMessage:) name:@"leaveTop" object:nil];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rootViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rootViewDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:app];
    
    [MobClick beginLogPageView:@"main"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.pageView) {
        [self.pageView endAutoScroll];
    }
    [MobClick endLogPageView:@"main"];
}
- (void)didReceiveMemoryWarning {
    [[JMGlobal global] clearAllSDCache];
}
- (void)rootViewDidEnterBackground:(NSNotification *)notification {
    [self hideUpdataView];
}
- (void)rootViewWillEnterForeground:(NSNotification *)notification {
    [self autoUpdateVersion];
    if (self.isPopUpdataView == YES) {
        [self performSelector:@selector(updataAppPopView) withObject:nil afterDelay:10.0f];
    }else {
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *someDayDate = [dateFormatter dateFromString:currentTime];
    NSString *timeString = _timeArray[1];
    _dayDifferString = [NSString stringWithFormat:@"%ld",[_dayDifferString integerValue] - 2];
    if ([NSString isStringEmpty:timeString] || [timeString isEqual:@"00:00:00"]) {
        [self.tableView.mj_header beginRefreshing];
    }else {
        NSDate *date = [dateFormatter dateFromString:[NSString jm_deleteTimeWithT:timeString]]; // 结束时间
        NSTimeInterval time=[date timeIntervalSinceDate:someDayDate];  //结束时间距离当前时间的秒数
        int timer = time;
        NSString *timeStr = [NSString stringWithFormat:@"%d",timer / (3600 * 24)];
        if ([timeStr compare:_dayDifferString options:NSNumericSearch] == NSOrderedAscending || [timeStr isEqualToString:_dayDifferString]) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    _dayDifferString = @"2";
    _urlArray = @[@"yesterday",@"today",@"tomorrow"];
    flageArr = [NSMutableArray arrayWithObjects:@0,@0,@0, nil];
    _topImageArray = [NSMutableArray array];
    _categorysArray = [NSMutableArray array];
    _timeArray = [NSMutableArray arrayWithObjects:@"00:00:00",@"00:00:00",@"00:00:00", nil];
    self.isPopUpdataView = NO;
    _isFirstOpenApp = [JMStoreManager isFirstLoadApp]; // 判断程序是否第一次打开5
    //订阅展示视图消息，将直接打开某个分支视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginOut) name:@"logout" object:nil];
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(setLabelNumber) name:@"logout" object:nil];
    
    UIImage *launchImage = [JMStoreManager getDataImage:@"launchImageCache" Quality:0.];
    self.launchView = [JMLaunchView initImageWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) Image:launchImage TimeSecond:3. HideSkip:YES LaunchAdClick:^{
    } TimeEnd:^{
    }];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.launchView];
    
    [self loginUpdateIsXiaoluMaMa];                    // 拿到用户的登录信息与个人信息
    [self createNavigaView];                           // 创建自定义导航控制器
    [self createTabelView];                            // 创建tableView
//    [self createCartsView];                            // 创建购物车
    [self createTopButton];                            // 创建返回顶部按钮
    //    [self loadActiveData];                             // 获取活动,分类,滚动视图网络请求
    [self createPullHeaderRefresh];                    // 下拉刷新,重新获取商品展示数据
    [self.tableView.mj_header beginRefreshing];        // 刚进入主页刷新数据
    [self autoUpdateVersion];                          // 版本自动升级
    [self loadItemizeData];                            // 获取商品分类
    [self loadAddressInfo];                            // 获得地址信息请求
    self.session = [self backgroundSession];           // 后台下载...
    if (_isFirstOpenApp && isFirstPOP) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(returnPopView) userInfo:nil repeats:NO];
    }else {
    }
    
    
}
#pragma mark 通知事件
- (void)presentView:(NSNotification *)notification{
    //跳转到新的页面
    [JumpUtils jumpToLocation:[notification.userInfo objectForKey:@"target_url"] viewController:self];
}
- (void)updataAfterLogin:(NSNotification *)notification{
    // 微信登录
    [self loginUpdateIsXiaoluMaMa];
}
- (void)phoneNumberLogin:(NSNotification *)notification{
    //  NSLog(@"手机登录");
    [self loginUpdateIsXiaoluMaMa];
}
- (void)loginOut {
    self.navigationItem.rightBarButtonItem = nil;
}
//- (void)setLabelNumber {
//    [self loadCatrsNumData];
//}
// 登录后请求个人信息,这里可以保存下来个人信息
- (BOOL)isXiaolumama{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isXLMM = [users boolForKey:kISXLMM];
    return isXLMM;
}
- (BOOL)isLogin {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isLog = [users boolForKey:kIsLogin];
    return isLog;
}
- (void)loginUpdateIsXiaoluMaMa {
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        if ([self isLogin]) {
            if ([self isXiaolumama]) {
                [self createRightItem];
            }else {
                self.navigationItem.rightBarButtonItem = nil;
            }
            [self performSelector:@selector(isGetCoupon) withObject:nil afterDelay:2.0];
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } failure:^(NSError *error) {
        self.navigationItem.rightBarButtonItem = nil;
    }];
}

#pragma mark 商品展示网络请求
- (void)loadData:(NSString *)string {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/%@?page=1&page_size=10",Root_URL,string];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject) {
            if ([string isEqualToString:@"yesterday"]) {
                flageArr[0] = @1;
                self.yesterdayVC.dataDict = responseObject;
                _timeArray[0] = responseObject[@"offshelf_deadline"];
            }else if ([string isEqualToString:@"today"]) {
                flageArr[1] = @1;
                self.todayVC.dataDict = responseObject;
                _timeArray[1] = responseObject[@"offshelf_deadline"];
                _dayDifferString = [NSString numberOfDaysWithFromDate:responseObject[@"onshelf_starttime"] ToData:responseObject[@"offshelf_deadline"]];
            }else {
                flageArr[2] = @1;
                self.tomorrowVC.dataDict = responseObject;
                _timeArray[2] = responseObject[@"offshelf_deadline"];
            }
            isCreateSegment = ([flageArr[0] isEqual: @1]) && ([flageArr[1] isEqual:@1]) && ([flageArr[2] isEqual:@1]);
            if (isCreateSegment) {
                [self endRefresh];
                //                [self.tableView reloadData];
                //                [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                self.segmentView.timeArray = [NSArray arrayWithArray:_timeArray];
            }
        }else {
        }
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    MJAnimationHeader *header = [MJAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    //    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}
- (void)refreshView {
    _isPullDown = YES;
    [self loadActiveData];
    for (int i = 0; i < _urlArray.count; i++) {
        [self loadData:_urlArray[i]];
    }
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark 创建tableView
- (void)createTabelView {
    
    oneRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 + 30;
    twoRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 * 2 + 30 + HomeCategorySpaceH;
    
    self.tableView = [[JMMainTableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 113) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JMHomeActiveCell class] forCellReuseIdentifier:JMHomeActiveCellIdentifier];
    [self.tableView registerClass:[JMHomeCategoryCell class] forCellReuseIdentifier:JMHomeCategoryCellIdentifier];
    [self.tableView registerClass:[JMHomeGoodsCell class] forCellReuseIdentifier:JMHomeGoodsCellIdentifier];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
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
- (void)endAutoScroll {
    self.pageView.atuoLoopScroll = NO;
    [self.pageView endAutoScroll];
}
#pragma mark 创建自定义 navigationView
- (void)createNavigaView {
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
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles"]];
//    leftImageview.frame = CGRectMake(0, 11, 26, 26);
//    [leftButton addSubview:leftImageview];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}
- (void)createRightItem {
    if(self.navigationItem.rightBarButtonItem == nil) {
        NSString *titleStr = @"我的微店";
        CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
        self.navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
        [self.navRightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navRightButton setTitle:titleStr forState:UIControlStateNormal];
        [self.navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.navRightButton.titleLabel.font = [UIFont systemFontOfSize:14.];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    }else {}
}
#pragma mark 获取活动,分类,滚动视图网络请求
- (void)loadActiveData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/portal", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:self WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [_topImageArray removeAllObjects];
        [_categorysArray removeAllObjects];
        [self.activeArray removeAllObjects];
        [self fetchActive:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchActive:(NSDictionary *)dic {
    NSArray *postersArr = dic[@"posters"];
    for (NSDictionary *dic in postersArr) {
        [_topImageArray addObject:dic];
    }
    [self.pageView reloadData];
    NSArray *categoryArr = dic[@"categorys"];
    for (NSDictionary *dicts in categoryArr) {
        [_categorysArray addObject:dicts];
    }
    [JMStoreManager removeFileByFileName:@"categorysArray.xml"];
    [JMStoreManager saveDataFromArray:@"categorysArray.xml" WithArray:_categorysArray];
    
    NSArray *activeArr = dic[@"activitys"];
    for (NSDictionary *dict in activeArr) {
        JMHomeActiveModel *model = [JMHomeActiveModel mj_objectWithKeyValues:dict];
        [self.activeArray addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark UITableViewDataSource,UITableViewDelegate
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_categorysArray.count <= 4) {
            return oneRowCellH;
        }else {
            return twoRowCellH;
        }
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
        JMHomeCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[JMHomeCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeCategoryCellIdentifier];
        }
        cell.imageArray = _categorysArray;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
        if (!cell) {
            cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.activeArray[indexPath.row];
        return cell;
    }else {
        JMHomeGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[JMHomeGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeGoodsCellIdentifier];
        }
        [cell.contentView addSubview:self.setPageViewControllers];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [MobClick event:@"ROOT_activitys"];
        JMHomeActiveModel *model = self.activeArray[indexPath.row];
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
    }else {}
}
#pragma mark 分类点击事件
- (void)composeCategoryCellTapView:(JMHomeCategoryCell *)categoryCellView ParamerStr:(NSDictionary *)paramerString {
    JMChildViewController *categoryVC = [[JMChildViewController alloc] init];
    NSString *parStr = paramerString[@"cat_link"];
    if (![parStr hasPrefix:@"com.jimei.xlmm://app/v1/products/category?"]){
        NSLog(@"jump cat_link=%@ wrong", parStr);
        return;
    }
    NSArray *array = [parStr componentsSeparatedByString:@"="];
    NSString *string = array[1];
    categoryVC.titleString = paramerString[@"name"];
    categoryVC.categoryCid = string;
    categoryVC.categoryUrlString = urlCategory;
    [self.navigationController pushViewController:categoryVC animated:YES];
}
#pragma mark 活动点击事件(跳转webView)
- (void)skipWebView:(NSString *)appLink activeDic:(NSDictionary *)dic {
    if(appLink.length == 0){
        WebViewController *huodongVC = [[WebViewController alloc] init];
        NSString *active = @"active";
        _webDict = [NSMutableDictionary dictionary];
        [_webDict setValue:active forKey:@"type_title"];
        [_webDict setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
        [_webDict setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
        huodongVC.webDiction = _webDict;
        huodongVC.isShowNavBar = true;
        huodongVC.isShowRightShareBtn = true;
        huodongVC.titleName = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:huodongVC animated:YES];
    }else{
        [JumpUtils jumpToLocation:appLink viewController:self];
    }
}
#pragma mark 添加segmentViewController
- (UIView *)setPageViewControllers {
    if (!_segmentView) {
        self.yesterdayVC = [[JMHomeYesterdayController alloc] init];
        self.todayVC = [[JMHomeCollectionController alloc] init];
        self.tomorrowVC = [[JMHomeTomorrowController alloc] init];
        NSArray *collectionArr = @[self.yesterdayVC,self.todayVC,self.tomorrowVC];
        NSArray *titleArray = @[@"昨日热卖",@"今日特卖",@"即将上新"];//@[@"yesterday",@"today",@"tomorrow"];
        self.segmentView = [[JMSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) Controllers:collectionArr TitleArray:titleArray PageController:self];
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
    CGFloat tabOffsetY = [self.tableView rectForSection:2].origin.y;
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
- (void)rightNavigationClick:(UIButton *)button {
    [MBProgressHUD showLoading:@""];
    button.enabled = NO;
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    BOOL isXLMM = [[NSUserDefaults standardUserDefaults] boolForKey:kISXLMM];
    if (isLogin) {
        if (isXLMM) {
            [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:1.0f];
            //            JMMaMaRootController *mamaCenterVC = [[JMMaMaRootController alloc] init];
            //            [self.navigationController pushViewController:mamaCenterVC animated:YES];
            CSTabBarController * tabBarVC = [[CSTabBarController alloc] init];
            JMKeyWindow.rootViewController = tabBarVC;
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不是小鹿妈妈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }else {
        JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return _topImageArray.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMHomeHeaderCell *testCell = cell;
    NSDictionary *dict = _topImageArray[index];
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

#pragma mark 返回顶部按钮
- (void)createTopButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
//        make.centerY.equalTo(self.cartView.mas_centerY);
        make.bottom.equalTo(self.view).offset(-64);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    [self comeToTop];
    [self performSelector:@selector(waitTopButton) withObject:nil afterDelay:0.1f];
}
- (void)waitTopButton {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top - 1;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}
- (void)comeToTop {
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
}
#pragma mark 返回顶部按钮显示/隐藏  KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = self.tableView.contentOffset.y;
        self.topButton.hidden = offsetY > SCREENHEIGHT * 2 ? NO : YES;
    }
}
#pragma mark -- 判断用户是否领取优惠券
- (void)isGetCoupon {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/is_picked_register_gift_coupon", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            NSInteger isPicked = [responseObject[@"is_picked"] integerValue];
            if (code == 0) {
                if (isPicked == 0) {  // 服务端返回是否弹出首次使用APP字段
                    [self returnPopView];
                }else {
                    //                    [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                }
            }else {
                [MBProgressHUD showError:@"请登录"];
            }
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)pickCoupon {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_register_gift_coupon", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [MBProgressHUD showSuccess:responseObject[@"info"]];
            }else {
                [MBProgressHUD showError:@"领取失败"];
            }
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)hidepopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
}
#pragma mark --- 第一次打开程序
- (void)returnPopView {
    isFirstPOP = NO;
    JMHomeRootController * __weak weakSelf = self;
    [[JMGlobal global] showpopForReceiveCouponFrame:CGRectMake(0, 0, SCREENWIDTH *0.7 , (SCREENWIDTH * 0.7) * 1.3 + 60) WithBlock:^(UIView *maskView) {
    } ActivePopBlock:^(UIButton *button) {
        [JMShareView hide];
        [JMRepopView hide];
        if (button.tag == 100) {
            [weakSelf pockedCoupon];
        }else {
        }
    }];
}
- (void)pockedCoupon {
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/is_picked_register_gift_coupon", Root_URL];
        [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
            if (responseObject == nil) {
                return ;
            }else {
                NSInteger code = [responseObject[@"code"] integerValue];
                NSInteger isPicked = [responseObject[@"is_picked"] integerValue];
                if (code == 0) {
                    if (isPicked == 1) {
                        [MBProgressHUD showSuccess:responseObject[@"info"]];
                    }else {
                        [self pickCoupon];
                    }
                }else {
                    [MBProgressHUD showError:@"请登录"];
                }
            }
        } WithFail:^(NSError *error) {
        } Progress:^(float progress) {
        }];
    }else {
        JMLogInViewController *logVC = [[JMLogInViewController alloc] init];
        [self.navigationController pushViewController:logVC animated:YES];
    }
}
#pragma mark 版本 自动升级
- (void)autoUpdateVersion{
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:UPDATE_URLSTRING WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self fetchedUpdateData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchedUpdateData:(NSDictionary *)appInfoDic{
    NSArray *reluts = [appInfoDic objectForKey:@"results"];
    if ([reluts count] == 0) return;
    NSDictionary *infoDic = reluts[0];
    self.latestVersion = [infoDic objectForKey:@"version"];
    self.trackViewUrl1 = [infoDic objectForKey:@"trackViewUrl"];//地址trackViewUrl
    self.trackName = [infoDic objectForKey:@"trackName"];//trackName
    _releaseNotes = [infoDic objectForKey:@"releaseNotes"];
    _releaseNotes = [NSString stringWithFormat:@"新版本升级信息：\n%@",_releaseNotes];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    double doubleCurrentVersion = [app_Version doubleValue];
    double doubleUpdateVersion = [self.latestVersion doubleValue];
    NSLog(@"Get app version store=%@ %f appversion=%@ %f ",self.latestVersion, doubleUpdateVersion,app_Version, doubleCurrentVersion);
    if ([self.latestVersion compare:app_Version options:NSNumericSearch] == NSOrderedDescending) {
        self.isPopUpdataView = YES;
    }else {
        self.isPopUpdataView = NO;
    }
}
- (void)updataAppPopView {
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideUpdataView)]];
    self.updataPopView.releaseNotes = _releaseNotes;
    self.updataPopView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.updataPopView];
    [JMPopViewAnimationSpring showView:self.updataPopView overlayView:self.maskView];
}
- (void)composeUpdataAppButton:(JMUpdataAppPopView *)updataButton didClick:(NSInteger)index {
    self.isPopUpdataView = NO;
    if (index == 100) {
        [self hideUpdataView];
    }else if (index == 101) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl1]];
        [self hideUpdataView];
    }else {
    }
}
- (void)hideUpdataView {
    [JMPopViewAnimationSpring dismissView:self.updataPopView overlayView:self.maskView];
}
#pragma mark - 获取商品分类列表
- (void)loadItemizeData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/categorys/latest_version",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self fetchItemize:responseObject];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchItemize:(NSDictionary *)dic {
    NSString *isUpData = dic[@"sha1"];
    urlCategory = dic[@"download_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [defaults stringForKey:@"itemHash"];
    if (oldVersion == nil) {
        [self downLoadUrl:urlCategory];
    }else {
        if ([oldVersion isEqualToString:isUpData] && [JMStoreManager isFileExist:@"GoodsItemFile.json"]) {
        }else {
            [self downLoadUrl:urlCategory];
        }
    }
    [defaults setObject:isUpData forKey:@"itemHash"];
    [defaults synchronize];
}
- (void)downLoadUrl:(NSString *)urlStr {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"默认下载地址%@",targetPath);
        [JMStoreManager removeFileByFileName:@"GoodsItemFile.json"];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
        return [NSURL fileURLWithPath:jsonPath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@---%@", response, filePath);
    }];
    // 5.启动下载任务
    [task resume];
}
#pragma mark 网络请求得到地址信息
- (void)loadAddressInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/districts/latest_version",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self addressData:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)addressData:(NSDictionary *)addressDic {
    _hash = addressDic[@"hash"];
    _downloadURLString = addressDic[@"download_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [defaults stringForKey:@"hash"];
    if (oldVersion == nil) {
        [self startDownload:_downloadURLString];
    }else {
        [oldVersion isEqualToString:_hash] && [JMStoreManager isFileExist:@"addressInfo.json"] ? : [self startDownload:_downloadURLString];
    }
    [defaults setObject:_hash forKey:@"hash"];
    [defaults synchronize];
}
#pragma mark -- 开始下载地址文件
- (void)startDownload:(id)downloadURLString {
    if (self.downloadTask) {
        return ;
    }
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}
- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"so.xiaolu.m.xiaolumeimei"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *addressPath = [JMStoreManager getFullPathWithFile:@"addressInfo.json"];
    NSURL *pathUrl = [NSURL fileURLWithPath:addressPath];
    NSError *errorCopy;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:pathUrl error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:location toURL:pathUrl error:nil];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //播放音乐
            self.player = [AVPlayer playerWithURL:pathUrl];
            [self.player play];
        });
    } else {
        NSLog(@"复制文件发生错误: %@", [errorCopy localizedDescription]);
    }
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        NSLog(@"任务: %@ 成功完成", task);
    } else {
        NSLog(@"任务: %@ 发生错误: %@", task, [error localizedDescription]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    self.downloadTask = nil;
}
#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    NSLog(@"所有任务已完成!");
}

#pragma mark ---------- dealloc ----------
- (void)dealloc {
    NSLog(@"dealloc 被调用");
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.pageView) {
        [self.pageView removeFromSuperview];
        self.pageView = nil;
    }
    
}

@end




/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *
 *                 神兽保佑
 *                 代码无BUG!
 */


























//- (void)timerFireMethod:(NSTimer*)thetimer {
//    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[_cartTimeString doubleValue]];
//    NSInteger unitFlags = NSCalendarUnitYear |
//    NSCalendarUnitMonth |
//    NSCalendarUnitDay |
//    NSCalendarUnitHour |
//    NSCalendarUnitMinute |
//    NSCalendarUnitSecond;
//    NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:lastDate options:0];
//    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
//    if ([d second] < 0) {
//
//        if ([_cartTimer isValid]) {
//            [_cartTimer invalidate];
//        }
//    }else { self.cartsCountLabel.text = string; }
//
//}





//- (void)backClick:(UIButton *)button {
//}
#pragma mark 购物车数量请求
//- (void)loadCatrsNumData {
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
//        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json",Root_URL];
//        [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//            if (!responseObject) return ;
////            [self cartViewUpData:responseObject];
//        } WithFail:^(NSError *error) {
//        } Progress:^(float progress) {
//        }];
//    }else {
//        self.cartsLabel.hidden = YES;
//        self.cartsCountLabel.hidden = YES;
//        self.navigationItem.rightBarButtonItem = nil;
//        [self.cartView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@44);
//        }];
//    }
//}
//- (void)cartViewUpData:(NSDictionary *)dic {
////    kWeakSelf
//    NSInteger cartNum = [dic[@"result"] integerValue];
//    if (cartNum == 0) {
////        [JMGoodsCountTime initCountDownWithCurrentTime:0];
//        //        [JMGoodsCountTime shareCountTime].timer = nil;
////        self.cartsLabel.hidden = YES;
////        self.cartsCountLabel.hidden = YES;
////        [self.cartView mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.width.mas_equalTo(@44);
////        }];
//    }else {
////        self.cartsLabel.hidden = NO;
////        self.cartsLabel.text = [NSString stringWithFormat:@"%@",dic[@"result"]];
////        [self.cartView mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.width.mas_equalTo(@108);
////        }];
////        self.cartsCountLabel.hidden = NO;
////        [self.cartsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.right.equalTo(weakSelf.cartView).offset(-15);
////            make.centerY.equalTo(weakSelf.cartView.mas_centerY);
////        }];
////        _cartTimeString = dic[@"last_created"];
////        [self createTimeLabel:[_cartTimeString intValue]];
//    }
//}
//- (void)createTimeLabel:(int)endSecond {
//    int end = [[JMGlobal global] secondOFCurrentTimeInEndtimeInt:endSecond];
//    [JMGoodsCountTime initCountDownWithCurrentTime:end];
//    kWeakSelf
//    [JMGoodsCountTime shareCountTime].countBlock = ^(int second) {
//        second == -1 ? [weakSelf endTime] : [weakSelf timeFormat:second];
//    };}
//- (void)endTime {
//    self.cartsCountLabel.text = @"";
//    self.cartsCountLabel.hidden = YES;
//    self.cartsLabel.hidden = YES;
//    [self.cartView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(@44);
//    }];
//}
//- (void)timeFormat:(int)end {
//    self.cartsCountLabel.text = [NSString TimeformatMSFromSeconds:end];
//}
#pragma mark 创建购物车,收藏按钮
//- (void)createCartsView {
//    kWeakSelf
//    UIView *collectionView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT - 113, 44, 44)];
//    [self.view addSubview:collectionView];
//    collectionView.backgroundColor = [UIColor blackColor];
//    collectionView.alpha = 0.8;
//    collectionView.layer.cornerRadius = 22;
//
//    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [collectionView addSubview:collectionButton];
//    [collectionButton setImage:[UIImage imageNamed:@"MyCollectionOrigin_Nomal"] forState:UIControlStateNormal];
//    collectionButton.frame = CGRectMake(0, 0, 44, 44);
//    collectionButton.layer.cornerRadius = 22;
//    [collectionButton addTarget:self action:@selector(gotoCollection:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.cartView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:self.cartView];
//    [self.cartView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view).offset(60);
//        make.centerY.equalTo(collectionView.mas_centerY);
//        make.width.mas_equalTo(@108);
//        make.height.mas_equalTo(@44);
//    }];
//    self.cartView.backgroundColor = [UIColor blackColor];
//    self.cartView.alpha = 0.8;
//    self.cartView.layer.cornerRadius = 22;
//    self.cartView.layer.borderWidth = 1;
//    self.cartView.layer.borderColor = [UIColor settingBackgroundColor].CGColor;
//    [self.cartView addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
//    iconView.image = [UIImage imageNamed:@"homeGoodsDetailCarts"];
//    iconView.userInteractionEnabled = NO;
//    [self.cartView addSubview:iconView];
//    self.cartsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, -6, 16, 16)];
//    [iconView addSubview:self.cartsLabel];
//    self.cartsLabel.font = [UIFont systemFontOfSize:10.];
//    self.cartsLabel.textColor = [UIColor whiteColor];
//    self.cartsLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
//    self.cartsLabel.textAlignment = NSTextAlignmentCenter;
//    self.cartsLabel.layer.cornerRadius = 8.;
//    self.cartsLabel.layer.masksToBounds = YES;
//    self.cartsLabel.hidden = YES;
//
//    self.cartsCountLabel = [UILabel new];
//    [self.cartView addSubview:self.cartsCountLabel];
//    self.cartsCountLabel.font = [UIFont systemFontOfSize:18.];
//    self.cartsCountLabel.textColor = [UIColor whiteColor];
//    self.cartsCountLabel.hidden = YES;
//
//}
#pragma mark 点击按钮进入购物车界面
//- (void)gotoCarts:(UIButton *)sender{
//    [MobClick event:@"cart_click"];
//    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
//    if (login) {
//        JMCartViewController *cartVC = [[JMCartViewController alloc] init];
//        [self.navigationController pushViewController:cartVC animated:YES];
//    }else {
//        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
//        [self.navigationController pushViewController:enterVC animated:YES];
//    }
//}
//#pragma mark 点击按钮进入我的收藏界面
//- (void)gotoCollection:(UIButton *)sender {
//    [MobClick event:@"storeUP_click"];
//    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
//    if (login == NO) {
//        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
//        [self.navigationController pushViewController:enterVC animated:YES];
//        return;
//    }
//    JMStoreupController *storeVC = [[JMStoreupController alloc] init];
//    storeVC.index = 100;
//    [self.navigationController pushViewController:storeVC animated:YES];
//}



#pragma mark 左滑进入个人中心界面
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    if ((scrollView.contentInset.left < 0) && velocity.x < 0) {
////        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil withObject:self];
//    }
//}
//- (void)rootVCPushOtherVC:(UIViewController *)vc{
//    if ([vc isKindOfClass:[CSTabBarController class]]) {
//        JMKeyWindow.rootViewController = vc;
//    }else {
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}













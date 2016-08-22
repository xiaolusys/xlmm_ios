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

@interface JMHomeRootController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,JMAutoLoopScrollViewDatasource,JMAutoLoopScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMAutoLoopScrollView *goodsScrollView;

@property (nonatomic, strong) NSMutableArray *activeArray;


@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation JMHomeRootController {
    NSMutableArray *_topImageArray;
    NSMutableArray *_categorysArray;
    
    BOOL _loginRequired;                  // ??????
    NSMutableDictionary *_webDiction;
    
    
}
- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick:)];
    
    _topImageArray = [NSMutableArray array];
    _categorysArray = [NSMutableArray array];
    [self createNavigaView];
    [self createTabelView];
    [self loadActiveData];
    
}
- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JMHomeActiveCell class] forCellReuseIdentifier:JMHomeActiveCellIdentifier];
    [self.tableView registerClass:[JMHomeCategoryCell class] forCellReuseIdentifier:JMHomeCategoryCellIdentifier];
    [self.tableView registerClass:[JMHomeGoodsCell class] forCellReuseIdentifier:JJMHomeGoodsCellIdentifier];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 0;
    }else {
        return 80;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else if (indexPath.section == 1){
        return 160;
    }else {
        return 600;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeCategoryCellIdentifier];
        cell.imageArray = _categorysArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activeDic = _activeArray[indexPath.row];
        return cell;
    }else {
        JMHomeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:JJMHomeGoodsCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [MobClick event:@"brand_click"];
        NSDictionary *activeDic = _activeArray[indexPath.row];
        _loginRequired = [activeDic[@"login_required"] boolValue];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
            [self skipWebView:@"active" WebDic:activeDic];
        } else{
            if (_loginRequired) {
                JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            } else{
                [self skipWebView:@"active" WebDic:activeDic];
            }
        }
    }else {
        
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

































































































//
//  JMHomeHourController.m
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeHourController.h"
#import "JMHomeHourCell.h"
#import "JMHomeHourModel.h"
#import "JMGoodsDetailController.h"
#import "JumpUtils.h"
#import "JMPushingDaysController.h"
#import "JMShareModel.h"
#import "JMShareViewController.h"


@interface JMHomeHourController () <UITableViewDelegate,UITableViewDataSource,JMHomeHourCellDelegate> {
    NSString *_nextPageUrl;
    NSMutableArray *_numArray;
}

//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) JMShareViewController *goodsShareView;
@property (nonatomic, strong) JMShareModel *shareModel;

@end

@implementation JMHomeHourController
#pragma mark 懒加载
- (JMShareViewController *)goodsShareView {
    if (!_goodsShareView) {
        _goodsShareView = [[JMShareViewController alloc] init];
    }
    return _goodsShareView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 60 - kAppTabBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 175.f;
        [_tableView registerClass:[JMHomeHourCell class] forCellReuseIdentifier:@"JMHomeHourCellIdentifier"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark 重写set方法
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMHomeHourController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMHomeHourController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self goodsShareView];
    [self.view addSubview:self.tableView];
}
#pragma mark 网络请求,数据处理
- (void)loadShareData:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        JMShareModel *shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        shareModel.share_type = @"link";
//        self.goodsShareView.isShowEarningValue = YES;
        self.goodsShareView.model = shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:340];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
    }];
}
- (void)loadSharDataWithHour:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        JMShareModel *shareModel = [[JMShareModel alloc] init];
        shareModel.share_type = [responseObject objectForKey:@"share_type"];
        shareModel.share_img = [responseObject objectForKey:@"share_icon"]; //图片
        shareModel.desc = [responseObject objectForKey:@"active_dec"]; // 文字详情
        shareModel.title = [responseObject objectForKey:@"title"]; //标题
        shareModel.share_link = [responseObject objectForKey:@"share_link"];
//        self.goodsShareView.isShowEarningValue = NO;
        self.goodsShareView.model = shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:240];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark 弹出视图 (弹出分享界面)
- (void)popShareView:(CGFloat)popHeeight {
    [MobClick event:@"GoodsDetail_share"];
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, popHeeight) ViewController:self.goodsShareView WithBlock:^(UIView *maskView) {
    }];
    self.goodsShareView.blcok = ^(UIButton *button) {
        [MobClick event:@"GoodsDetail_share_fail_clickCancelButton"];
    };
}
#pragma mark UITableView 代理实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeHourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMHomeHourCellIdentifier"];
    if (!cell) {
        cell = [[JMHomeHourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JMHomeHourCellIdentifier"];
    }
    if (self.dataSource.count == 0) {
        return nil;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"checkGoodsDetailClick"];
    if (self.dataSource.count == 0) {
        return ;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark JMHomeHourCellDelegate 点击事件
- (void)composeHourCell:(JMHomeHourCell *)cell Model:(JMHomeHourModel *)model ButtonClick:(UIButton *)button {
    if (button.tag == 100) {
        if ([[JMGlobal global] userVerificationLogin]) {
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/page_list?model_id=%@",Root_URL,model.model_id];
            //    urlString = [NSString stringWithFormat:@"%@?model_id=%@",urlString,model.fineCouponModelID];
            JMPushingDaysController *pushVC = [[JMPushingDaysController alloc] init];
            //        pushVC.isPushingDays = YES;
            pushVC.pushungDaysURL = urlString;
            pushVC.navTitle = @"文案精选";
            [self.navigationController pushViewController:pushVC animated:YES];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
        
    }else if (button.tag == 101) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,model.model_id];
        [self loadShareData:urlString];
    }else {
        NSString *activeID = [NSString stringWithFormat:@"%@",model.activity_id];
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeID];
        [self loadSharDataWithHour:urlString];
    }
}


@end
























/*
 #pragma mrak 刷新界面
 - (void)createPullFooterRefresh {
 kWeakSelf
 self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
 _isLoadMore = YES;
 [weakSelf loadMore];
 }];
 }
 - (void)endRefresh {
 if (_isLoadMore) {
 _isLoadMore = NO;
 [self.collectionView.mj_footer endRefreshing];
 }
 }
 - (void)loadMore {
 if ([NSString isStringEmpty:_nextPageUrl]) {
 [self endRefresh];
 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
 //        [MBProgressHUD showMessage:@"加载完成,没有更多数据"];
 return;
 }
 [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
 if (!responseObject) return;
 [self fetchMoreData:responseObject];
 [self endRefresh];
 } WithFail:^(NSError *error) {
 [self endRefresh];
 } Progress:^(float progress) {
 
 }];
 }
 - (void)fetchMoreData:(NSDictionary *)goodsDic {
 _nextPageUrl = goodsDic[@"next"];
 NSArray *resultsArr = goodsDic[@"results"];
 if (resultsArr.count == 0) {
 return ;
 }
 _numArray = [NSMutableArray array];
 for (NSDictionary *dic in resultsArr) {
 JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:dic];
 NSIndexPath *index ;
 index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
 [self.dataSource addObject:model];
 [_numArray addObject:index];
 
 }
 if((_numArray != nil) && (_numArray.count > 0)) {
 @try{
 [self.collectionView insertItemsAtIndexPaths:_numArray];
 [_numArray removeAllObjects];
 _numArray = nil;
 }
 @catch(NSException *except) {
 NSLog(@"DEBUG: failure to batch update.  %@", except.description);
 }
 }
 [self.collectionView reloadData];
 }
 */

























































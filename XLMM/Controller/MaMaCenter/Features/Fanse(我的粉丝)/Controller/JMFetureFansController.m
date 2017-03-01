//
//  JMFetureFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFetureFansController.h"
#import "JMFetureFansModel.h"
#import "JMFetureFansCell.h"
#import "JMReloadEmptyDataView.h"



@interface JMFetureFansController ()<UITableViewDataSource,UITableViewDelegate,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *topButton;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

@implementation JMFetureFansController {
    NSString *_urlStr;

}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createNavigationBarWithTitle:@"未来粉丝" selecotr:@selector(backBtnClicked:)];

    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self createButton];
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
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 35) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (void)loadDataSource{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/potential_fans", Root_URL];
    
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        
        [self.dataArray removeAllObjects];
        
        [self refetch:responseObject];
        
        [self endRefresh];
        [self.tableView cs_reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore
{
    if ([NSString isStringEmpty:_urlStr]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView cs_reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetch:(NSDictionary *)data {
    
    _urlStr = data[@"next"];
    NSArray *arr = data[@"results"];
    if (arr.count == 0) {
//        [self emptyView];
    }else {
        for (NSDictionary *dic in arr) {
            JMFetureFansModel *fetureModel = [JMFetureFansModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:fetureModel];
        }
    }
}
#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"FensiCell";
    JMFetureFansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JMFetureFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMFetureFansModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell fillData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99) Title:@"您还没有粉丝哦..." DescTitle:@"分享您的精选给好友就会获得粉丝哦~" BackImage:@"heart" InfoStr:@"我的精选"];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            
//        }
//    };
//}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有粉丝哦..." DescTitle:@"分享您的精选给好友就会获得粉丝哦~" ButtonTitle:@"赶紧分享" Image:@"heart" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

#pragma mark 返回顶部  image == >backTop
- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}
#pragma mark -- 添加滚动的协议方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat currentOffset = offset.y;
    if (currentOffset > SCREENHEIGHT) {
        self.topButton.hidden = NO;
    }else {
        self.topButton.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMFetureFansController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"JMFetureFansController"];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end























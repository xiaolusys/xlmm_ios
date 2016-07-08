//
//  JMRefundBaseController.m
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundBaseController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "JMRefundBaseCell.h"
#import "JMRefundModel.h"
#import "MJExtension.h"
#import "RefundDetailsViewController.h"

@interface JMRefundBaseController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;


/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
/**
 *  上拉加载的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;

@end

@implementation JMRefundBaseController {
    NSString *_nextPage;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"退款退货" selecotr:@selector(backClick:)];

    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lineGrayColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
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
#pragma mark 数据请求
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self fetchedRefundData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
    
}
- (void)loadMore {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_nextPage parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self fetchedRefundData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
- (void)fetchedRefundData:(NSDictionary *)data {
    _nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count == 0 ) {
        [self displayDefaultView];
        return;
    }
    for (NSDictionary *refund in results) {
        JMRefundModel *refundModel = [JMRefundModel mj_objectWithKeyValues:refund];
        [self.dataSource addObject:refundModel];
    }
}
#pragma mark ---UItableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMRefundBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMRefundBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMRefundModel *refundModel = self.dataSource[indexPath.row];
    
    [cell configRefund:refundModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMRefundModel *refundModel = self.dataSource[indexPath.row];
    
    RefundDetailsViewController *refundDetailVC = [[RefundDetailsViewController alloc] init];
    refundDetailVC.refundModelr = refundModel;
    [self.navigationController pushViewController:refundDetailVC animated:YES];
    
}
-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有退货(款)订单哦～快去看看吧!";
    
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
@end














































































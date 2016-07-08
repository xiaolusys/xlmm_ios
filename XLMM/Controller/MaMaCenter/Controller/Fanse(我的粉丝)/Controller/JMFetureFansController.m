//
//  JMFetureFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFetureFansController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "JMFetureFansModel.h"
#import "MJExtension.h"
#import "JMFetureFansCell.h"


@interface JMFetureFansController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

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

}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (void)loadDataSource{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/potential_fans", Root_URL];
    
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (!responseObject) return;
        
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        
        [self refetch:responseObject];
        
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
- (void)loadMore
{
    if ([_urlStr class] == [NSNull class]) {
        [self endRefresh];
        return;
    }
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:_urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
- (void)refetch:(NSDictionary *)data {
    
    _urlStr = data[@"next"];
    NSArray *arr = data[@"results"];
    for (NSDictionary *dic in arr) {
        JMFetureFansModel *fetureModel = [JMFetureFansModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:fetureModel];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"JMFetureFansController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"JMFetureFansController"];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end























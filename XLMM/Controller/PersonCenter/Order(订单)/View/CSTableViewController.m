//
//  CSTableViewController.m
//  XLMM
//
//  Created by zhang on 17/3/15.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSTableViewController.h"
#import "JMRootGoodsModel.h"

@interface CSTableViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSString *_nextPageUrlString;
    NSMutableArray *_numArray;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSMutableArray *dataSource;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation CSTableViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)getItemUrls {
    NSArray *urlBefroe = @[@"/rest/v2/modelproducts?cid=153", @"/rest/v2/modelproducts?cid=8", @"/rest/v2/modelproducts?cid=7",
                           @"/rest/v2/modelproducts?cid=3",@"/rest/v2/modelproducts?cid=5", @"/rest/v2/modelproducts?cid=8"];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < urlBefroe.count; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [mutArr addObject:url];
    }
    return mutArr;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"tableView的视图已经加载完成 -- 当前是第%ld个控制器",self.currentIndex);
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor lineGrayColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CSCustomerTableViewIndentifier"];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];

}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource:[self getItemUrls][self.currentIndex]];
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
- (void)loadDataSource:(NSString *)urlString {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
        [self fatchClassifyListData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fatchClassifyListMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fatchClassifyListData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.tableView cs_reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            NSIndexPath *index ;
            index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
            JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
        
    }
    [self.tableView cs_reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CSCustomerTableViewIndentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSCustomerTableViewIndentifier"];
    }
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:11.f];
    cell.textLabel.text = [NSString stringWithFormat:@"ItemView -- %ld -- %@",indexPath.row,model.name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}







@end















































































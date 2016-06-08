//
//  TixianHistoryViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianHistoryViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "TixianTableViewCell.h"
#import "TixianModel.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"


static NSString *CellIdentify = @"TixianCellIdentify";

@interface TixianHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *nextString;
//是否刷新
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadMore;
//记录当前页
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation TixianHistoryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现历史" selecotr:@selector(backClicked:)];
    
    [self createTableView];
    
    [self downloadData];
    
    [self createRefreshView];
    
    /**
     *  刷新用到的参数 (判断状态)
     */
    self.currentPage = 1;
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    
    /**
     *  进入页面就刷新一次
     */
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark --- 创建一个数据请求
- (void)downloadData{

    self.nextString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout?page=%ld", Root_URL,_currentPage];
    NSLog(@"string = %@", self.nextString);

    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:self.nextString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
        if (!responseObject) return;

        [self fetchedHistoryData:responseObject];
        [self.tableView reloadData];
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
    }];
}
#pragma mark ---- 字典转模型
- (void)fetchedHistoryData:(NSDictionary *)data{
    if (data== nil) {
        return;
    }
    
    if (_isRefreshing) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *dicJson = data;
    NSArray *results = [dicJson objectForKey:@"results"];
    for (NSDictionary *dic in results) {
        TixianModel *model = [TixianModel modelWithDiction:dic];
        [self.dataArray addObject:model];
    }
}

#pragma mark --- 上拉加载，下拉刷新
- (void)createRefreshView {
    kWeakSelf
    /**
     *  下拉刷新
     */
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 1;
        [weakSelf downloadData];

    }];
    
    /**
     *  上拉加载
     */
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage += 1;
        [weakSelf downloadData];
    }];

}
#pragma mark ---- 结束刷新
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;//标记刷新结束
        //正在刷新 就结束刷新
        [self.tableView.mj_header endRefreshing];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark ---- 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:CellIdentify];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.tableView registerNib:[UINib nibWithNibName:@"TixianTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentify];
    [self.view addSubview:self.tableView];
}


#pragma makr --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TixianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    if (!cell) {
        cell = [[TixianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.dataArray == nil || self.dataArray.count ==0)
        return cell;
    
    TixianModel *model = [self.dataArray objectAtIndex:indexPath.row];

    [cell fillModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end

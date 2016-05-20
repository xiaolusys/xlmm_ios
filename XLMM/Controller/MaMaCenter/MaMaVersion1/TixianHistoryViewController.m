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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [SVProgressHUD dismiss];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现历史" selecotr:@selector(backClicked:)];
    
    [self createTableView];
    
    [self downloadData];
    
    
    [self createRefreshView];
    
    self.currentPage = 1;
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)downloadData{
    
    
    self.nextString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout?page=%ld", Root_URL,_currentPage];
    NSLog(@"string = %@", self.nextString);
//    [SVProgressHUD showWithStatus:@"疯狂加载中....."];
    
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

- (void)fetchedHistoryData:(NSDictionary *)data{
    if (data== nil) {
        return;
    }
    
    NSDictionary *dicJson = data;

    NSArray *results = [dicJson objectForKey:@"results"];
    for (NSDictionary *dic in results) {
        TixianModel *model = [TixianModel modelWithDiction:dic];
        [self.dataArray addObject:model];
    }
//    [self.tableView reloadData];
    
}


/**
 *  刷新视图
 */

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
        
        [self.dataArray removeAllObjects];
        
        [self downloadData];
        
        
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
        
        [self downloadData];
        
    }];
    
    
}

- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;//标记刷新结束
        //正在刷新 就结束刷新
//        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
        [self.tableView.mj_header endRefreshing];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
//        [self.tableView footerEndRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    
    [self.tableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:CellIdentify];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

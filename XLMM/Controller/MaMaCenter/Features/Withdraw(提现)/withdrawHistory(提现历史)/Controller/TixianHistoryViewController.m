//
//  TixianHistoryViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianHistoryViewController.h"
#import "TixianTableViewCell.h"
#import "TixianModel.h"
#import "JMWithDrawDetailController.h"


static NSString *CellIdentify = @"TixianCellIdentify";

@interface TixianHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *nextString;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic,strong) UIButton *topButton;

@end

@implementation TixianHistoryViewController {
    NSString *_urlStr;
    
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"提现历史" selecotr:@selector(backClicked:)];
    
    [self createTableView];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    

    
    /**
     *  进入页面就刷新一次
     */
    [self.tableView.mj_header beginRefreshing];
    [self createButton];
}

#pragma mark --- 创建一个数据请求
- (void)loadDataSource{
    self.nextString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout?page=1", Root_URL];
//    NSLog(@"string = %@", self.nextString);
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextString WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return;
        [self.dataArray removeAllObjects];
        [self fetchedHistoryData:responseObject];
        [self.tableView reloadData];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
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
        [self fetchedHistoryData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

#pragma mark ---- 字典转模型
- (void)fetchedHistoryData:(NSDictionary *)data{
    if (data== nil) {
        return;
    }
    _urlStr = data[@"next"];
    NSDictionary *dicJson = data;
    NSArray *results = [dicJson objectForKey:@"results"];
    for (NSDictionary *dic in results) {
        TixianModel *model = [TixianModel modelWithDiction:dic];
        [self.dataArray addObject:model];
    }
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
#pragma mark ---- 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentify];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.tableView registerNib:[UINib nibWithNibName:@"TixianTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentify];
    [self.view addSubview:self.tableView];
}


#pragma makr --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TixianModel *model = [self.dataArray objectAtIndex:indexPath.row];
    JMWithDrawDetailController *detailVC = [[JMWithDrawDetailController alloc] init];
    detailVC.isActiveValue = YES;
    detailVC.mamaWithDrawHistoryDict = [model mj_keyValues];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    

}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TixianHistoryViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TixianHistoryViewController"];
}

#pragma mark -- 添加返回顶部按钮

- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}


@end





































//
//  JMNowFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMNowFansController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "FanceModel.h"
#import "FensiTableViewCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"


@interface JMNowFansController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *topButton;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMNowFansController {
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
    self.title = @"粉丝列表";
    
    [self createNavigationBarWithTitle:@"粉丝列表" selecotr:@selector(backBtnClicked:)];
    
    [self createTableView];
    [self createButton];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FensiTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FensiCell"];
   
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
//    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
//    kWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadMore];
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
- (void)loadDataSource{

    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/mama/fans", Root_URL];
    
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
        FanceModel *fetureModel = [FanceModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:fetureModel];
    }
    
}

#pragma mark --- 没有粉丝展示
-(void)displayDefaultView{
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"FansEmpty" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    defaultView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, SCREENWIDTH, SCREENHEIGHT);
    
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:defaultView];
}
-(void)gotoLandingPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FensiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FensiCell"];
    if (cell == nil) {
        cell = [[FensiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FensiCell"];
    }
    FanceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell fillData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
    self.topButton.hidden = YES;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark -- 添加滚动的协议方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.dataArray.count == 0) {
            self.topButton.hidden = YES;
        }else {
            self.topButton.hidden = NO;
        }
    }];
}
@end






















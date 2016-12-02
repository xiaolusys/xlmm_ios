//
//  JMMineIntegralController.m
//  XLMM
//
//  Created by zhang on 16/9/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMineIntegralController.h"
#import "JMMineIntegralCell.h"
#import "JMEmptyView.h"
#import "JMMineIntegralModel.h"

@interface JMMineIntegralController () <UITableViewDelegate,UITableViewDataSource> {
    NSString *_urlStr;
    NSString *_valueString;
}


@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong) JMEmptyView *empty;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation JMMineIntegralController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"我的积分" selecotr:@selector(backBtnClicked:)];
    
    [self createTableView];
    [self createButton];
    [self loadValueData];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];

}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    //    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
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
- (void)loadValueData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/integral",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        if ([responseObject[@"count"] integerValue] == 0) {
            _valueString = @"0";
            return;
        }
        NSArray *arr = responseObject[@"results"];
        NSDictionary *result = arr[0];
        _valueString = [result[@"integral_value"] stringValue];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kIntegrallogURL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_urlStr]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetch:(NSDictionary *)data {
    _urlStr = data[@"next"];
    NSArray *arr = data[@"results"];
    if (arr.count == 0) {
        [self emptyView];
    }else {
        for (NSDictionary *dic in arr) {
            JMMineIntegralModel *fetureModel = [JMMineIntegralModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:fetureModel];
        }
    }
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 240, SCREENWIDTH, SCREENHEIGHT - 240) Title:@"您暂时没有积分记录哦~" DescTitle:@"快去下单赚取积分吧～" BackImage:@"emptyJifenIcon" InfoStr:@"快去抢购"];
    [self.view addSubview:self.empty];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
        }
    };
}

#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"JMMineIntegralController";
    JMMineIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JMMineIntegralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMMineIntegralModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configIntegral:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *valueLabel = [UILabel new];
    [sectionView addSubview:valueLabel];
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel.font = [UIFont systemFontOfSize:40.];
    self.valueLabel = valueLabel;
    self.valueLabel.text = _valueString;
    
    UILabel *titleLabel = [UILabel new];
    [sectionView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.text = @"我的积分";
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(sectionView).offset(20);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(valueLabel.mas_bottom).offset(10);
    }];
    return sectionView;
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
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"JMMineIntegralController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    [MobClick endLogPageView:@"JMMineIntegralController"];
}



@end

















































































































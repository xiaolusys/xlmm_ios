//
//  JMMineIntegralController.m
//  XLMM
//
//  Created by zhang on 16/9/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMineIntegralController.h"
#import "JMMineIntegralCell.h"
#import "JMMineIntegralModel.h"
#import "JMReloadEmptyDataView.h"


@interface JMMineIntegralController () <UITableViewDelegate,UITableViewDataSource,CSTableViewPlaceHolderDelegate> {
    NSString *_urlStr;
    NSString *_valueString;
}


@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, assign) BOOL isPopToRootView;

@end

@implementation JMMineIntegralController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setXiaoluCoin:(NSString *)xiaoluCoin {
    _xiaoluCoin = xiaoluCoin;
    _valueString = xiaoluCoin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"小鹿币" selecotr:@selector(backBtnClicked:)];
    
    [self createTableView];
    [self createButton];
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
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *valueLabel = [UILabel new];
    [sectionView addSubview:valueLabel];
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel.font = [UIFont systemFontOfSize:40.];
    self.valueLabel = valueLabel;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",[_valueString floatValue]];;
    
    UILabel *titleLabel = [UILabel new];
    [sectionView addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.text = @"我的小鹿币";
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(sectionView).offset(20);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.top.equalTo(valueLabel.mas_bottom).offset(10);
    }];
    
    self.tableView.tableHeaderView = sectionView;
    
    
    
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
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
- (void)loadDataSource {
//    /rest/v1/integral
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/xiaolucoin/history",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self refetch:responseObject];
        [self endRefresh];
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
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetch:(NSDictionary *)data {
    _urlStr = data[@"next"];
    NSArray *arr = data[@"results"];
    if (arr.count != 0) {
        for (NSDictionary *dic in arr) {
            JMMineIntegralModel *fetureModel = [JMMineIntegralModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:fetureModel];
        }
    }
    [self.tableView cs_reloadData];
}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有小鹿币哦!" DescTitle:@"快去赚取吧~!" ButtonTitle:@"快去抢购" Image:@"emptyJifenIcon" ReloadBlcok:^{
            self.isPopToRootView = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 120;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [UIView new];
//    sectionView.backgroundColor = [UIColor whiteColor];
//    UILabel *valueLabel = [UILabel new];
//    [sectionView addSubview:valueLabel];
//    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
//    valueLabel.font = [UIFont systemFontOfSize:40.];
//    self.valueLabel = valueLabel;
//    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",[_valueString floatValue]];;
//    
//    UILabel *titleLabel = [UILabel new];
//    [sectionView addSubview:titleLabel];
//    titleLabel.textColor = [UIColor buttonTitleColor];
//    titleLabel.font = [UIFont systemFontOfSize:14.];
//    titleLabel.text = @"我的小鹿币";
//    
//    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(sectionView.mas_centerX);
//        make.top.equalTo(sectionView).offset(20);
//    }];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(sectionView.mas_centerX);
//        make.top.equalTo(valueLabel.mas_bottom).offset(10);
//    }];
//    return sectionView;
//}

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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isPopToRootView = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"JMMineIntegralController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPopToRootView) {
        [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    }
    [MobClick endLogPageView:@"JMMineIntegralController"];
}



@end

















































































































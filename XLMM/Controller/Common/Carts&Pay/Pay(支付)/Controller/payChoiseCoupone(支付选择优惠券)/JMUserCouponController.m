//
//  JMUserCouponController.m
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMUserCouponController.h"
#import "JMCouponRootCell.h"
#import "JMCouponModel.h"
#import "JMPayCouponController.h"
#import "JMReloadEmptyDataView.h"
#import "JMSelecterButton.h"


@interface JMUserCouponController () <UITableViewDelegate, UITableViewDataSource, CSTableViewPlaceHolderDelegate> {
    NSString *_urlStr;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
@property (nonatomic, strong) JMSelecterButton *disableButton;

@end

@implementation JMUserCouponController

#pragma 懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMUserCouponController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMUserCouponController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTabelView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
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
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.dataSource removeAllObjects];
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"优惠券加载失败,请稍后重试~!"];
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
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD showError:@"优惠券加载失败~!"];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData:(NSDictionary *)couponData {
    NSInteger code = [couponData[@"code"] integerValue];
    if (code != 0) {
        [MBProgressHUD showWarning:couponData[@"info"]];
        [self.tableView cs_reloadData];
        return;
    }
    _urlStr = couponData[@"next"];
    NSString *enableCouponCount = CS_STRING(couponData[@"usable_coupon_count"]);
    NSString *usableCouponCount = CS_STRING(couponData[@"disable_coupon_count"]);
    self.payCouponVC.segmentSectionTitle = @[enableCouponCount,usableCouponCount];
    NSArray *allArr = couponData[@"results"];
    for (NSDictionary *dic in allArr) {
        JMCouponModel *model = [JMCouponModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
    [self.tableView cs_reloadData];
}
#pragma 创建UI 实现 UITableView 代理
- (void)createTabelView {
    CGFloat bottomHeight = 0.;
    if (self.couponStatus == 0) {
        bottomHeight = 60.f;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45 - bottomHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 110.;
    
    if (self.couponStatus == 1) {
        return;
    }
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor countLabelColor];
    bottomView.frame = CGRectMake(0, SCREENHEIGHT - 64 - 45 - bottomHeight, SCREENWIDTH, 60);
    
    self.disableButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:self.disableButton];
    self.disableButton.frame = CGRectMake(15, 10, SCREENWIDTH - 30, 40);
    [self.disableButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"不使用优惠券" TitleFont:14. CornerRadius:20.];
    self.disableButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.disableButton addTarget:self action:@selector(disableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMUsableCouponController";
    JMCouponRootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMCouponRootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMCouponModel *couponModel = [[JMCouponModel alloc] init];
    couponModel = self.dataSource[indexPath.row];
    [cell configUsableData:couponModel IsSelectedYHQ:self.isSelectedYHQ SelectedID:self.selectedModelID Index:self.couponStatus];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.couponStatus == 1) {
        return;
    }
    JMCouponModel *couponModel = [[JMCouponModel alloc] init];
    couponModel = self.dataSource[indexPath.row];
    NSMutableArray *couponArray = [NSMutableArray array];
    if (self.couponNumber >= 1 && [self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
        NSInteger count = self.dataSource.count > self.couponNumber ? self.couponNumber : self.dataSource.count;
        for (int i = 0; i < count; i++) {
            [couponArray addObject:self.dataSource[i]];
        }
    }else {
        [couponArray addObject:couponModel];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanmodel:)]) {
        [self.delegate updateYouhuiquanmodel:couponArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)disableButtonClick:(UIButton *)button {
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanmodel:)]) {
        [self.delegate updateYouhuiquanmodel:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}

#pragma 无数据展示空视图
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"emptyYouhuiquanIcon" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}










@end































































































































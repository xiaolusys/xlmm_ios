//
//  JMPersonAllOrderController.m
//  XLMM
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPersonAllOrderController.h"
#import "MMClass.h"
#import "JMBaseGoodsCell.h"
#import "JMFetureFansModel.h"
#import "JMOrderGoodsModel.h"
#import "JMAllOrderModel.h"
#import "JMOrderDetailController.h"

@interface JMPersonAllOrderController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  订单详情模型
 */
@property (nonatomic,strong) JMAllOrderModel *orderDetailModel;
/**
 *  订单中商品信息模型
 */
@property (nonatomic,strong) JMOrderGoodsModel *orderGoodsModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionDataSource;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
/**
 *  组头视图
 */
@property (nonatomic, strong) UILabel *orderStatusLabel;
@property (nonatomic, strong) UILabel *orderPament;
@property (nonatomic, strong) UIImageView *shareRenpageImage;


@end

@implementation JMPersonAllOrderController {
    NSString *_urlStr;
    NSMutableArray *_goodsArray;
}


- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)sectionDataSource {
    if (_sectionDataSource == nil) {
        _sectionDataSource = [NSMutableArray array];
    }
    return _sectionDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"全部订单" selecotr:@selector(backBtnClicked:)];
    [self createTabelView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
}
- (NSString *)urlStr {
    return kQuanbuDingdan_URL;
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
- (void)loadDataSource{
    NSString *string = [self urlStr];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.dataSource removeAllObjects];
        [self.sectionDataSource removeAllObjects];
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore
{
    if ([_urlStr class] == [NSNull class]) {
        [self endRefresh];
        [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
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
    NSArray *allArr = data[@"results"];
    if (allArr.count == 0) {
        //没有订单
        [self displayDefaultView];
        return ;
    }
    
    for (NSDictionary *allDic in allArr) {
        JMAllOrderModel *allModel = [JMAllOrderModel mj_objectWithKeyValues:allDic];
        [self.sectionDataSource addObject:allModel];
        
        _goodsArray = [NSMutableArray array];
        NSArray *goodsArr = allDic[@"orders"];
        for (NSDictionary *goodsDic in goodsArr) {
            JMOrderGoodsModel *fetureModel = [JMOrderGoodsModel mj_objectWithKeyValues:goodsDic];
            [_goodsArray addObject:fetureModel];
        }
        [self.dataSource addObject:_goodsArray];
    }
    
}
- (void)createTabelView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 99) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataSource[section];
    return sectionArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMBaseGoodsCell";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.orderGoodsModel = [[JMOrderGoodsModel alloc] init];
    self.orderGoodsModel = self.dataSource[indexPath.section][indexPath.row];
    

    [cell configWithAllOrder:self.orderGoodsModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderDetailModel = self.sectionDataSource[indexPath.section];
    JMOrderDetailController *orderDetailVC = [[JMOrderDetailController alloc] init];
    orderDetailVC.allOrderModel = self.orderDetailModel;
    orderDetailVC.orderTid = self.orderDetailModel.tid;
    orderDetailVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, self.orderDetailModel.goodsID];
 
    [self.navigationController pushViewController:orderDetailVC animated:YES];
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    for (UIViewController *vc in marr) {
//        if ([vc isKindOfClass:[JMOrderDetailController class]]) {
//            [marr removeObject:vc];
//            break;
//        }
//    }
//    self.navigationController.viewControllers = marr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.orderDetailModel = [[JMAllOrderModel alloc] init];
    self.orderDetailModel = self.sectionDataSource[section];
    
    UIView *sectionView = [UIView new];
    UIView *lineView = [UIView new];
    [sectionView addSubview:lineView];
    lineView.backgroundColor = [UIColor countLabelColor];
    
    UIView *sectionShowView = [UIView new];
    [sectionView addSubview:sectionShowView];
    sectionShowView.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [UIView new];
    [sectionShowView addSubview:bottomView];
    
    UILabel *orderStatusLabel = [UILabel new];
    [sectionShowView addSubview:orderStatusLabel];
    self.orderStatusLabel = orderStatusLabel;
    self.orderStatusLabel.font = [UIFont systemFontOfSize:13.];
    self.orderStatusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.orderStatusLabel.text = self.orderDetailModel.status_display;
    
    CGFloat payment = [self.orderDetailModel.payment floatValue];
    UILabel *orderPament = [UILabel new];
    [sectionShowView addSubview:orderPament];
    self.orderPament = orderPament;
    self.orderPament.font = [UIFont systemFontOfSize:13.];
    self.orderPament.textColor = [UIColor buttonTitleColor];
    self.orderPament.text = [NSString stringWithFormat:@"实付金额: %.2f",payment];
    
    
    UIImageView *shareRenpageImage = [UIImageView new];
    [sectionShowView addSubview:shareRenpageImage];
    self.shareRenpageImage = shareRenpageImage;
    
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(sectionView);
        make.height.mas_equalTo(@15);
    }];
    
    [sectionShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sectionView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(@35);
    }];
    
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionShowView).offset(10);
        make.centerY.equalTo(sectionShowView.mas_centerY);
    }];
    
    [self.orderPament mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderStatusLabel.mas_right).offset(10);
        make.centerY.equalTo(sectionShowView.mas_centerY);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sectionShowView);
        make.bottom.equalTo(sectionShowView).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
    return sectionView;
}
#pragma mark 没有订单显示空视图
-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有订单哦～快去看看吧!";
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
}
-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"PersonOrder"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"PersonOrder"];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end





























































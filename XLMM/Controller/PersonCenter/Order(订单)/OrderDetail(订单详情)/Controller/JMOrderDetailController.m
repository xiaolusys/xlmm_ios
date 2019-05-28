//
//  JMOrderDetailController.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailController.h"
#import "JMOrderDetailHeaderView.h"
#import "JMOrderDetailFooterView.h"
#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"
#import "JMEditAddressModel.h"
#import "JMPackAgeModel.h"
#import "JMBaseGoodsCell.h"
#import "JMQueryLogInfoController.h"
#import "ShenQingTuikuanController.h"
#import "JMApplyForRefundController.h"
#import "ShenQingTuiHuoController.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMOrderPayOutdateView.h"
#import "JMPopLogistcsController.h"
#import "JMModifyAddressController.h"
#import "JMOrderDetailSectionView.h"
#import "JMRefundController.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMPayShareController.h"
#import "WXApi.h"
#import "JMGoodsDetailController.h"
#import "WebViewController.h"
#import "JMClassPopView.h"
#import "JMPopViewAnimationDrop.h"
#import "JMPayment.h"
#import "JMGoodsCountTime.h"
#import "JMOrderListController.h"


@interface JMOrderDetailController ()<NSURLConnectionDataDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,JMOrderDetailHeaderViewDelegate,JMBaseGoodsCellDelegate,JMRefundViewDelegate,JMOrderPayOutdateViewDelegate,JMPopLogistcsControllerDelegate,JMOrderDetailSectionViewDelegate,JMRefundControllerDelegate> {
    NSMutableArray *_refundStatusArray;        //退款状态
    NSMutableArray *_refundStatusDisplayArray; // 退款状态描述
    NSMutableArray *_orderStatusDisplay;
    NSMutableArray *_orderStatus;
    NSDictionary *_orderDic;
    NSString *_packageStr;                     // 判断是否分包
    NSDictionary *_refundDic;
    NSString *tid;
    NSString *_orderTid;
    NSString *_addressGoodsID;
    BOOL _isTimeLineView;
    BOOL _isPopChoiseRefundWay;                // 是否弹出选择退款方式
    BOOL _isTeamBuy;                           // 是否为团购订单
    NSArray *_choiseRefundArr;                 // 退款方式数组
    NSDictionary *_choiseRefundDict;           // 退款方式
    
    NSInteger _sectionCount;
    NSInteger _rowCount;
    NSString *_checkTeamBuy;                   // 查看开团进展
    bool _isCanRefund;                         // 开团后是否可以退款
    NSInteger redPageNumber;                   // 红包数量
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderGoodsDataSource;
/**
 *  tableHeaderView
 */
@property (nonatomic, strong) JMOrderDetailHeaderView *orderDetailHeaderView;
/**
 *  tableFooterView
 */
@property (nonatomic, strong) JMOrderDetailFooterView *orderDetailFooterView;
/**
 *  订单详情模型
 */
@property (nonatomic,strong) JMOrderDetailModel *orderDetailModel;
/**
 *  订单中商品信息模型
 */
@property (nonatomic,strong) JMOrderGoodsModel *orderGoodsModel;
/**
 *  收货地址Model
 */
@property (nonatomic,strong) JMEditAddressModel *addressModel;
/**
 *  包裹信息模型
 */
@property (nonatomic,strong) JMPackAgeModel *packageModel;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
/**
 *  蒙版视图
 */
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic, strong) JMRefundView *popView;
@property (nonatomic, strong) JMOrderPayOutdateView *outDateView;
@property (nonatomic, strong) JMClassPopView *classPopView;
/**
 *  修改物流视图
 */
@property (nonatomic,strong) JMPopLogistcsController *showViewVC;
/**
 *  退款选择弹出框视图
 */
@property (nonatomic,strong) JMRefundController *refundVC;
/**
 *  分享弹出视图
 */
@property (nonatomic,strong) JMShareViewController *shareView;
/**
 *  分享模型
 */
@property (nonatomic,strong) JMShareModel *shareModel;

@property (nonatomic, assign)BOOL isInstallWX;
@property (nonatomic, strong) NSMutableArray *logisticsArr;  //包裹分组信息
@property (nonatomic, strong) NSMutableArray *dataSource;    //商品分组信息

@end

@implementation JMOrderDetailController

- (JMPackAgeModel *)packageModel {
    if (_packageModel == nil) {
        _packageModel = [[JMPackAgeModel alloc] init];
    }
    return _packageModel;
}
- (NSMutableArray *)logisticsArr {
    if (_logisticsArr == nil) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (JMShareViewController *)shareView {
    if (_shareView == nil) {
        _shareView = [[JMShareViewController alloc] init];
    }
    return _shareView;
}
- (JMPopLogistcsController *)showViewVC {
    if (_showViewVC == nil) {
        _showViewVC = [[JMPopLogistcsController alloc] init];
        _showViewVC.delegate = self;
    }
    return _showViewVC;
}
- (JMRefundController *)refundVC {
    if (_refundVC == nil) {
        _refundVC = [[JMRefundController alloc] init];
        self.refundVC.delegate = self;
    }
    return _refundVC;
}
- (NSMutableArray *)orderGoodsDataSource {
    if (_orderGoodsDataSource == nil) {
        _orderGoodsDataSource = [NSMutableArray array];
    }
    return _orderGoodsDataSource;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [JMGoodsCountTime initCountDownWithCurrentTime:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(popToview)];
    
    _isTeamBuy = NO;
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createTableHeaderView];
    [self createTableFooterView];
}

- (void)setAllOrderModel:(JMAllOrderModel *)allOrderModel {
    _allOrderModel = allOrderModel;
    NSArray *arr = allOrderModel.orders;
    NSDictionary *dic = [arr[0] mj_keyValues];
    NSInteger countNum = [dic[@"status"] integerValue];
    NSInteger refundNum = [dic[@"refund_status"] integerValue];
    BOOL isCountNum = !(countNum == ORDER_STATUS_REFUND_CLOSE || countNum == ORDER_STATUS_TRADE_CLOSE);
    BOOL isRefundNum = (refundNum == REFUND_STATUS_NO_REFUND || refundNum == REFUND_STATUS_REFUND_CLOSE);
    if (isCountNum && isRefundNum) {
        _isTimeLineView = YES;
    }else {
        _isTimeLineView = NO;
    }
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark 创建视图
- (void)createTableView {
    kWeakSelf
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    JMOrderPayOutdateView *outDateView = [[JMOrderPayOutdateView alloc] init];
    [self.view addSubview:outDateView];
    self.outDateView = outDateView;
    self.outDateView.delegate = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.bottom.equalTo(weakSelf.outDateView.mas_top);
    }];
    [self.outDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.view);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(60));
    }];
    
    
    
}
- (void)createTableHeaderView {
    CGFloat _timeLineHeight = 0.;
    if (_isTimeLineView) {
        _timeLineHeight = 60.;
    }else {
    }
    JMOrderDetailHeaderView *orderDetailHeaderView = [[JMOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 230 + _timeLineHeight)];
    self.orderDetailHeaderView = orderDetailHeaderView;
    self.orderDetailHeaderView.delegate = self;
    self.orderDetailHeaderView.isTimeLineView = _isTimeLineView;
    self.tableView.tableHeaderView = self.orderDetailHeaderView;
}
- (void)createTableFooterView {
    JMOrderDetailFooterView *orderDetailFooterView = [[JMOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
    self.orderDetailFooterView = orderDetailFooterView;
    self.tableView.tableFooterView = self.orderDetailFooterView;
}
#pragma mark 分享红包接口数据
- (void)loadShareRedpage:(NSString *)orderTid {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/sharecoupon/create_order_share?uniq_id=%@", Root_URL,orderTid];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return;
        [self shareRedpageData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}
- (void)shareRedpageData:(NSDictionary *)shareDict {
    JMShareModel *shareModel = [JMShareModel mj_objectWithKeyValues:shareDict];
    self.shareModel = shareModel;
    self.shareModel.share_type = [NSString stringWithFormat:@"%@",[shareDict objectForKey:@"code"]];
    self.shareModel.share_img = [shareDict objectForKey:@"post_img"]; //图片
    self.shareModel.desc = [shareDict objectForKey:@"description"]; // 文字详情
    self.shareModel.title = [shareDict objectForKey:@"title"]; //标题
    self.shareModel.share_link = [shareDict objectForKey:@"share_link"];
    redPageNumber = [shareDict[@"share_times_limit"] integerValue];
    self.shareView.model = self.shareModel;
}
#pragma mark 请求数据
- (void)loadDataSource {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"device"] = @"app";  http://m.xiaolumeimei.com/rest/v2/trades/订单商品id?device=app
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.orderGoodsDataSource removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.logisticsArr removeAllObjects];
        [self refetchData:responseObject];
        [self.tableView reloadData];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD showError:@"获取数据失败"];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetchData:(NSDictionary *)dicJson {
    _orderDic = dicJson;
    _orderStatus = [NSMutableArray array];
    _orderStatusDisplay = [NSMutableArray array];
    _refundStatusArray = [NSMutableArray array];
    _refundStatusDisplayArray = [NSMutableArray array];
    if ([dicJson objectForKey:@"order_type"]) {  
        if ([dicJson[@"order_type"] integerValue] == 3) {  // 这里是判断是否为开团订单,默认NO.开团为YES
            _isTeamBuy = YES;
        }
        _isCanRefund = [dicJson[@"can_refund"] boolValue];
    }
    
    _refundDic = dicJson[@"extras"];
    tid = [dicJson objectForKey:@"id"];
    _orderTid = dicJson[@"tid"];
    [self loadShareRedpage:_orderTid];
    // ===== 订单详情主数据源模型 =======
    self.orderDetailModel = [JMOrderDetailModel mj_objectWithKeyValues:dicJson];
    // ===== 订单详情收货地址数据源模型 =======
    NSDictionary *addressDic = dicJson[@"user_adress"];
    self.addressModel = [JMEditAddressModel mj_objectWithKeyValues:addressDic];
    _addressGoodsID = addressDic[@"id"];
    // ===== 订单详情商品信息数据源模型 =======
    NSArray *goodsArr = dicJson[@"orders"];
    for (NSDictionary *goodsDic in goodsArr) {
        self.orderGoodsModel = [JMOrderGoodsModel mj_objectWithKeyValues:goodsDic];
        [self.orderGoodsDataSource addObject:self.orderGoodsModel];
        [_orderStatus addObject:goodsDic[@"status"]];
        [_orderStatusDisplay addObject:goodsDic[@"status_display"]];
        [_refundStatusArray addObject:goodsDic[@"refund_status"]];
        [_refundStatusDisplayArray addObject:goodsDic[@"refund_status_display"]];
    }
    // ===== 这里修改物流视图赋值 =====
    self.showViewVC.goodsID = _addressGoodsID;
    self.showViewVC.logisticsStr = tid;
    
    // ===== 订单详情包裹分包数据源模型 =======
    NSArray *packArr = dicJson[@"package_orders"];
    NSLog(@"%@",packArr);
    for (NSDictionary *packDic in packArr) {
        self.packageModel = [JMPackAgeModel mj_objectWithKeyValues:packDic];
        [self.logisticsArr addObject:self.packageModel];
    }
    NSLog(@"%@",self.logisticsArr);
    // ===== 订单退款选择是否弹出选择退款方式 ===== //
    _choiseRefundArr = [NSArray array];
    _choiseRefundArr = _refundDic[@"refund_choices"];
    if (_choiseRefundArr.count < 2) {
        _isPopChoiseRefundWay = NO;
    }else {
        _isPopChoiseRefundWay = YES;
    }
    // 这里对数据进行赋值,当订单详情为团购的时候,底部不显示继续支付或者分享红包,只显示查看进度
    self.orderDetailHeaderView.orderDetailModel = self.orderDetailModel;
    self.orderDetailFooterView.orderDetailModel = self.orderDetailModel;
    NSInteger statusCount = [dicJson[@"status"] integerValue];
    self.outDateView.isTeamBuy = _isTeamBuy;
    self.outDateView.statusCount = statusCount;
    self.outDateView.createTimeStr = dicJson[@"created"];
//    if (statusCount == ORDER_STATUS_WAITPAY) {
//        self.outDateView.hidden = NO;
//    }else {
//        self.outDateView.hidden = YES;
//    }
    // == 包裹信息的分包判断 == //
//    NSInteger count = [self.orderDetailModel.status integerValue];
//    NSString *statusDes = self.orderDetailModel.status_display;
    NSInteger statusCode = [self.orderDetailModel.status integerValue];
    bool isCanChangeAddress = [self.orderDetailModel.can_change_address boolValue];
    if (statusCode == 2 && isCanChangeAddress) {
        self.orderDetailHeaderView.addressView.userInteractionEnabled = YES;
        self.orderDetailHeaderView.logisticsView.userInteractionEnabled = YES;
    }
    NSDictionary *goodsDict = goodsArr[0];
    NSInteger number = 0;
    NSString *package = goodsDict[@"package_order_id"];
    _packageStr = package;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < goodsArr.count; i++) {
        [dataArr addObject:self.orderGoodsDataSource[number]];
        number ++;
        if (number == goodsArr.count) {
            [self.dataSource addObject:dataArr];
        }else {
            NSDictionary *dict2 = goodsArr[number];
            NSString *package2 = dict2[@"package_order_id"];
            if ([package isEqual:package2]) {
            }else {
                package = package2;
                [self.dataSource addObject:dataArr];
                dataArr = [NSMutableArray array];
            }
        }
    }
    _checkTeamBuy = [NSString stringWithFormat:@"%@/mall/order/spell/group/%@?from_page=order_detail",Root_URL,_orderTid];
}
#pragma mark tableHeaderView点击事件 ->修改地址/物流
- (void)composeHeaderTapView:(JMOrderDetailHeaderView *)headerView TapClick:(NSInteger)index {
    if (index == 100) {
        // 修改地址
        JMModifyAddressController *editVC = [[JMModifyAddressController alloc] init];
        editVC.orderEditAddress = YES;
        editVC.cartsPayInfoLevel = 1;
        editVC.addressLevel = 1;
        editVC.orderDict = (NSMutableDictionary *)[NSDictionary dictionaryWithDictionary:_orderDic];
        [self.navigationController pushViewController:editVC animated:YES];
    }else {
        // 修改物流  (如果需要判断是否可以更改物流在这里弹出一个提示)
        [self createClassPopView:@"提示" Message:orderDetailModifyLogistics Index:0];
    }
}
- (void)createChangeLogisticsView {  // Index == 0  修改物流
    [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.showViewVC WithBlock:^(UIView *maskView) {
    }];
}
- (void)ClickLogistics:(JMPopLogistcsController *)click Title:(NSString *)title {
    [self.tableView.mj_header beginRefreshing];
//    self.orderDetailHeaderView.logisticsStr = title;
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMOrderDetailController";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    self.orderGoodsModel = [[JMOrderGoodsModel alloc] init];
    self.orderGoodsModel = self.dataSource[indexPath.section][indexPath.row];
    if (self.logisticsArr.count == 0) {
        self.packageModel = nil;
    }else {
        self.packageModel = self.logisticsArr[indexPath.section];
    }
    cell.isTeamBuy = _isTeamBuy;
    cell.isCanRefund = _isCanRefund;
//    [cell configWithModel:self.orderGoodsModel PackageModel:self.packageModel SectionCount:indexPath.section RowCount:indexPath.row];
    [cell configWithModel:self.orderGoodsModel SectionCount:indexPath.section RowCount:indexPath.row];
    cell.delegate = self;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//刷新行
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.logisticsArr.count == 0) {
        return 0;
    }else {
        if (self.logisticsArr.count > section) {
            return 35;
        }else {
            return 0;
        };
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.logisticsArr.count == 0) {
        self.packageModel = nil;
        return nil;
    }else {
        JMOrderDetailSectionView *sectionView = [[JMOrderDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        sectionView.indexSection = section;
        self.packageModel = self.logisticsArr[section];
        sectionView.packAgeStr = self.packageModel.assign_status_display;
        sectionView.delegate = self;
        return sectionView;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    [self queryLogInfo:section];
}
- (void)composeSectionView:(JMOrderDetailSectionView *)sectionView Index:(NSInteger)index {
    NSInteger section = index - 100;
    [self queryLogInfo:section];
}
- (void)queryLogInfo:(NSInteger)section {
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];
    queryVC.index = section;
    queryVC.orderDataSource = self.dataSource[section];
    if (self.logisticsArr.count == 0) {
        return ;
    }else {
        queryVC.logisDataSource = self.logisticsArr;
    }
    JMPackAgeModel *packageModel = [[JMPackAgeModel alloc] init];
    packageModel = self.logisticsArr[section];
    NSDictionary *ligisticsDic = packageModel.logistics_company;
//    queryVC.logName = ligisticsDic[@"name"];
    //    NSDictionary *ligisticsDic = self.orderDetailModel.logistics_company;
    if (ligisticsDic == nil) {
        queryVC.logName = self.orderDetailHeaderView.logisticsStr;
    }else {
        queryVC.logName = ligisticsDic[@"name"];
    }
    [self.navigationController pushViewController:queryVC animated:YES];
}
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row {
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    JMOrderGoodsModel *model = self.dataSource[section][row];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 商品可选状态
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
    _sectionCount = section;
    _rowCount = row;
    // 100 申请退款 101 确认收货 102 退货退款 103 秒杀不退不换
    NSArray *arr = self.dataSource[section];
    JMOrderGoodsModel *model = arr[row];
    if (button.tag == 100) {
        self.packageModel = self.logisticsArr.count > 0 ? self.logisticsArr[section] : nil;
//        NSDictionary *dcit = [self.packageModel mj_keyValues];
        NSInteger statusCode = [self.orderDetailModel.status integerValue];
        BOOL isWarehouseOrder = (self.packageModel.book_time != nil && self.packageModel.assign_time == nil && self.packageModel.weight_time == nil && statusCode == 2);
        if (isWarehouseOrder) {
            [self createClassPopView:@"提示" Message:orderDetailAlreadyOrder Index:3];
        }else { // 如果只有一种退款方式不弹出选择框
            if (_isPopChoiseRefundWay) {
                self.refundVC.ordergoodsModel = model;
                self.refundVC.refundDic = _refundDic;
                [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 260) ViewController:self.refundVC WithBlock:^(UIView *maskView) {
                }];
            }else {
                [self createClassPopView:@"小鹿退款说明" Message:orderDetailReturnMoney Index:1];
            }
        }
    }else if (button.tag == 101) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/order/%@/confirm_sign", Root_URL, model.orderGoodsID];
        NSLog(@"url string = %@", string);
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
            if (responseObject == nil) return;
            NSDictionary *dic = responseObject;
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"签收成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            if ([[dic objectForKey:@"ok"]boolValue] == YES) {
                alterView.message = @"签收成功";
                [button setTitle:@"退货退款" forState:UIControlStateNormal];
                button.tag = 102;
            } else {
                alterView.message = @"签收失败";
            }
            [alterView show];
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
            
        }];
    }else if (button.tag == 102) {
        ShenQingTuiHuoController *tuiHuoVC = [[ShenQingTuiHuoController alloc] initWithNibName:@"ShenQingTuiHuoController" bundle:nil];
        tuiHuoVC.refundPrice = [model.payment floatValue];
        tuiHuoVC.dingdanModel = model;
        tuiHuoVC.tid = tid;
        tuiHuoVC.oid = model.orderGoodsID;
        tuiHuoVC.status = model.status_display;
        tuiHuoVC.button = button;
        [self.navigationController pushViewController:tuiHuoVC animated:YES];
    }else {
    }
}
/**
 *  选择退款方式 -> 极速退款 审核退款
 */
- (void)Clickrefund:(JMRefundController *)click OrderGoods:(JMOrderGoodsModel *)goodsModel Refund:(NSDictionary *)refundDic {
    _choiseRefundDict = refundDic;
    [self createClassPopView:@"小鹿退款说明" Message:orderDetailReturnMoney Index:1];
}
#pragma mark 订单倒计时点击时间
- (void)composeOutDateView:(JMOrderPayOutdateView *)outDateView Index:(NSInteger)index {
    if (index == 100) { // 取消支付
        [self createClassPopView:@"小鹿美美" Message:orderDetailCancelOrder Index:2];
    }else if (index == 101) { // 继续支付
        self.refundVC.continuePayDic = _refundDic;
        [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 260) ViewController:self.refundVC WithBlock:^(UIView *maskView) {
        }];
    }else if (index == 102) {
        //分享红包
        if (redPageNumber > 0) {
            [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.shareView WithBlock:^(UIView *maskView) {
            }];
        }else {
           [self createClassPopView:@"分享提示" Message:redPageShareNotEnough Index:4];
        }
    }else {  // 查看拼团进展
        NSDictionary *diction = [NSMutableDictionary dictionary];
        [diction setValue:_checkTeamBuy forKey:@"web_url"];
        [diction setValue:@"teamBuySuccessNo" forKey:@"type_title"];
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:diction];
        webView.isShowNavBar = true;
        webView.isShowRightShareBtn = false;
        [self.navigationController pushViewController:webView animated:YES];
        
        
    }
}
- (void)Clickrefund:(JMRefundController *)click ContinuePay:(NSDictionary *)continueDic {
    [MBProgressHUD showLoading:@"支付处理中....."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/%@",Root_URL,tid];
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlStr];
    [string appendString:@"/charge"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = continueDic[@"id"];
    if ([continueDic[@"id"] isEqualToString:@"wx"]) {
        if (!self.isInstallWX) {
            [MBProgressHUD showError:@"亲，没有安装微信哦"];
            return;
        }
    }
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code != 0) {
            [MBProgressHUD showError:responseObject[@"info"]];
        }else {
            [MBProgressHUD hideHUD];
            NSDictionary *dic = responseObject[@"charge"];
//            JMOrderDetailController * __weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [JMPayment createPaymentWithType:thirdPartyPayMentTypeForWechat Parame:dic URLScheme:kUrlScheme ErrorCodeBlock:^(JMPayError *error) {
                    NSLog(@"%ld",error.errorStatus);
                    if (error.errorStatus == payMentErrorStatusSuccess) {
                        [self paySuccessful];
                    }else if(error.errorStatus == payMentErrorStatusFail) { // 取消
                        [self popview];
                    }else { }
                }];
            });
            
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = tid;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popToview {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 支付成功的弹出框
- (void)paySuccessful{
    [MobClick event:@"buy_succ"];
    [self pushShareVC];
    [JMNotificationCenter removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter removeObserver:self name:@"CancleZhifu" object:nil];
}
- (void)popview {
    [MobClick event:@"buy_cancel"];
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 1;
    [self.navigationController pushViewController:orderVC animated:YES];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[JMOrderListController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [JMNotificationCenter addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    UIApplication *app = [UIApplication sharedApplication];
    [JMNotificationCenter addObserver:self
                                             selector:@selector(purchaseViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"OrderDetail"];
    if ([WXApi isWXAppInstalled]) {
        //  NSLog(@"安装了微信");
        self.isInstallWX = YES;
    }
    else{
        self.isInstallWX = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
    UIApplication *app = [UIApplication sharedApplication];
    [JMNotificationCenter removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:app];
    [MobClick endLogPageView:@"OrderDetail"];
}
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification {

}
#pragma mark 弹出视图公共用法
- (void)createClassPopView:(NSString *)title Message:(NSString *)message Index:(NSInteger)index {
    kWeakSelf
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
//    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClassPopView)]];
    self.classPopView = [JMClassPopView shareManager];
    self.classPopView = [[JMClassPopView alloc] initWithFrame:self.view.bounds Title:title DescTitle:message Cancel:@"取消" Sure:@"确定"];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.classPopView];
    [self showClassPopVoew];
    if (index == 0) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
                [weakSelf createChangeLogisticsView];
            }else { }
        };
    }else if (index == 1) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
                [weakSelf refundEntry];
            }
        };
    }else if (index == 2) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
                [weakSelf deletePayOrder];
            }
        };
    }else if (index == 3) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
            }
        };
    }else if (index == 4) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
            }
        };
    }else { }
}
- (void)showClassPopVoew {
    [JMPopViewAnimationDrop showView:self.classPopView overlayView:self.maskView];
}
- (void)hideClassPopView {
    [JMPopViewAnimationDrop dismissView:self.classPopView overlayView:self.maskView];
}
#pragma mark 选择进入退款界面
- (void)refundEntry {
    NSArray *arr = self.dataSource[_sectionCount];
    JMOrderGoodsModel *model = arr[_rowCount];
    if (_isPopChoiseRefundWay == YES) {
        JMApplyForRefundController *refundVC = [[JMApplyForRefundController alloc] init];
        refundVC.dingdanModel = model;
        refundVC.refundDic = _choiseRefundDict;
        refundVC.tid = tid;
        [self.navigationController pushViewController:refundVC animated:YES];
        
//        ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
//        tuikuanVC.dingdanModel = model;
//        tuikuanVC.refundDic = _choiseRefundDict;
//        tuikuanVC.tid = tid;
//        tuikuanVC.oid = model.orderGoodsID;
//        tuikuanVC.status = model.status_display;
//        [self.navigationController pushViewController:tuikuanVC animated:YES];
    }else {
        JMApplyForRefundController *refundVC = [[JMApplyForRefundController alloc] init];
        refundVC.dingdanModel = model;
        if (_choiseRefundArr.count > 0) {
            refundVC.refundDic = _choiseRefundArr[0];
        }
        refundVC.tid = tid;
        [self.navigationController pushViewController:refundVC animated:YES];
        
        
//        ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
//        tuikuanVC.dingdanModel = model;
//        if (_choiseRefundArr.count > 0) {
//            tuikuanVC.refundDic = _choiseRefundArr[0];
//        }
//        tuikuanVC.tid = tid;
//        tuikuanVC.oid = model.orderGoodsID;
//        tuikuanVC.status = model.status_display;
//        [self.navigationController pushViewController:tuikuanVC animated:YES];
    }
}
#pragma mark 取消待支付订单
- (void)deletePayOrder {
    [MBProgressHUD showLoading:@""];
    [JMHTTPManager requestWithType:RequestTypeDELETE WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD hideHUD];
            [self popToview];
            if (_delegate && [_delegate respondsToSelector:@selector(composeWithPopViewRefresh:)]) {
                [_delegate composeWithPopViewRefresh:self];
            }
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"订单取消失败~!"];
    } Progress:^(float progress) {
        
    }];
}


@end



































//                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                    NSLog(@"completion block: %@", result);
//
//                    if (error == nil) {
//                        [MBProgressHUD showSuccess:@"支付成功"];
//                        [MobClick event:@"buy_succ"];
//                        [self pushShareVC];
//                    } else {
//                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
//                            [MBProgressHUD showError:@"用户取消支付"];
//                            [MobClick event:@"buy_cancel"];
//                            [self popview];
//                        } else {
//                            [MBProgressHUD showError:@"支付失败"];
//                            NSDictionary *temp_dict = @{@"return" : @"fail", @"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
//                            [MobClick event:@"buy_fail" attributes:temp_dict];
//                            NSLog(@"%@",error);
//                            [self performSelector:@selector(popToview) withObject:nil afterDelay:1.0];
//                        }
//                    }
//                }];



































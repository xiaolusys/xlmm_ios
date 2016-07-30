//
//  JMOrderDetailController.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailController.h"
#import "MMClass.h"
#import "JMOrderDetailHeaderView.h"
#import "JMOrderDetailFooterView.h"
#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"
#import "JMEditAddressModel.h"
#import "JMPackAgeModel.h"
#import "XlmmMall.h"
#import "MJRefresh.h"
#import "JMBaseGoodsCell.h"
#import "JMQueryLogInfoController.h"
#import "ShenQingTuikuanController.h"
#import "ShenQingTuiHuoController.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMOrderPayOutdateView.h"
#import "Pingpp.h"
#import "JMPopLogistcsController.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "JMEditAddressController.h"
#import "JMOrderDetailSectionView.h"
#import "JMRefundController.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMPayShareController.h"
#import "WXApi.h"
#import "PersonOrderViewController.h"

#define kUrlScheme @"wx25fcb32689872499"

@interface JMOrderDetailController ()<NSURLConnectionDataDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,JMOrderDetailHeaderViewDelegate,JMBaseGoodsCellDelegate,JMRefundViewDelegate,JMShareViewDelegate,JMOrderPayOutdateViewDelegate,JMPopLogistcsControllerDelegate,JMOrderDetailSectionViewDelegate,JMRefundControllerDelegate>

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

@end

@implementation JMOrderDetailController {
    NSMutableArray *_refundStatusArray;//退款状态
    NSMutableArray *_refundStatusDisplayArray;// 退款状态描述
    NSMutableArray *_orderStatusDisplay;
    NSMutableArray *_orderStatus;
    NSDictionary *_orderDic;
    
    NSMutableArray *_logisticsArr; //包裹分组信息
    NSMutableArray *_dataSource; //商品分组信息
    
    NSString *_packageStr; // 判断是否分包
    NSDictionary *_refundDic;
    NSString *tid;
    NSString *_orderTid;
    NSString *_addressGoodsID;
    
    BOOL _isTimeLineView;
    BOOL _isPopChoiseRefundWay; // 是否弹出选择退款方式
    NSArray *_choiseRefundArr; // 退款方式数组
    NSDictionary *_choiseRefundDict; // 退款方式
    
    NSInteger _sectionCount;
    NSInteger _rowCount;
    
    
}
- (JMRefundController *)refundVC {
    if (_refundVC == nil) {
        _refundVC = [[JMRefundController alloc] init];
    }
    return _refundVC;
}
- (NSMutableArray *)orderGoodsDataSource {
    if (_orderGoodsDataSource == nil) {
        _orderGoodsDataSource = [NSMutableArray array];
    }
    return _orderGoodsDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(backClick:)];
    
    [self createTableView];
    [self createBottomView];
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 60) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (void)createBottomView {
    JMOrderPayOutdateView *outDateView = [[JMOrderPayOutdateView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60)];
    [self.view addSubview:outDateView];
    self.outDateView = outDateView;
    self.outDateView.delegate = self;
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
    JMOrderDetailFooterView *orderDetailFooterView = [JMOrderDetailFooterView enterFooterView];
    self.orderDetailFooterView = orderDetailFooterView;
    self.tableView.tableFooterView = self.orderDetailFooterView;
}
#pragma mark 分享红包接口数据
- (void)loadShareRedpage:(NSString *)orderTid {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/sharecoupon/create_order_share?uniq_id=%@", Root_URL,orderTid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (!responseObject) return;
        [self shareRedpageData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
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
}
#pragma mark 请求数据
- (void)loadDataSource {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"app";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self.orderGoodsDataSource removeAllObjects];
        [self refetchData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
- (void)refetchData:(NSDictionary *)dicJson {
    _orderDic = dicJson;
    _orderStatus = [NSMutableArray array];
    _orderStatusDisplay = [NSMutableArray array];
    _refundStatusArray = [NSMutableArray array];
    _refundStatusDisplayArray = [NSMutableArray array];
    
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
    // ===== 订单详情包裹分包数据源模型 =======
    _logisticsArr = [NSMutableArray array];
    NSArray *packArr = dicJson[@"package_orders"];
    for (NSDictionary *packDic in packArr) {
        self.packageModel = [JMPackAgeModel mj_objectWithKeyValues:packDic];
        [_logisticsArr addObject:self.packageModel];
    }
    // ===== 订单退款选择是否弹出选择退款方式 ===== //
    _choiseRefundArr = [NSArray array];
    _choiseRefundArr = _refundDic[@"refund_choices"];
    if (_choiseRefundArr.count < 2) {
        _isPopChoiseRefundWay = NO;
    }else {
        _isPopChoiseRefundWay = YES;
    }
    
    self.orderDetailHeaderView.orderDetailModel = self.orderDetailModel;
    self.orderDetailFooterView.orderDetailModel = self.orderDetailModel;
    NSInteger statusCount = [dicJson[@"status"] integerValue];
    self.outDateView.statusCount = statusCount;
    self.outDateView.createTimeStr = dicJson[@"created"];
//    if (statusCount == ORDER_STATUS_WAITPAY) {
//        self.outDateView.hidden = NO;
//    }else {
//        self.outDateView.hidden = YES;
//    }
    // == 包裹信息的分包判断 == //
    _dataSource = [NSMutableArray array];
//    NSInteger count = [self.orderDetailModel.status integerValue];
    NSString *statusDes = self.orderDetailModel.status_display;
    if ([statusDes isEqualToString:@"已付款"]) {
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
            [_dataSource addObject:dataArr];
        }else {
            NSDictionary *dict2 = goodsArr[number];
            NSString *package2 = dict2[@"package_order_id"];
            if (package == package2) {
                
            }else {
                package = package2;
                [_dataSource addObject:dataArr];
                dataArr = [NSMutableArray array];
            }
        }
    }
}
#pragma mark tableHeaderView点击事件 ->修改地址/物流
- (void)composeHeaderTapView:(JMOrderDetailHeaderView *)headerView TapClick:(NSInteger)index {
    if (index == 100) {
        // 修改地址
        JMEditAddressController *editVC = [[JMEditAddressController alloc] init];
        editVC.editDict = (NSMutableDictionary *)[NSDictionary dictionaryWithDictionary:_orderDic];
        [self.navigationController pushViewController:editVC animated:YES];
    }else {
        // 修改物流
        self.showViewVC = [[JMPopLogistcsController alloc] init];
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
        if (self.showViewVC.view == nil) {
            self.showViewVC = [[JMPopLogistcsController alloc] init];
        }
        self.showViewVC.goodsID = _addressGoodsID;
        self.showViewVC.logisticsStr = tid;
        self.showViewVC.delegate = self;
        menu.contentView = self.showViewVC.view;
    }
}
- (void)ClickLogistics:(JMPopLogistcsController *)click Title:(NSString *)title {
    [self.tableView.mj_header beginRefreshing];
//    self.orderDetailHeaderView.logisticsStr = title;
}
- (void)coverDidClickCover:(JMShareView *)cover {
    [JMPopView hide];
    [SVProgressHUD dismiss];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _dataSource[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    self.orderGoodsModel = [[JMOrderGoodsModel alloc] init];
    self.packageModel = [[JMPackAgeModel alloc] init];
    self.orderGoodsModel = _dataSource[indexPath.section][indexPath.row];
    if (_logisticsArr.count == 0) {
        self.packageModel = nil;
    }else {
        self.packageModel = _logisticsArr[indexPath.section];
    }
    [cell configWithModel:self.orderGoodsModel PackageModel:self.packageModel SectionCount:indexPath.section RowCount:indexPath.row];
    cell.delegate = self;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//刷新行
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_logisticsArr.count == 0) {
        return 0;
    }else {
        return 35;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_logisticsArr.count == 0) {
        return nil;
    }else {
        JMOrderDetailSectionView *sectionView = [[JMOrderDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        sectionView.indexSection = section;
        self.packageModel = [[JMPackAgeModel alloc] init];
        if (_logisticsArr.count == 0) {
            self.packageModel = nil;
        }else {
            self.packageModel = _logisticsArr[section];
            sectionView.packAgeStr = self.packageModel.assign_status_display;
        }
        sectionView.delegate = self;
        return sectionView;
    }
}
- (void)composeSectionView:(JMOrderDetailSectionView *)sectionView Index:(NSInteger)index {
    NSInteger count = index - 100;
    
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];
    queryVC.index = count;
    NSArray *arr = _dataSource[count];
    NSArray *logisArr = _logisticsArr;
    queryVC.orderDataSource = arr;
    queryVC.logisDataSource = logisArr;
    NSDictionary *ligisticsDic = self.orderDetailModel.logistics_company;
    if (ligisticsDic == nil) {
        queryVC.logName = self.orderDetailHeaderView.logisticsStr;
    }else {
        queryVC.logName = ligisticsDic[@"name"];
    }
    [self.navigationController pushViewController:queryVC animated:YES];
}
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row {
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];
    queryVC.index = section;
    queryVC.orderDataSource = _dataSource[section];
    if (_logisticsArr.count == 0) {
        return ;
    }else {
        queryVC.logisDataSource = _logisticsArr;
    }
    NSDictionary *ligisticsDic = self.orderDetailModel.logistics_company;
    if (ligisticsDic == nil) {
        queryVC.logName = self.orderDetailHeaderView.logisticsStr;
    }else {
        queryVC.logName = ligisticsDic[@"name"];
    }
    [self.navigationController pushViewController:queryVC animated:YES];
}
#pragma mark 商品可选状态
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
    _sectionCount = section;
    _rowCount = row;
    // 100 申请退款 101 确认收货 102 退货退款 103 秒杀不退不换
    NSArray *arr = _dataSource[section];
    JMOrderGoodsModel *model = arr[row];
    if (button.tag == 100) {
        self.packageModel = [[JMPackAgeModel alloc] init];
        if (_logisticsArr.count > 0) {
            self.packageModel = _logisticsArr[section];
        }else {
            self.packageModel = nil;
        }
        BOOL isWarehouseOrder = (self.packageModel.assign_time != nil || self.packageModel.book_time != nil || self.packageModel.finish_time != nil);
        if (isWarehouseOrder) {
            [self returnPopView];
        }else { // 如果只有一种退款方式不弹出选择框
            if (_isPopChoiseRefundWay == YES) {
                JMShareView *cover = [JMShareView show];
                cover.delegate = self;
                JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 260, SCREENWIDTH, 260)];
                self.refundVC.ordergoodsModel = model;
                self.refundVC.refundDic = _refundDic;
                self.refundVC.delegate = self;
                menu.contentView = self.refundVC.view;
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"小鹿退款说明" message:@"如果您选择支付宝或微信退款，退款将在3-5天返还您的帐户，具体取决于支付宝或微信处理时间。如果您选择小鹿急速退款，款项将快速返回至小鹿账户，该退款14天内只能用于购买，不可提现。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
                alertView.tag = 101;
                [alertView show];
            }
        }
    }else if (button.tag == 101) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/order/%@/confirm_sign", Root_URL, model.orderGoodsID];
        NSLog(@"url string = %@", string);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"小鹿退款说明" message:@"如果您选择支付宝或微信退款，退款将在3-5天返还您的帐户，具体取决于支付宝或微信处理时间。如果您选择小鹿急速退款，款项将快速返回至小鹿账户，该退款14天内只能用于购买，不可提现。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
    alertView.tag = 101;
    [alertView show];
}
#pragma mark -- 弹出视图
- (void)returnPopView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefundpopView)]];
    JMRefundView *popView = [JMRefundView defaultPopView];
    self.popView = popView;
    self.popView.titleStr = @"您的订单已经向工厂订货，暂不支持退款，请您耐心等待，在收货确认签收后申请退货，如有疑问请咨询小鹿美美公众号或客服4008235355。";
    self.popView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
    
}
- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideRefundpopView];
    }else {
        [self hideRefundpopView];
    }
}
- (void)hideRefundpopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
}
#pragma mark 订单倒计时点击时间
- (void)composeOutDateView:(JMOrderPayOutdateView *)outDateView Index:(NSInteger)index {
    if (index == 100) { // 取消支付
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小鹿美美" message:@"取消的产品可能会被人抢走哦~\n要取消吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
        alterView.tag = 100;
    }else if (index == 101) { // 继续支付
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 260, SCREENWIDTH, 260)];
        self.refundVC.continuePayDic = _refundDic;
        self.refundVC.delegate = self;
        menu.contentView = self.refundVC.view;
    }else if (index == 102) {
        //分享红包
        JMShareViewController *shareView = [[JMShareViewController alloc] init];
        self.shareView = shareView;
        self.shareView.model = self.shareModel;
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        //弹出视图
        JMPopView *shareMenu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
        shareMenu.contentView = self.shareView.view;
        
    }else {
        
    }
}
- (void)Clickrefund:(JMRefundController *)click ContinuePay:(NSDictionary *)continueDic {
    [SVProgressHUD showWithStatus:@"支付处理中....."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/%@",Root_URL,tid];
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlStr];
    [string appendString:@"/charge"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = continueDic[@"id"];
    if ([continueDic[@"id"] isEqualToString:@"wx"]) {
        if (!self.isInstallWX) {
            [SVProgressHUD showErrorWithStatus:@"亲，没有安装微信哦"];
            return;
        }
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (!responseObject)return;
        
        NSError *parseError = nil;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code != 0) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }else {
            [SVProgressHUD dismiss];
            NSDictionary *dic = responseObject[@"charge"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            
            JMOrderDetailController * __weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    NSLog(@"completion block: %@", result);
                    
                    if (error == nil) {
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        [MobClick event:@"buy_succ"];
                        [self pushShareVC];
                    } else {
                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
                            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                            [MobClick event:@"buy_cancel"];
                            [self popview];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"支付失败"];
                            NSDictionary *temp_dict = @{@"return" : @"fail", @"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
                            [MobClick event:@"buy_fail" attributes:temp_dict];
                            NSLog(@"%@",error);
                            [self performSelector:@selector(popToview) withObject:nil afterDelay:1.0];
                        }
                    }
                }];
            });

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
}
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = tid;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
#pragma mark --NSURLConnectionDataDelegate--
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    __unused NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    JMOrderDetailController * __weak weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            if (error == nil) {
            } else {
            }
        }];
    });
}
#pragma mark --AlertViewDelegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSMutableString *string = [[NSMutableString alloc] initWithString:self.urlString];
            
            NSURL *url = [NSURL URLWithString:string];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"DELETE"];
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [connection start];
            
            [self performSelector:@selector(popToview) withObject:nil afterDelay:.3];
        }else{}
    }else if (alertView.tag == 101){
        if (buttonIndex == 1) {
            NSArray *arr = _dataSource[_sectionCount];
            JMOrderGoodsModel *model = arr[_rowCount];
            if (_isPopChoiseRefundWay == YES) {
                ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
                tuikuanVC.dingdanModel = model;
                tuikuanVC.refundDic = _choiseRefundDict;
                tuikuanVC.tid = tid;
                tuikuanVC.oid = model.orderGoodsID;
                tuikuanVC.status = model.status_display;
                [self.navigationController pushViewController:tuikuanVC animated:YES];
            }else {
                ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
                tuikuanVC.dingdanModel = model;
                if (_choiseRefundArr.count > 0) {
                    tuikuanVC.refundDic = _choiseRefundArr[0];
                }
                tuikuanVC.tid = tid;
                tuikuanVC.oid = model.orderGoodsID;
                tuikuanVC.status = model.status_display;
                [self.navigationController pushViewController:tuikuanVC animated:YES];
            }

        }else{}
    }
}
- (void)popToview {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 支付成功的弹出框
- (void)paySuccessful{
    [MobClick event:@"buy_succ"];
    [self pushShareVC];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancleZhifu" object:nil];
}
- (void)popview {
    [MobClick event:@"buy_cancel"];
    PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
    orderVC.index = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
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
    [SVProgressHUD dismiss];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:app];
    [MobClick endLogPageView:@"OrderDetail"];
}
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification {

}
@end







































































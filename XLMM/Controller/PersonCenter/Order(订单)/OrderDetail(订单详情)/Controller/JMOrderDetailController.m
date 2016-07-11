//
//  JMOrderDetailController.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailController.h"
#import "MMClass.h"
#import "Masonry.h"
#import "UIViewController+NavigationBar.h"
#import "JMOrderDetailHeaderView.h"
#import "JMOrderDetailFooterView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
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
    
    NSString *_addressGoodsID;
    
    BOOL _isTimeLineView;
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
#pragma mark 请求数据
- (void)loadDataSource {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSInteger count = [self.orderDetailModel.status integerValue];
    if (count == ORDER_STATUS_PAYED) {
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
    queryVC.logName = ligisticsDic[@"name"];
    
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
    queryVC.logName = ligisticsDic[@"name"];
    [self.navigationController pushViewController:queryVC animated:YES];
}
#pragma mark 商品可选状态
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
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
        }else {
            JMShareView *cover = [JMShareView show];
            cover.delegate = self;
            JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 260, SCREENWIDTH, 260)];
            
            if (self.refundVC.view == nil) {
                self.refundVC = [[JMRefundController alloc] init];
            }
            self.refundVC.ordergoodsModel = model;
            self.refundVC.refundDic = _refundDic;
            self.refundVC.delegate = self;
            menu.contentView = self.refundVC.view;
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
    ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
    tuikuanVC.dingdanModel = goodsModel;
    tuikuanVC.refundDic = refundDic;
    tuikuanVC.tid = tid;
    tuikuanVC.oid = goodsModel.orderGoodsID;
    tuikuanVC.status = goodsModel.status_display;
    [self.navigationController pushViewController:tuikuanVC animated:YES];
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
    }else { // 继续支付
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/trades/%@",Root_URL,tid];
        NSMutableString *string = [[NSMutableString alloc] initWithString:urlStr];
        [string appendString:@"/charge"];
     
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if (!responseObject)return;
            NSError *parseError = nil;
            NSDictionary *dic = responseObject;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            JMOrderDetailController * __weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    NSLog(@"completion block: %@", result);
                    
                    if (error == nil) {
                        NSLog(@"PingppError is nil");
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                        // [self.navigationController popViewControllerAnimated:YES];
                    }
                    //[weakSelf showAlertMessage:result];
                }];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

    }
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
            
            [self performSelector:@selector(poptoView) withObject:nil afterDelay:.3];
        }
    }else {
    }
}
- (void)poptoView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"OrderDetail"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"OrderDetail"];
}
@end







































































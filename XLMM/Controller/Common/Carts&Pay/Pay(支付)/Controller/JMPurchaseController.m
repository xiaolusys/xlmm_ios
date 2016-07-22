//
//  JMPurchaseController.m
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPurchaseController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "JMPurchaseHeaderView.h"
#import "JMPurchaseFooterView.h"
#import "JMBaseGoodsCell.h"
#import "CartListModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JMShareView.h"
#import "JMChoiseLogisController.h"
#import "JMPopView.h"
#import "JMPopLogistcsModel.h"
#import "AddressViewController.h"
#import "AddressModel.h"
#import "YouHuiQuanViewController.h"
#import "YHQModel.h"
#import "GoodsInfoModel.h"
#import "JMOrderPayView.h"
#import "UIView+RGSize.h"
#import "WXApi.h"
#import "Pingpp.h"
#import "PersonOrderViewController.h"
#import "JMPayShareController.h"

#define kUrlScheme @"wx25fcb32689872499" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface JMPurchaseController ()<UIAlertViewDelegate,JMOrderPayViewDelegate,YouhuiquanDelegate,PurchaseAddressDelegate,JMChoiseLogisControllerDelegate,UITableViewDataSource,UITableViewDelegate,JMPurchaseHeaderViewDelegate,JMPurchaseFooterViewDelegate,JMShareViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JMPurchaseHeaderView *purchaseHeaderView;

@property (nonatomic, strong) JMPurchaseFooterView *purchaseFooterView;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) JMOrderPayView *payView;
/**
 *  获取商品购买商品ID
 */
@property (nonatomic ,strong) NSMutableString *paramstring;
/**
 *  展示物流信息控制器
 */
@property (nonatomic,strong) JMChoiseLogisController *showViewVC;
/**
 *  选择物流信息的数组
 */
@property (nonatomic, strong) NSMutableArray *logisticsArr;
/**
 *  判断优惠券是否可用
 */
@property (nonatomic, assign) BOOL isCanCoupon;
@property (nonatomic, assign) BOOL isUserCoupon;
@property (nonatomic, assign) BOOL isEnoughRight;
@property (nonatomic, assign) BOOL isEnoughBudget;
@property (nonatomic, assign) BOOL isUseXLW;
@property (nonatomic, assign) BOOL isInstallWX;
@property (nonatomic, assign) BOOL isAgreeTerms;
/**
 *  优惠券是否满足条件
 */
@property (nonatomic, assign)BOOL isEnoughCoupon;
/**
 *  判断优惠券是否能够直接支付订单
 */
@property (nonatomic, assign) BOOL isCouponEnoughPay;
/**
 *  优惠券模型
 */
@property (nonatomic, strong) YHQModel *yhqModel;
/**
 *  判断小鹿钱包是否足够支付->如果不足则调用微信或者支付宝，传payment。否则传budget。
 */
@property (nonatomic,assign) BOOL isXLWforAlipay;

@end

@implementation JMPurchaseController {
    
    NSString *_logisticsID;         // 选择物流的ID
    NSDictionary *_couponInfo;       // 优惠券
    NSDictionary *_rightReduce;      // app立减
    NSDictionary *_xlWallet;         // 钱包
    
    NSString *_payMethod;             //支付方式
    float _totalPayment;              //应付款金额
    float _discountfee;               //优惠券金额
    float _rightAmount;               //app优惠
    float _availableFloat;            //小鹿钱包余额
    
    NSString *_uuid;                  //uuid
    NSString *_cartIDs;               //购物车id
    float _totalfee;                  //总金额
    float _postfee;                   //运费金额
    float _amontPayment;              //总需支付金额
    float _couponValue;               //优惠券金额
    float _discount;                  //计算金额
    
    NSString *_yhqModelID;
    NSString *_addressID;             //地址信息ID
    NSString *_parmsStr;              //支付提交参数
    
    NSString *_limitStr;              //分享红包数量
    NSString *_orderTidNum;           //订单编号

}
- (NSMutableArray *)logisticsArr {
    if (!_logisticsArr) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backClick)];
    
    [self initView];
    [self createTableView];
    [self createTableHeaderView];
    [self createTableFooterView];
    [self createPullHeaderRefresh];
    [self loadAddressInfo];
    
    
    self.isCanCoupon = NO;
    self.isUseXLW = NO;
    
    self.isEnoughRight = NO;
    self.isEnoughBudget = NO;
    self.isEnoughCoupon = NO;
    
    self.isUserCoupon = NO;
    self.isAgreeTerms = NO;

    
}
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)]];
    
    JMOrderPayView *payView = [[JMOrderPayView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 180, SCREENWIDTH, 180)];
    self.payView = payView;
    self.payView.delegate = self;

}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
//        [weakSelf loadAddressInfo];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark 订单支付网络请求
- (void)loadDataSource {
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.purchaseGoodsArr.count == 0) {
        return;
    }
    //构造参数字符串
    for (CartListModel *model in self.purchaseGoodsArr) {
        NSString *str = [NSString stringWithFormat:@"%ld,",model.cartID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    self.paramstring = paramstring;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/carts_payinfo?cart_ids=%@&device=%@", Root_URL,paramstring,@"app"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self.logisticsArr removeAllObjects];
        [self fetchedCartsData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
    
}
#pragma mark 地址信息网络请求
- (void)loadAddressInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAddress_List_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchedAddressData:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
/**
 *  订单信息
 */
- (void)fetchedCartsData:(NSDictionary *)purchaseDic {
    NSArray *logArr = purchaseDic[@"logistics_companys"];
    NSDictionary *logisticsDic = logArr[0];
    _logisticsID = logisticsDic[@"id"];
    for (NSDictionary *dic in logArr) {
        JMPopLogistcsModel *logisticsModel = [JMPopLogistcsModel mj_objectWithKeyValues:dic];
        [self.logisticsArr addObject:logisticsModel];
    }
    
    _amontPayment = [[purchaseDic objectForKey:@"total_payment"] floatValue];
    _totalPayment = [[purchaseDic objectForKey:@"total_payment"] floatValue];
    _discountfee = [[purchaseDic objectForKey:@"discount_fee"] floatValue];
    
    // 优惠判断
    NSArray *extrasArr = purchaseDic[@"pay_extras"];
    for (NSDictionary *dicExtras in extrasArr) {
        // 优惠券
        if ([dicExtras[@"pid"] integerValue] == 2) {
            _couponInfo = dicExtras;
            if ([[dicExtras objectForKey:@"use_coupon_allowed"] integerValue] == 1) {
                self.isCanCoupon = YES;
            }
            continue;
        }
        // app立减
        if ([dicExtras[@"pid"] integerValue] == 1) {
            _rightReduce = dicExtras;
            CGFloat appcut = [[dicExtras objectForKey:@"value"] floatValue];
            if ([[purchaseDic objectForKey:@"total_payment"] compare:[dicExtras objectForKey:@"value"]] == NSOrderedDescending) {
                _totalPayment = _totalPayment - appcut;
                _discountfee = _discountfee + appcut;
            }else {
                //app立减已够使用
                _totalPayment = 0.0;
                _discountfee = [[purchaseDic objectForKey:@"total_payment"] floatValue];
                
                self.isEnoughRight = YES;
            }
            _rightAmount = [[dicExtras objectForKey:@"value"] floatValue];
            self.purchaseFooterView.appPayLabel.text = [NSString stringWithFormat:@"¥%.2f",_rightAmount];
            continue;
            
        }
        // 余额
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 3 && _totalPayment > 0) {
            _xlWallet = dicExtras;
            _availableFloat = [[dicExtras objectForKey:@"value"] floatValue];

            if ([[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedDescending ||[[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedSame) {
                //足够支付
                self.isEnoughBudget = YES;
            }else {
                //不足支付
                self.isEnoughBudget = NO;
            }
            
        }
    }
    
    _uuid = [purchaseDic objectForKey:@"uuid"];
    _cartIDs = [purchaseDic objectForKey:@"cart_ids"];
    _totalfee = [[purchaseDic objectForKey:@"total_fee"] floatValue];
    _postfee = [[purchaseDic objectForKey:@"post_fee"] floatValue];
    
    [self calculationLabelValue];
    
    
}
#pragma mark 计算最终选需要付款的金额
- (void)calculationLabelValue {
    self.purchaseFooterView.postLabel.text = [NSString stringWithFormat:@"¥%.2f",_postfee];
    _discount = _couponValue + _rightAmount;
    if (_discount - _amontPayment > 0.000001) {
        self.isCouponEnoughPay = YES;
        _discount = _amontPayment;
        self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
        NSString *pamentStr = [NSString stringWithFormat:@"应付金额%.2f", 0.00];
        self.purchaseFooterView.paymenLabel.attributedText = [self stringText:pamentStr];
        self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", 0.00];
    }else {
        self.isCouponEnoughPay = NO;
        if (self.isUseXLW) {
            CGFloat surplus = _amontPayment - _couponValue - _rightAmount;
            if (_availableFloat - surplus > 0.000001 || (fabs(_availableFloat - surplus) < 0.000001 || fabs(surplus - _couponValue) < 0.000001)) {
                //钱包金额够使用
                self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
                NSString *pamentStr = [NSString stringWithFormat:@"应付金额%.2f", 0.00];
                self.purchaseFooterView.paymenLabel.attributedText = [self stringText:pamentStr];
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _couponValue - _rightAmount - _availableFloat];
                NSString *pamentStr = [NSString stringWithFormat:@"应付金额%.2f", _amontPayment - _couponValue - _rightAmount - _availableFloat];
                self.purchaseFooterView.paymenLabel.attributedText = [self stringText:pamentStr];
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
            }
        }else {
            CGFloat surplus = _amontPayment - _couponValue - _rightAmount;
            if (_availableFloat - surplus > 0.000001 || (fabs(_availableFloat - surplus) < 0.000001 || fabs(surplus - _couponValue) < 0.000001)) {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
            }
            self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _discount];
            NSString *pamentStr = [NSString stringWithFormat:@"应付金额%.2f", _amontPayment - _discount];
            self.purchaseFooterView.paymenLabel.attributedText = [self stringText:pamentStr];
        }
    }
}
/**
 *  地址信息
 */
- (void)fetchedAddressData:(NSArray *)purchaseArr {
    if (purchaseArr.count == 0) {
        _addressID = @"";
    }else {
        NSDictionary *dic = purchaseArr[0];
        _addressID = dic[@"id"];
    }
    self.purchaseHeaderView.addressArr = purchaseArr;
    
}
#pragma mark 创建视图
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 90;
}
- (void)createTableHeaderView {
    self.purchaseHeaderView = [[JMPurchaseHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    self.tableView.tableHeaderView = self.purchaseHeaderView;
    self.purchaseHeaderView.delegate = self;
}
- (void)createTableFooterView {
    self.purchaseFooterView = [[JMPurchaseFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 390)];
    self.tableView.tableFooterView = self.purchaseFooterView;
    self.purchaseFooterView.delegate = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.purchaseGoodsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CartListModel *listModel = self.purchaseGoodsArr[indexPath.row];
    [cell configPurchaseModel:listModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 头部视图协议方法
- (void)composeHeaderTapView:(JMPurchaseHeaderView *)headerView TapClick:(NSInteger)index {
    // 100->地址信息点击  101->物流信息点击
    if (index == 100) {
        AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        addVC.isSelected = YES;
        addVC.delegate = self;
        [self.navigationController pushViewController:addVC animated:YES];
        
    }else if (index == 101) {
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        
        if (self.showViewVC.view == nil) {
            self.showViewVC = [[JMChoiseLogisController alloc] init];
        }
        self.showViewVC.dataSource = self.logisticsArr;
        NSInteger count = self.logisticsArr.count;
        self.showViewVC.count = count;
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 60 * (count + 1), SCREENWIDTH, 60 * count + 60)];
        
        self.showViewVC.delegate = self;
        menu.contentView = self.showViewVC.view;
    }else {
    
    }
}
- (void)coverDidClickCover:(JMShareView *)cover {
    //隐藏pop菜单
    [JMPopView hide];
}
/**
 *  添加地址回调方法
 */
- (void)addressView:(AddressViewController *)addressVC model:(AddressModel *)model{
    self.purchaseHeaderView.addressModel = model;
}
/**
 *  选择物流回调方法
 */
- (void)ClickLogistics:(JMChoiseLogisController *)click Model:(JMPopLogistcsModel *)model {
    [MobClick event:@"logistics_choose"];
    
    self.purchaseHeaderView.logisticsLabel.text = model.name;
    _logisticsID = model.logistcsID;
    
}
#pragma mark 底部视图按钮选择_处理事件
- (void)composeFooterButtonView:(JMPurchaseFooterView *)headerView UIButton:(UIButton *)button {
    // 100->优惠券  101->钱包  102->条款  103->结算
    if (button.tag == 100) {
        if (!self.isCanCoupon) {
            [SVProgressHUD showInfoWithStatus:@"当前优惠券不能使用!"];
            return ;
        }
        YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        vc.isSelectedYHQ = YES;
        vc.payment = _totalfee;
        vc.delegate = self;
        vc.selectedModelID = _yhqModelID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == 101) {
        if (_availableFloat > 0) {
            button.selected = !button.selected;
            if (button.selected) {
                self.isUseXLW = YES;
                [self calculationLabelValue];
            }else {
                self.isUseXLW = NO;
                [self calculationLabelValue];
            }
        }else {
            [SVProgressHUD showInfoWithStatus:@"钱包不可用"];
        }
    }else if (button.tag == 102) {
        button.selected = !button.selected;
        if (button.selected) { // 弹出框
            self.isAgreeTerms = YES;
            NSString *terms = @"购买条款：亲爱的小鹿用户，由于特卖商品购买人数过多和供应商供货原因，可能存在极少数用户出现缺货的情况。为了避免您长时间等待，一旦出现这种情况，我们在购买后1周会帮您自动退款，并补偿给您一张全场通用优惠券，订单向外贸工厂订货后无法退款，需要收货后走退货流程或者换货。质量问题退货会以现金券或小鹿余额形式补偿10元邮费。给您造成不便，敬请谅解！祝您购物愉快！本条款解释权归小鹿美美特卖商城所有。";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买条款" message:terms delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            self.isAgreeTerms = NO;
        }
    }else if (button.tag == 103) {
        if (!self.isAgreeTerms) {
            [SVProgressHUD showInfoWithStatus:@"请您阅读和同意购买条款!"];
            return ;
        }else {
            if (self.isUseXLW) {
                if (self.isEnoughBudget == NO) {
                    self.isXLWforAlipay = YES;
                    [self createPayPopView];
                }else {
                    self.isXLWforAlipay = NO;
                    [SVProgressHUD showWithStatus:@"小鹿正在为您支付....."];
                    [self payMoney];
                }
            }else {
                if (self.isCouponEnoughPay) {
                    [SVProgressHUD showWithStatus:@"小鹿正在为您支付....."];
                    [self payMoney];
                }else {
                    [self createPayPopView];
                }
            }
        }
    }else {}
}
#pragma mark 支付弹出框 点击去结算按钮的时候弹出
- (void)createPayPopView {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.payView];
    self.maskView.alpha = 0;
    self.payView.top = self.view.height - 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.payView.bottom = self.view.height;
    }];
}
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.payView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.payView removeFromSuperview];
    }];
}
#pragma mark --- 选择支付方式
- (void)composePayButton:(JMOrderPayView *)payButton didClick:(NSInteger)index {
    if (index == 100) { //点击后弹出选择放弃或者继续支付
        [self payBackAlter];
    }else if (index == 101) { // 选择了微信支付
        [SVProgressHUD showWithStatus:@"正在支付中....."];
        if (!self.isInstallWX) {
            [SVProgressHUD showErrorWithStatus:@"亲，没有安装微信哦!"];
            return ;
        }
        if (self.isEnoughBudget && self.isUseXLW) {
            _payMethod = @"wx";
        }else {
            _payMethod = @"wx";
        }
        [self hidePickerView];
        [self payMoney];
    }else if (index == 102) { // 选择了支付宝支付
        [SVProgressHUD showWithStatus:@"正在支付中....."];
        if (self.isEnoughBudget && self.isUseXLW) {
            _payMethod = @"alipay";
        }else {
            _payMethod = @"alipay";
        }
        [self hidePickerView];
        [self payMoney];
    }else{}
}
#pragma mark 支付提交参数处理
- (void)payMoney {
    self.purchaseFooterView.goPayButton.userInteractionEnabled = NO;
    if (_addressID == nil) {
        [SVProgressHUD showErrorWithStatus:@"收货地址不能为空,请填写收货地址"];
        return ;
    }
    NSString *parms = [NSString stringWithFormat:@"pid:%@:value:%@",_rightReduce[@"pid"],_rightReduce[@"value"]];
    _parmsStr = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&post_fee=%@&total_fee=%@&uuid=%@",_cartIDs,_addressID,[NSString stringWithFormat:@"%.2f", _postfee],[NSString stringWithFormat:@"%.2f", _totalfee],_uuid];
    //是否使用优惠券
    if (self.isUserCoupon && self.isEnoughCoupon && self.isCouponEnoughPay) {
        _totalPayment = 0.00;
        _discountfee = _discountfee + _couponValue;
        parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:use_coupon_allowed:%.2f", parms,  _couponInfo[@"pid"], self.yhqModel.ID, _couponValue];
        _parmsStr = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%@&channel=%@&pay_extras=%@",_parmsStr,_discount,[NSNumber numberWithFloat:_totalPayment], @"budget", parms];
        [self submitBuyGoods];
    }else {
        if (self.isUserCoupon && self.isEnoughCoupon) {//使用不足
            parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:value:%.2f", parms, _couponInfo[@"pid"], self.yhqModel.ID, _couponValue];
            _discountfee = _discountfee + _couponValue;
        }else {//未使用
            if (!self.isUseXLW && _payMethod.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一种支付方式"];
                return;
            }
        }
        //不足需要使用小鹿钱包或者其它支付方式
        _totalPayment = _totalPayment - _couponValue;
        if (self.isUseXLW && (self.isEnoughBudget || _totalPayment < (_availableFloat + _couponValue) || fabs(_totalPayment - (_availableFloat + _couponValue)) < 0.000001 )) {//使用了小鹿钱包 足够提交信息
            CGFloat value = [[_xlWallet objectForKey:@"value"] floatValue];
            if (_totalPayment > value) {
                parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], value];
            }else {
                parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], _totalPayment];
            }
            if (self.isXLWforAlipay) {
                _parmsStr = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@", _parmsStr, _discount,[[NSNumber numberWithFloat:_totalPayment] floatValue],_payMethod, parms];
            }else {
                _parmsStr = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@", _parmsStr, _discount,[[NSNumber numberWithFloat:_totalPayment] floatValue],@"budget", parms];
            }
            [self submitBuyGoods];
        }else {
            if (self.isUseXLW) {
                CGFloat value = [[_xlWallet objectForKey:@"value"] floatValue];
                if (_totalPayment > value) {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], value];
                }else {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], _totalPayment];
                }
            }else {
                if (_payMethod.length == 0) {
                    [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
                    return;
                }
            }
            if (_payMethod.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"余额不足请选择支付方式"];
                return;
            }
            _parmsStr = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@",_parmsStr,_discount, [[NSNumber numberWithFloat:_totalPayment] floatValue], _payMethod, parms];
            [self submitBuyGoods];
        }
    }
}
#pragma mark 支付提交请求
- (void)submitBuyGoods {
    [MobClick event:@"commit_buy"];
    NSMutableString *paramString = [NSMutableString stringWithFormat:@"%@",_parmsStr];
    [paramString appendFormat:[NSString stringWithFormat:@"&logistics_company_id=%@",_logisticsID],nil];
    NSMutableDictionary *params = [self stringChangeDictionary:paramString];
    
    NSString *payurlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/shoppingcart_create",Root_URL];
    JMPurchaseController * __weak weakSelf = self;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:payurlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [SVProgressHUD dismiss];
        NSDictionary *dict = responseObject[@"trade"];
        _orderTidNum = dict[@"tid"];
        if ([responseObject[@"code"] integerValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",(unsigned long)[responseObject[@"code"] integerValue]]};
                [MobClick event:@"buy_fail" attributes:temp_dict];
                [SVProgressHUD dismiss];
                NSString *errorStr = responseObject[@"info"];
                NSString *messageStr = [NSString stringWithFormat:@"%@,请在购物车重新选择提交.",errorStr];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付异常" message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 101;
                [alert show];
            });
            return;
        }
        if ([responseObject[@"channel"] isEqualToString:@"budget"] && [responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MobClick event:@"buy_succ"];
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [self pushShareVC];
            });
            return;
        }
        NSDictionary *chargeDic = responseObject[@"charge"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chargeDic options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (![responseObject[@"channel"] isEqualToString:@"budget"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
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
                            NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
                            [MobClick event:@"buy_fail" attributes:temp_dict];
                            NSLog(@"%@",error);
                            [self performSelector:@selector(backClick) withObject:nil afterDelay:1.0];
                        }
                        
                    }
                    
                }];
            });
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"支付请求失败,请稍后重试!"];
    }];
}
#pragma mark ------ 选择优惠券回调过来的代理方法
- (void)updateYouhuiquanWithmodel:(YHQModel *)model {
    self.yhqModel = model;
    _couponValue = [model.coupon_value floatValue];
    if (model == nil) {
        self.purchaseFooterView.couponLabel.text = @"没有使用优惠券";
        self.purchaseFooterView.couponLabel.textColor = [UIColor dingfanxiangqingColor];
        _yhqModelID = @"";
        self.isUserCoupon = NO;
        _couponValue = 0;
        [self calculationLabelValue];
    }else {
        self.isUserCoupon = YES;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@&coupon_id=%@", Root_URL,self.paramstring,model.ID];
        [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            GoodsInfoModel *goodsModel = [GoodsInfoModel mj_objectWithKeyValues:responseObject];
            NSString *couponMessage = goodsModel.coupon_message;
            if (couponMessage.length == 0) {
                self.isEnoughCoupon = YES;
                self.purchaseFooterView.couponLabel.text = [NSString stringWithFormat:@"¥%@元优惠券", model.coupon_value];   // === > 返回可以减少的金额
                self.purchaseFooterView.couponLabel.textColor = [UIColor buttonEnabledBackgroundColor];
                _yhqModelID = [NSString stringWithFormat:@"%@", model.ID];
                [self calculationLabelValue];
            }else {
                [SVProgressHUD showInfoWithStatus:goodsModel.coupon_message];
                self.purchaseFooterView.couponLabel.text = @"没有使用优惠券";
                self.purchaseFooterView.couponLabel.textColor = [UIColor dingfanxiangqingColor];
                self.isEnoughCoupon = NO;
                _couponValue = 0;
                [self calculationLabelValue];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.isEnoughCoupon = NO;
            [SVProgressHUD showInfoWithStatus:@"网络出错，优惠券暂不可选"];
        }];
    }
}
#pragma mark alterView 弹出与协议方法
- (void)payBackAlter {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"限时好货不等人,机不可失哦" delegate:self cancelButtonTitle:@"放弃订单" otherButtonTitles:@"继续支付", nil];
    alterView.tag = 100;
    [alterView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self hidePickerView];
            [self backClick];
        }else {}
    }else if (alertView.tag == 101) {
        [self backClick];
    }
}
#pragma mark 支付成功或取消后续操作
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = _orderTidNum;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popview{
    [MobClick event:@"buy_cancel"];
    PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
    orderVC.index = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark 支付成功的弹出框
- (void)paySuccessful{
    [MobClick event:@"buy_succ"];
    [self pushShareVC];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
}
#pragma mark 视图生命周期操作
- (NSMutableAttributedString *)stringText:(NSString *)string {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLength = string.length;
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(4, strLength - 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.] range:NSMakeRange(0,4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.] range:NSMakeRange(4, strLength - 4)];
    return str;
}
- (NSMutableDictionary *)stringChangeDictionary:(NSString *)str {
    NSArray *firstArr = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *segment in firstArr) {
        NSArray *secondArr = [segment componentsSeparatedByString:@"="];
        [dic setObject:secondArr[1] forKey:secondArr[0]];
    }
    return dic;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.purchaseFooterView.goPayButton.userInteractionEnabled = YES;
    [self.tableView.mj_header beginRefreshing];
    if ([WXApi isWXAppInstalled]) {
        self.isInstallWX = YES;
    }else {
        self.isInstallWX = NO;
    }
    [MobClick beginLogPageView:@"purchase"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"purchase"];
}
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    NSLog(@"purchaseViewWillEnterForeground ");
    self.purchaseFooterView.goPayButton.userInteractionEnabled = YES;
}
@end














































































































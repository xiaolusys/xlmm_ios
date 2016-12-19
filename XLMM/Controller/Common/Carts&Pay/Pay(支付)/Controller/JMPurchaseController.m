//
//  JMPurchaseController.m
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPurchaseController.h"
#import "JMPurchaseHeaderView.h"
#import "JMPurchaseFooterView.h"
#import "JMBaseGoodsCell.h"
#import "CartListModel.h"
#import "JMChoiseLogisController.h"
#import "JMPopLogistcsModel.h"
#import "AddressViewController.h"
#import "AddressModel.h"
#import "GoodsInfoModel.h"
#import "JMOrderPayView.h"
#import "UIView+RGSize.h"
#import "WXApi.h"
//#import "Pingpp.h"
#import "PersonOrderViewController.h"
#import "JMPayShareController.h"
#import "JMSegmentController.h"
#import "JMCouponModel.h"
#import "JMDelayPopView.h"
#import "JMPopViewAnimationSpring.h"
#import "WebViewController.h"
#import "JMRichTextTool.h"
#import "JMPayment.h"



@interface JMPurchaseController ()<UIAlertViewDelegate,JMOrderPayViewDelegate,JMSegmentControllerDelegate,PurchaseAddressDelegate,JMChoiseLogisControllerDelegate,UITableViewDataSource,UITableViewDelegate,JMPurchaseHeaderViewDelegate,JMPurchaseFooterViewDelegate> {
    NSDictionary *_couponData;
    NSTimer *_timer;
    NSString *_logisticsID;           // 选择物流的ID
    NSDictionary *_couponInfo;        // 优惠券
    NSDictionary *_rightReduce;       // app立减
    NSDictionary *_xlWallet;          // 钱包
    
    NSString *_payMethod;             //支付方式
    float _totalPayment;              //应付款金额
    float _discountfee;               //优惠券金额
    NSString *_couponStringID;        // 优惠券ID
    float _rightAmount;               //app优惠
    float _availableFloat;            //小鹿钱包余额
    
    NSString *_uuid;                  //uuid
    NSString *_cartIDs;               //购物车id
    float _totalfee;                  //总金额
    float _postfee;                   //运费金额`
    float _amontPayment;              //总需支付金额
    float _couponValue;               //优惠券金额
    float _discount;                  //计算金额
    
    NSString *_yhqModelID;            //优惠券ID
    NSString *_addressID;             //地址信息ID
    NSString *_parmsStr;              //支付提交参数
    
    NSString *_limitStr;              //分享红包数量
    NSString *_orderTidNum;           //订单编号
    NSInteger _flagCount;             //标志是否弹出延迟框
    BOOL _isTeamBuyGoods;             //是否为团购
    BOOL _isBondedGoods;              //是否为保税商品
    BOOL _isIndentifierNum;           // 身份证号是否为空
    NSInteger _couponNumber;          // 优惠券购买商品个数
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JMPurchaseHeaderView *purchaseHeaderView;

@property (nonatomic, strong) JMPurchaseFooterView *purchaseFooterView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic, strong) JMDelayPopView *delayView;
@property (nonatomic,strong) JMOrderPayView *payView;

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
@property (nonatomic, strong) JMCouponModel *yhqModel;
/**
 *  判断小鹿钱包是否足够支付->如果不足则调用微信或者支付宝，传payment。否则传budget。
 */
@property (nonatomic,assign) BOOL isXLWforAlipay;

@end

static BOOL isAgreeTerms = YES;

@implementation JMPurchaseController


- (NSMutableArray *)logisticsArr {
    if (!_logisticsArr) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}
- (NSMutableArray *)purchaseGoodsArr {
    if (!_purchaseGoodsArr) {
        _purchaseGoodsArr = [NSMutableArray array];
    }
    return _purchaseGoodsArr;
}
- (JMChoiseLogisController *)showViewVC {
    if (!_showViewVC) {
        _showViewVC = [[JMChoiseLogisController alloc] init];
        _showViewVC.delegate = self;
    }
    return _showViewVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backClick)];
    
    self.isCanCoupon = NO;
    self.isUseXLW = NO;
    self.isEnoughRight = NO;
    self.isEnoughBudget = NO;
    self.isEnoughCoupon = NO;
    self.isUserCoupon = NO;
    self.isCouponEnoughPay = NO;
    _isIndentifierNum = NO;
    _isBondedGoods = NO;
    
    _totalPayment = 0;              //应付款金额
    _discountfee = 0;               //优惠券金额
    _rightAmount = 0;               //app优惠
    _availableFloat = 0;            //小鹿钱包余额
    
    _totalfee = 0;                  //总金额
    _postfee = 0;                   //运费金额
    _amontPayment = 0;              //总需支付金额
    _couponValue = 0;               //优惠券金额
    _discount = 0;                  //计算金额
    _flagCount = 0;                 //标志是否弹出延迟框
    
    [self getCartID];
    [self initView];
    [self createTableView];
    [self createTableHeaderView];
    [self createTableFooterView];
    [self loadAddressInfo];
    [self loadDataSource];
    
    if (isAgreeTerms) {
        self.purchaseFooterView.termsButton.selected = YES;
    }else {
        self.purchaseFooterView.termsButton.selected = NO;
    }
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
- (void)getCartID {
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.purchaseGoodsArr.count == 0) {
        return;
    }
    for (CartListModel *model in self.purchaseGoodsArr) {
        NSString *str = [NSString stringWithFormat:@"%ld,",model.cartID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    self.paramstring = paramstring;
    _cartIDs = [paramstring copy];
}
#pragma mark 订单支付网络请求
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/carts_payinfo?cart_ids=%@&device=%@", Root_URL,self.paramstring,@"app"];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.logisticsArr removeAllObjects];
        [self fetchedCartsData:responseObject];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取数据失败"];
    } Progress:^(float progress) {
    }];
}
#pragma mark 地址信息网络请求
- (void)loadAddressInfo {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kAddress_List_URL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchedAddressData:responseObject];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取数据失败"];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchedAddressData:(NSArray *)purchaseArr {
    if (purchaseArr.count == 0) {
        _addressID = @"";
        _isIndentifierNum = YES;
    }else {
        NSDictionary *dic = purchaseArr[0];
        _addressID = [dic[@"id"] stringValue];
        if ([NSString isStringEmpty:dic[@"identification_no"]]) {
            _isIndentifierNum = YES;
        }else {
            _isIndentifierNum = NO;
        }
    }
    self.purchaseHeaderView.addressArr = purchaseArr;
    
    if (_isIndentifierNum && _isBondedGoods) {
        [self userNotIdCardNumberMessage];
    }
    
}
#pragma mark 订单支付信息显示
- (void)fetchedCartsData:(NSDictionary *)purchaseDic {
    [self.purchaseGoodsArr removeAllObjects];
    NSArray *goodsArr = purchaseDic[@"cart_list"];
    NSDictionary *teamGoodsDic = goodsArr[0];
    if ([self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
        _couponNumber = [teamGoodsDic[@"num"] integerValue];
    }else {
        _couponNumber = 1;
    }
    for (NSDictionary *dic in goodsArr) {
        if ([dic[@"is_bonded_goods"] boolValue]) {
            _isBondedGoods = (_isBondedGoods || YES);
        }else {
            _isBondedGoods = (_isBondedGoods || NO);
        }
        CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
        [self.purchaseGoodsArr addObject:model];
    }
    NSInteger isTeamCode = [[teamGoodsDic objectForKey:@"type"] integerValue];
    if ([teamGoodsDic isKindOfClass:[NSDictionary class]] && isTeamCode == 3) {
        _isTeamBuyGoods = YES;
    }else {
        _isTeamBuyGoods = NO;
    }
    NSArray *logArr = purchaseDic[@"logistics_companys"];
    NSDictionary *logisticsDic = logArr[0];
    _logisticsID = logisticsDic[@"id"];
    for (NSDictionary *dic in logArr) {
        JMPopLogistcsModel *logisticsModel = [JMPopLogistcsModel mj_objectWithKeyValues:dic];
        [self.logisticsArr addObject:logisticsModel];
    }
    self.showViewVC.dataSource = self.logisticsArr;
    self.showViewVC.count = self.logisticsArr.count;
    
    _amontPayment = [[purchaseDic objectForKey:@"total_payment"] floatValue];
    _totalPayment = [[purchaseDic objectForKey:@"total_payment"] floatValue];
    _discountfee = [[purchaseDic objectForKey:@"discount_fee"] floatValue];
    
    //NSLog(@"purchaseDic %@", purchaseDic);
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
            float appcut = [[dicExtras objectForKey:@"value"] floatValue];
            if (_totalPayment - appcut > 1e-6) {
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
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 3) {
            _xlWallet = dicExtras;
            _availableFloat = [[dicExtras objectForKey:@"value"] floatValue];
//            if ([[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedDescending ||[[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedSame) {
//                //足够支付
//                self.isEnoughBudget = YES;
//            }else {
//                //不足支付
//                self.isEnoughBudget = NO;
//            }
        }
    }
    _uuid = [purchaseDic objectForKey:@"uuid"];
    _cartIDs = [purchaseDic objectForKey:@"cart_ids"];
    _totalfee = [[purchaseDic objectForKey:@"total_fee"] floatValue];
    _postfee = [[purchaseDic objectForKey:@"post_fee"] floatValue];
    [self calculationLabelValue];
    
    if (_isIndentifierNum && _isBondedGoods) {
        [self userNotIdCardNumberMessage];
    }
}
- (void)userNotIdCardNumberMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您购买的商品为保税商品,需要您填写身份证号哦~\n点击\"地址-修改-填写身份证号\"填写一下吧" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark 计算最终选需要付款的金额
- (void)calculationLabelValue {
    self.purchaseFooterView.postLabel.text = [NSString stringWithFormat:@"¥%.2f",_postfee];
    _discount = _couponValue + _rightAmount;
    if (_discount - _amontPayment > 0.00001 || fabsf(_discount - _amontPayment) <= 0.00001) {
        self.isCouponEnoughPay = YES;
        if (self.isUseXLW) {
            self.isEnoughBudget = YES;
        }else {
            self.isEnoughBudget = NO;
        }
//        self.isEnoughBudget = self.isUseXLW ? YES : NO;
        _discount = _amontPayment;
        self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
        NSString *paymentStr = [NSString stringWithFormat:@"%.2f",0.00];
        NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_amontPayment];
        NSString *amontPatStr = [NSString stringWithFormat:@"%.2f",_amontPayment];
        self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,amontPatStr]];//[self stringText:mutableStr WithStr:paymentStr];
        self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", 0.00];
    }else {
        self.isCouponEnoughPay = NO;
        if (self.isUseXLW) {
            float surplus = _amontPayment - _couponValue - _rightAmount;
            if (_availableFloat - surplus > 0.00001 || fabsf(_availableFloat - surplus) <= 0.00001) {
                //钱包金额够使用
                self.isEnoughBudget = YES;
                self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
                NSString *paymentStr = [NSString stringWithFormat:@"%.2f",0.00];
                NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_discount];
                NSString *discountStr = [NSString stringWithFormat:@"%.2f",_discount];
                self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,discountStr]];//[self stringText:mutableStr WithStr:paymentStr];
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                self.isEnoughBudget = NO;
                self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _couponValue - _rightAmount - _availableFloat];
                NSString *paymentStr = [NSString stringWithFormat:@"%.2f",_amontPayment - _couponValue - _rightAmount - _availableFloat];
                NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_discount];
                NSString *discountStr = [NSString stringWithFormat:@"%.2f",_discount];
                self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,discountStr]];//[self stringText:mutableStr WithStr:paymentStr];
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
            }
        }else {
            float surplus = _amontPayment - _couponValue - _rightAmount;
            if (_availableFloat - surplus > 0.00001 || fabsf(_availableFloat - surplus) <= 0.00001) {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
            }
            self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _discount];
            NSString *paymentStr = [NSString stringWithFormat:@"%.2f",_amontPayment - _discount];
            NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_discount];
            NSString *discountStr = [NSString stringWithFormat:@"%.2f",_discount];
            self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,discountStr]];//[self stringText:mutableStr WithStr:paymentStr];
        }
    }
}
#pragma mark 创建视图
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 110.;
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
#pragma mark 地址信息,物流信息选择.
- (void)composeHeaderTapView:(JMPurchaseHeaderView *)headerView TapClick:(NSInteger)index {
    // 100->地址信息点击  101->物流信息点击
    if (index == 100) {
        AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        addVC.isButtonSelected = YES;
        addVC.addressID = _addressID;
        addVC.isSelected = YES;
        addVC.isBondedGoods = _isBondedGoods;
        addVC.delegate = self;
        [self.navigationController pushViewController:addVC animated:YES];
    }else if (index == 101) {
        NSInteger count = self.logisticsArr.count;
        [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 60 * (count + 1)) ViewController:self.showViewVC WithBlock:^(UIView *maskView) {
        }];
    }else { }
}
#pragma mark 选择地址,选择物流回调
- (void)addressView:(AddressViewController *)addressVC model:(AddressModel *)model{
    self.purchaseHeaderView.addressModel = model;
    _addressID = model.addressID;
    if ([NSString isStringEmpty:model.identification_no]) {
        _isIndentifierNum = YES;
    }else {
        _isIndentifierNum = NO;
    }
}
- (void)ClickLogistics:(JMChoiseLogisController *)click Model:(JMPopLogistcsModel *)model {
    [MobClick event:@"logistics_choose"];
    self.purchaseHeaderView.logisticsLabel.text = model.name;
    _logisticsID = model.logistcsID;
}
#pragma mark 底部视图按钮选择_处理事件
- (void)composeFooterButtonView:(JMPurchaseFooterView *)headerView UIButton:(UIButton *)button {
    // 100->优惠券  101->钱包  102->条款  103->结算
    if (button.tag == 100) {
        button.enabled = NO;
        [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
        JMSegmentController *segmentVC = [[JMSegmentController alloc] init];
        segmentVC.cartID = _cartIDs;
        segmentVC.isSelectedYHQ = YES;
        segmentVC.selectedModelID = _yhqModelID;
        segmentVC.couponNumber = _couponNumber;
        segmentVC.directBuyGoodsTypeNumber = self.directBuyGoodsTypeNumber;
//        segmentVC.couponData = _couponData;
        segmentVC.delegate = self;
        [self.navigationController pushViewController:segmentVC animated:YES];
//        if (!self.isCanCoupon) {
//            [SVProgressHUD showInfoWithStatus:@"当前优惠券不能使用!"];
//            return ;
//        }
//        YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
//        vc.isSelectedYHQ = YES;
//        vc.payment = _totalfee;
//        vc.delegate = self;
//        vc.selectedModelID = _yhqModelID;
//        [self.navigationController pushViewController:vc animated:YES];
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
            [MBProgressHUD showWarning:@"钱包不可用"];
        }
    }else if (button.tag == 102) {
        button.selected = !button.selected;
        if (button.selected) {
            isAgreeTerms = YES;
        }else {
            isAgreeTerms = NO;
        }
    }else if (button.tag == 103) {
        button.enabled = NO;
        [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
        if (_isIndentifierNum && _isBondedGoods) {
            [self userNotIdCardNumberMessage];
            return ;
        }
        if (!isAgreeTerms) {
//            [SVProgressHUD showInfoWithStatus:@"请您阅读和同意购买条款!"];
            [MBProgressHUD showWarning:@"请您阅读和同意购买条款!"];
            return ;
        }else {
            if (self.isUseXLW) {
                if (self.isEnoughBudget == NO) {
                    self.isXLWforAlipay = YES;
                    [self createPayPopView];
                }else {
                    self.isXLWforAlipay = NO;
//                    [SVProgressHUD showWithStatus:@"小鹿正在为您支付....."];
                    [MBProgressHUD showLoading:@"小鹿正在为您支付....."];
                    [self payMoney];
                }
            }else {
                if (self.isCouponEnoughPay) {
                    [MBProgressHUD showLoading:@"小鹿正在为您支付....."];
                    [self payMoney];
                }else {
                    [self createPayPopView];
                }
            }
        }
    }else {}
}
- (void)changeButtonStatus:(UIButton *)button {
    NSLog(@"button.enabled = YES; ========== ");
    button.enabled = YES;
}
- (void)composeFooterTapView:(JMPurchaseFooterView *)headerView {
    NSString *terms = promptMessage_termsOfPurchase;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买条款" message:terms delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
        _flagCount ++;
//        [SVProgressHUD showWithStatus:@"正在支付中....."];
        [MBProgressHUD showLoading:@"正在支付中....."];
        if (!self.isInstallWX) {
            _flagCount --;
//            [SVProgressHUD showErrorWithStatus:@"亲，没有安装微信哦!"];
            [MBProgressHUD showError:@"亲，没有安装微信哦!"];
            return ;
        }
        _payMethod = @"wx";
        [self hidePickerView];
        [self payMoney];
    }else if (index == 102) { // 选择了支付宝支付
        _flagCount ++;
        [MBProgressHUD showLoading:@"正在支付中....."];
        _payMethod = @"alipay";
        [self hidePickerView];
        [self payMoney];
    }else{}
}
#pragma mark 支付提交参数处理
- (void)payMoney {
    self.purchaseFooterView.goPayButton.userInteractionEnabled = NO;
    if (_addressID == nil) {
//        [SVProgressHUD showErrorWithStatus:@"收货地址不能为空,请填写收货地址"];
        [MBProgressHUD showError:@"收货地址不能为空,请填写收货地址"];
        return ;
    }
    NSString *parms = [NSString stringWithFormat:@"pid:%@:value:%@",_rightReduce[@"pid"],_rightReduce[@"value"]];
    _parmsStr = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&post_fee=%@&total_fee=%@&uuid=%@",_cartIDs,_addressID,[NSString stringWithFormat:@"%.2f", _postfee],[NSString stringWithFormat:@"%.2f", _totalfee],_uuid];
    //是否使用优惠券
    if (self.isUserCoupon && self.isEnoughCoupon && self.isCouponEnoughPay) {
        _totalPayment = 0.00;
        _discountfee = _discountfee + _couponValue;
        parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:use_coupon_allowed:%.2f", parms,  _couponInfo[@"pid"], _couponStringID, _couponValue];
        _parmsStr = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%@&channel=%@&pay_extras=%@",_parmsStr,_discount,[NSNumber numberWithFloat:_totalPayment], @"budget", parms];
        [self submitBuyGoods];
    }else {
        if (self.isUserCoupon && self.isEnoughCoupon) {//使用不足
            parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:value:%.2f", parms, _couponInfo[@"pid"], _couponStringID, _couponValue];
            _discountfee = _discountfee + _couponValue;
        }else {//未使用
            if (!self.isUseXLW && _payMethod.length == 0) {
                [MBProgressHUD showError:@"请至少选择一种支付方式"];
                return;
            }
        }
        //不足需要使用小鹿钱包或者其它支付方式
        _totalPayment = _totalPayment - _couponValue;
        if (self.isUseXLW && (self.isEnoughBudget || _totalPayment < (_availableFloat + _couponValue) || fabsf(_totalPayment - (_availableFloat + _couponValue)) < 0.00001 )) {//使用了小鹿钱包 足够提交信息
            float value = [[_xlWallet objectForKey:@"value"] floatValue];
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
                float value = [[_xlWallet objectForKey:@"value"] floatValue];
                if (_totalPayment > value) {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], value];
                }else {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [_xlWallet objectForKey:@"pid"], _totalPayment];
                }
            }else {
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
    if (_isTeamBuyGoods) {
        params[@"order_type"] = @"3";
    }
    NSString *payurlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/shoppingcart_create",Root_URL];
//    JMPurchaseController * __weak weakSelf = self;
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:payurlStr WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [MBProgressHUD hideHUD];
        NSDictionary *dict = responseObject[@"trade"];
        _orderTidNum = dict[@"tid"];
        if ([responseObject[@"code"] integerValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",(unsigned long)[responseObject[@"code"] integerValue]]};
                [MobClick event:@"buy_fail" attributes:temp_dict];
                [MBProgressHUD hideHUD];
                NSString *errorStr = responseObject[@"info"];
                NSString *messageStr = [NSString stringWithFormat:@"%@",errorStr];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付异常" message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 101;
                [alert show];
            });
            return;
        }
        if ([responseObject[@"channel"] isEqualToString:@"budget"] && [responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [_timer invalidate];
                [MobClick event:@"buy_succ"];
//                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [MBProgressHUD showSuccess:@"支付成功"];
                if (_isTeamBuyGoods) {
                    [self getTeam:_orderTidNum]; // == > 团购信息
                }else {
                    [self pushShareVC];
                }
            });
            return;
        }
        NSDictionary *chargeDic = responseObject[@"charge"];
        if (![responseObject[@"channel"] isEqualToString:@"budget"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JMPayment createPaymentWithType:thirdPartyPayMentTypeForWechat Parame:chargeDic URLScheme:kUrlScheme ErrorCodeBlock:^(JMPayError *error) {
                    NSLog(@"%ld",error.errorStatus);
                    if (error.errorStatus == payMentErrorStatusSuccess) {
                        [self paySuccessful];
                    }else if (error.errorStatus == payMentErrorStatusFail) { // 取消
                        [self popview];
                    }else { }
                }];
            });
        }
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [_timer invalidate];
//        [SVProgressHUD showErrorWithStatus:@"支付请求失败,请稍后重试!"];
        [MBProgressHUD showError:@"支付请求失败,请稍后重试!"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark  选择优惠券回调过来的代理方法
- (void)updateYouhuiquanWithmodel:(NSArray *)modelArray {
    if (modelArray.count == 0) {
        self.purchaseFooterView.couponLabel.text = @"没有使用优惠券";
        self.purchaseFooterView.couponLabel.textColor = [UIColor dingfanxiangqingColor];
        self.isUserCoupon = NO;
        self.isEnoughCoupon = NO;
        _couponValue = 0;
        _couponStringID = @"";
        [self calculationLabelValue];
    }else {
        self.isUserCoupon = YES;
        self.isEnoughCoupon = YES;
        JMCouponModel *model = modelArray[0];
        if (modelArray.count > 1) {
            NSMutableString *couponID = [[NSMutableString alloc] init];
            for (JMCouponModel *model in modelArray) {
                _couponValue += [model.coupon_value floatValue];
                [couponID appendFormat:@"%@%@",model.couponID,@"/"];
            }
            if ([couponID hasSuffix:@"/"]) {
                [couponID deleteCharactersInRange:NSMakeRange(couponID.length - 1, 1)];
            }
            self.purchaseFooterView.couponLabel.text = [NSString stringWithFormat:@"¥%.1f元优惠券 × %ld", [model.coupon_value floatValue],modelArray.count];
            self.purchaseFooterView.couponLabel.textColor = [UIColor buttonEnabledBackgroundColor];
            _couponStringID = [couponID copy];
            _yhqModelID = [NSString stringWithFormat:@"%@", _couponStringID];
            [self calculationLabelValue];
        }else {
            self.purchaseFooterView.couponLabel.text = [NSString stringWithFormat:@"¥%.1f元优惠券", [model.coupon_value floatValue]];   // === > 返回可以减少的金额
            self.purchaseFooterView.couponLabel.textColor = [UIColor buttonEnabledBackgroundColor];
            _couponValue = [model.coupon_value floatValue];
            _couponStringID = model.couponID;
            _yhqModelID = [NSString stringWithFormat:@"%@", _couponStringID];
            [self calculationLabelValue];
        }
        
    }
}
#pragma mark 团购支付
- (void)getTeamID:(NSString *)teamID {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/teambuy/%@/team_info",Root_URL,teamID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self getTeam:responseObject[@"id"]];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)getTeam:(NSString *)teamID {
    [MBProgressHUD hideHUD];
    NSString *string = [NSString stringWithFormat:@"%@/mall/order/spell/group/%@?from_page=order_commit",Root_URL,teamID];
    NSDictionary *diction = [NSMutableDictionary dictionary];
    [diction setValue:string forKey:@"web_url"];
    [diction setValue:@"teamBuySuccess" forKey:@"type_title"];
    WebViewController *webView = [[WebViewController alloc] init];
    webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:diction];
    webView.isShowNavBar = true;
    webView.isShowRightShareBtn = false;
    [self.navigationController pushViewController:webView animated:YES];
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
    }else if (alertView.tag == 102) {
        [MobClick event:@"buy_cancel"];
        PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
        orderVC.index = 101;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else {}
}
#pragma mark 支付成功或取消后续操作
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = _orderTidNum;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popview{
    [MBProgressHUD hideHUD];
    [_timer invalidate];
    [MobClick event:@"buy_cancel"];
    PersonOrderViewController *orderVC = [[PersonOrderViewController alloc] init];
    orderVC.index = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark 支付成功的弹出框
- (void)paySuccessful{
    [MBProgressHUD hideHUD];
    [_timer invalidate];
    [MobClick event:@"buy_succ"];
    if (_isTeamBuyGoods) {
        [self getTeam:_orderTidNum]; // == > 团购信息
    }else {
        [self pushShareVC];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
}
#pragma mark 视图生命周期操作
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
    if ([WXApi isWXAppInstalled]) {
        self.isInstallWX = YES;
    }else {
        self.isInstallWX = NO;
    }
    [MobClick beginLogPageView:@"purchase"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:app];
    [MobClick endLogPageView:@"purchase"];
}
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification {
    //进入前台时调用此函数
    NSLog(@"purchaseViewWillEnterForeground ");
    self.purchaseFooterView.goPayButton.userInteractionEnabled = YES;
    if (_flagCount > 0) {
        [MBProgressHUD showLoading:@""];
        _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(doSomeWork) userInfo:nil repeats:NO];
    }
    _flagCount --;
}

- (void)doSomeWork {
    [MBProgressHUD hideHUD];
    // Simulate by just waiting.
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"支付被您取消或支付失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alterView.tag = 102;
    [alterView show];
    
}

@end














































































//        NSError *parseError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chargeDic options:NSJSONWritingPrettyPrinted error:&parseError];
//        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                [JMPayment payMentManager].errorCodeBlock = ^(int errorCode) {
//                    NSLog(@"%d",errorCode);
//                    if (errorCode == 0) {
//                        [self paySuccessful];
//                    }else {
//                        [self popview];
//                    }
//                };
//                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                    if (error == nil) {
//                        [MBProgressHUD hideHUD];
//                        [_timer invalidate];
//                        [MBProgressHUD showSuccess:@"支付成功"];
//                        [MobClick event:@"buy_succ"];
//                        if (_isTeamBuyGoods) {
//                            [self getTeam:_orderTidNum]; // == > 团购信息
//                        }else {
//                            [self pushShareVC];
//                        }
//                    } else {
//                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
//                            [MBProgressHUD hideHUD];
//                            [_timer invalidate];
//                            [MBProgressHUD showError:@"用户取消支付"];
//                            [MobClick event:@"buy_cancel"];
//                            [self popview];
//                        } else {
//                            [MBProgressHUD hideHUD];
//                            [_timer invalidate];
//                            [MBProgressHUD showError:@"支付失败"];
//                            NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
//                            [MobClick event:@"buy_fail" attributes:temp_dict];
//                            NSLog(@"%@",error);
//                            [self performSelector:@selector(backClick) withObject:nil afterDelay:1.0];
//                        }
//                    }
//                }];

/**

- (NSMutableAttributedString *)stringText:(NSString *)string WithStr:(NSString *)payString {
 NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
 NSInteger payLength = payString.length;
 NSInteger strLength = string.length;
 [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(0,4)];
 [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(4, payLength)];
 [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(4 + payLength, strLength - 4 - payLength)];
 [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.] range:NSMakeRange(0,4)];
 [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.] range:NSMakeRange(4,payLength)];
 [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.] range:NSMakeRange(4 + payLength, strLength - 4 - payLength)];
 return str;
 }
 */




//        if ((modelArray.count < _couponNumber) && [self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
//            self.purchaseFooterView.couponLabel.text = @"精品优惠券不足支付哦~!";
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"购买提示" message:@"精品汇优惠券不足，请购买优惠券或减少商品购买数量。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
//            return ;
//        }

//        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@&coupon_id=%@", Root_URL,self.paramstring,model.couponID];
//        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//            if (!responseObject) {
//                [MBProgressHUD showWarning:@"请重新选择优惠券~!"];
//                [self reassignCoupn];
//                return ;
//            }
//            GoodsInfoModel *goodsModel = [GoodsInfoModel mj_objectWithKeyValues:responseObject];
//            NSString *couponMessage = goodsModel.coupon_message;
//            if (couponMessage.length == 0) {
//                self.isEnoughCoupon = YES;
//                if ([self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
//                    self.purchaseFooterView.couponLabel.text = [NSString stringWithFormat:@"¥%.1f元优惠券 × %ld", [model.coupon_value floatValue],modelArray.count];
//                }else {
//                    self.purchaseFooterView.couponLabel.text = [NSString stringWithFormat:@"¥%.1f元优惠券", [model.coupon_value floatValue]];   // === > 返回可以减少的金额
//                }
//                self.purchaseFooterView.couponLabel.textColor = [UIColor buttonEnabledBackgroundColor];
//                _yhqModelID = [NSString stringWithFormat:@"%@", _couponStringID];
//                [self calculationLabelValue];
//            }else {
//                [MBProgressHUD showWarning:goodsModel.coupon_message];
//                [self reassignCoupn];
//            }
//        } WithFail:^(NSError *error) {
//            [MBProgressHUD showWarning:@"请重新选择优惠券~!"];
//            [self reassignCoupn];
//        } Progress:^(float progress) {
//
//        }];




































































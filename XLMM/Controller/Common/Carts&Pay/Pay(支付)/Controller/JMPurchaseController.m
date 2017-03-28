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
#import "JMAddressViewController.h"
#import "GoodsInfoModel.h"
#import "JMOrderPayView.h"
#import "WXApi.h"
#import "JMOrderListController.h"
#import "JMPayShareController.h"
#import "JMSegmentController.h"
#import "JMCouponModel.h"
#import "JMDelayPopView.h"
#import "JMPopViewAnimationSpring.h"
#import "WebViewController.h"
#import "JMRichTextTool.h"
#import "JMPayment.h"
#import "JMAddressModel.h"



@interface JMPurchaseController ()<UIAlertViewDelegate,JMOrderPayViewDelegate,JMSegmentControllerDelegate,JMAddressViewControllerDelegate,JMChoiseLogisControllerDelegate,UITableViewDataSource,UITableViewDelegate,JMPurchaseHeaderViewDelegate,JMPurchaseFooterViewDelegate> {
    NSDictionary *_couponData;
    NSString *_logisticsID;           // 选择物流的ID
    NSDictionary *_couponInfo;        // 优惠券
    NSDictionary *_rightReduce;       // app立减
    NSDictionary *_xlWallet;          // 钱包
    NSDictionary *_xiaoluCoin;        // 小鹿币
    NSDictionary *_xiaolulingqian;    // 小鹿零钱
    
    
    NSString *_payMethod;             //支付方式
    float _totalPayment;              //应付款金额
    float _discountfee;               //优惠券金额
    NSString *_couponStringID;        // 优惠券ID
    float _rightAmount;               //app优惠
    float _availableFloat;            //小鹿支付金额
    float _xiaoluCoinValue;           //小鹿币余额
    float _xiaolulingqianValue;       //小鹿零钱余额
    
    NSString *_uuid;                  //uuid
//    NSString *_cartIDs;               //购物车id
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
    NSString *_orderGoodsIDNum;       //订单商品编号
    NSInteger _flagCount;             //标志是否弹出延迟框
    BOOL _isTeamBuyGoods;             //是否为团购
//    BOOL _isBondedGoods;              //是否为保税商品
//    BOOL _isIndentifierNum;           // 身份证号是否为空
    BOOL _isVirtualCoupone;           // 是否为虚拟优惠券
    NSInteger _couponNumber;          // 优惠券购买商品个数
    BOOL _isPerfectAddressInfo;       // 是否需要完善地址信息  carts_payinfo 的 max_personalinfo_level > 地址的 personalinfo_level 需要完善(YES)
    NSInteger _cartsInfoLevel;        // carts_payinfo 的 max_personalinfo_level
    NSInteger _addressInfoLevel;      // 地址的 personalinfo_level
    
    BOOL _cartPayInfoLoadFinish;
    BOOL _addressInfoLoadFinish;
    
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
@property (nonatomic, strong) NSMutableArray *purchaseGoodsArr;
/**
 *  判断优惠券是否可用
 */
@property (nonatomic, assign) BOOL isCanCoupon;
@property (nonatomic, assign) BOOL isUserCoupon;
@property (nonatomic, assign) BOOL isEnoughRight;
@property (nonatomic, assign) BOOL isEnoughBudget;
@property (nonatomic, assign) BOOL isUseXLW;
@property (nonatomic, assign) BOOL isInstallWX;
@property (nonatomic, assign) BOOL isxiaoluCoin;

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

@property (nonatomic, strong) UIButton *tmpBtn;

@end

static BOOL isAgreeTerms = YES;

@implementation JMPurchaseController

#pragma mark --- 懒加载 ---
- (NSMutableArray *)purchaseGoodsArr {
    if (!_purchaseGoodsArr) {
        _purchaseGoodsArr = [NSMutableArray array];
    }
    return _purchaseGoodsArr;
}
- (NSMutableArray *)logisticsArr {
    if (!_logisticsArr) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}
- (JMChoiseLogisController *)showViewVC {
    if (!_showViewVC) {
        _showViewVC = [[JMChoiseLogisController alloc] init];
        _showViewVC.delegate = self;
    }
    return _showViewVC;
}

#pragma mark --- 视图生命周期 ---
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(purchaseViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(purchaseViewDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.purchaseFooterView.goPayButton.userInteractionEnabled = YES;
    if ([WXApi isWXAppInstalled]) {
        self.isInstallWX = YES;
    }else {
        self.isInstallWX = NO;
    }
    [self loadAddressInfo];
    [MobClick beginLogPageView:@"purchase"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [MobClick endLogPageView:@"purchase"];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backClick)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    
    self.isCanCoupon = NO;
    self.isUseXLW = NO;
    self.isEnoughRight = NO;
    self.isEnoughBudget = NO;
    self.isEnoughCoupon = NO;
    self.isUserCoupon = NO;
    self.isCouponEnoughPay = NO;
    self.isxiaoluCoin = NO;
//    _isIndentifierNum = NO;
//    _isBondedGoods = NO;
    _isVirtualCoupone = YES;
    _cartPayInfoLoadFinish = NO;
    _addressInfoLoadFinish = NO;
    
    _cartsInfoLevel = 0;
    _addressInfoLevel = 0;
    _totalPayment = 0;              //应付款金额
    _discountfee = 0;               //优惠券金额
    _rightAmount = 0;               //app优惠
    _availableFloat = 0;            //小鹿钱包余额
    _xiaoluCoinValue = 0;           //小鹿币余额
    _xiaolulingqianValue = 0;
    
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
    [self loadDataSource];
    
    if (isAgreeTerms) {
        self.purchaseFooterView.termsButton.selected = YES;
    }else {
        self.purchaseFooterView.termsButton.selected = NO;
    }
}
#pragma mark 网络请求 订单支付信息, 地址请求. 数据处理
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/carts_payinfo?cart_ids=%@&device=%@", Root_URL,self.paramstring,@"app"];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.logisticsArr removeAllObjects];
        [self.purchaseGoodsArr removeAllObjects];
        _cartPayInfoLoadFinish = YES;
        [self fetchedCartsData:responseObject];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        _cartPayInfoLoadFinish = NO;
        [MBProgressHUD showError:@"支付信息获取失败~!"];
        self.purchaseFooterView.goPayButton.enabled = NO;
    } Progress:^(float progress) {
    }];
}
// 地址信息网络请求
- (void)loadAddressInfo {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kAddress_List_URL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        _addressInfoLoadFinish = YES;
        [self fetchedAddressData:responseObject];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        _addressInfoLoadFinish = NO;
        [MBProgressHUD showError:@"地址信息获取失败~!"];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchedAddressData:(NSArray *)purchaseArr {
    if (purchaseArr.count == 0) {
        _addressID = @"";
        _addressInfoLevel = 0;
    }else {
        NSDictionary *dic = purchaseArr[0];
        _addressInfoLevel = [dic[@"personalinfo_level"] integerValue];
        _addressID = [dic[@"id"] stringValue];
    }
    self.purchaseHeaderView.addressArr = purchaseArr;
    [self layoutLevel];
}
- (void)fetchedCartsData:(NSDictionary *)purchaseDic {
    _cartsInfoLevel = [purchaseDic[@"max_personalinfo_level"] integerValue];
    NSArray *goodsArr = purchaseDic[@"cart_list"];
    NSDictionary *teamGoodsDic = goodsArr[0];
    if ([self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
        _couponNumber = [teamGoodsDic[@"num"] integerValue];
    }else {
        _couponNumber = 1;
    }
    for (NSDictionary *dic in goodsArr) {
        if ([dic[@"product_type"] integerValue] == 0) {
            _isVirtualCoupone = NO;
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
            _xiaolulingqian = dicExtras;
            _xiaolulingqianValue = [[dicExtras objectForKey:@"value"] floatValue];
//            if ([[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedDescending ||[[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:_totalPayment]] == NSOrderedSame) {
//                //足够支付
//                self.isEnoughBudget = YES;
//            }else {
//                //不足支付
//                self.isEnoughBudget = NO;
//            }
        }
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 4) {
            _xiaoluCoin = dicExtras;
            _xiaoluCoinValue = [[dicExtras objectForKey:@"value"] floatValue];
        }
        
    }
    _uuid = [purchaseDic objectForKey:@"uuid"];
    NSString *cartIDs = purchaseDic[@"cart_ids"];
    if (![NSString isStringEmpty:cartIDs]) {
        self.paramstring = [NSString stringWithFormat:@"%@",cartIDs];
    }
    _totalfee = [[purchaseDic objectForKey:@"total_fee"] floatValue];
    _postfee = [[purchaseDic objectForKey:@"post_fee"] floatValue];
    [self calculationLabelValue];

    if (_isVirtualCoupone) {
        CGRect frame = self.purchaseHeaderView.frame;
        frame.size.height = 60;
        self.purchaseHeaderView.frame = frame;
        self.tableView.tableHeaderView = self.purchaseHeaderView;
    }
    self.purchaseHeaderView.isVirtualCoupone = _isVirtualCoupone;
    self.purchaseFooterView.isShowXiaoluCoinView = (_xiaoluCoinValue > 0 ? YES : NO) && _isVirtualCoupone;
    
    [self layoutLevel];
    
}
- (void)layoutLevel {
    if (_addressInfoLoadFinish && _cartPayInfoLoadFinish) {
        if (_cartsInfoLevel > _addressInfoLevel) {
            [self userNotIdCardNumberMessage];
        }
        if (_cartsInfoLevel > 1) {
            CGFloat strHeight = [payOrderLevelInfo heightWithWidth:SCREENWIDTH - 10 andFont:12.].height + 20;
            self.purchaseHeaderView.mj_h = 150.f + strHeight;
            self.tableView.tableHeaderView = self.purchaseHeaderView;
            self.purchaseHeaderView.cartsInfoLevel = _cartsInfoLevel;
        }else {
            self.purchaseHeaderView.cartsInfoLevel = _cartsInfoLevel;
        }
    }
}
- (void)setPurchaseGoods:(NSMutableArray *)purchaseGoods {
    _purchaseGoods = purchaseGoods;
    self.purchaseGoodsArr = [purchaseGoods mutableCopy];
}
// 获取购物车ID
- (void)getCartID {
    if (self.purchaseGoods.count == 0) {
        return;
    }
    NSMutableString *paramstring = [NSMutableString string];
    for (CartListModel *model in self.purchaseGoods) {
        NSString *str = [NSString stringWithFormat:@"%ld,",(long)model.cartID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    self.paramstring = [NSString stringWithFormat:@"%@",paramstring];
//    _cartIDs = [NSString stringWithFormat:@"%@",paramstring];
}


#pragma mark ---- 创建视图 ----
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)]];
    
    JMOrderPayView *payView = [[JMOrderPayView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 180, SCREENWIDTH, 180)];
    self.payView = payView;
    self.payView.delegate = self;
}
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
    self.purchaseHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.purchaseHeaderView;
    self.purchaseHeaderView.delegate = self;
}
- (void)createTableFooterView {
    self.purchaseFooterView = [[JMPurchaseFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 430)];
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
        self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", 0.00];
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
                if (self.isxiaoluCoin) {
                    self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
                    self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _xiaolulingqianValue];
                }else {
                    self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
                    self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", _xiaoluCoinValue];
                }
                
            }else {
                self.isEnoughBudget = NO;
                self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _couponValue - _rightAmount - _availableFloat];
                NSString *paymentStr = [NSString stringWithFormat:@"%.2f",_amontPayment - _couponValue - _rightAmount - _availableFloat];
                NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_discount];
                NSString *discountStr = [NSString stringWithFormat:@"%.2f",_discount];
                self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,discountStr]];//[self stringText:mutableStr WithStr:paymentStr];
                if (self.isxiaoluCoin) {
                    self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _xiaolulingqianValue];
                    self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
                }else {
                    self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _availableFloat];
                    self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", _xiaoluCoinValue];
                }
            }
        }else {
            float surplus = _amontPayment - _couponValue - _rightAmount;
            if (_availableFloat - surplus > 0.00001 || fabsf(_availableFloat - surplus) <= 0.00001) {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _xiaolulingqianValue];
                self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", _xiaoluCoinValue];
            }else {
                self.purchaseFooterView.walletLabel.text = [NSString stringWithFormat:@"%.2f", _xiaolulingqianValue];
                self.purchaseFooterView.xiaoluCoinLabel.text = [NSString stringWithFormat:@"%.2f", _xiaoluCoinValue];
            }
            self.purchaseFooterView.goodsLabel.text = [NSString stringWithFormat:@"¥%.2f", _amontPayment - _discount];
            NSString *paymentStr = [NSString stringWithFormat:@"%.2f",_amontPayment - _discount];
            NSString *mutableStr = [NSString stringWithFormat:@"应付金额%@已节省%.2f", paymentStr,_discount];
            NSString *discountStr = [NSString stringWithFormat:@"%.2f",_discount];
            self.purchaseFooterView.paymenLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:mutableStr SubStringArray:@[paymentStr,discountStr]];//[self stringText:mutableStr WithStr:paymentStr];
        }
    }
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
    _parmsStr = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&post_fee=%@&total_fee=%@&uuid=%@",self.paramstring,_addressID,[NSString stringWithFormat:@"%.2f", _postfee],[NSString stringWithFormat:@"%.2f", _totalfee],_uuid];
    //是否使用优惠券
    if (self.isUserCoupon && self.isEnoughCoupon && self.isCouponEnoughPay) {
        _totalPayment = 0.00;
        _discountfee = _discountfee + _couponValue;
        parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:value:%.2f", parms,  _couponInfo[@"pid"], _couponStringID, _couponValue];
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
#pragma mark  自定义代理实现 -> (自定义视图按钮点击回调,优惠券代理回调处理,支付方式代理回调处理)
// JMPurchaseFooterViewDelegate (自定义按钮点击)
- (void)composeFooterButtonView:(JMPurchaseFooterView *)headerView UIButton:(UIButton *)button {
    if (button.tag != 100) {
        for (int i = 1; i < 3; i++) {
            UIButton *btn = (UIButton *)[[button superview]viewWithTag:100 + i];
            //选中当前按钮时
            if (button.tag == btn.tag) {
                button.selected = !button.selected;
            }else{
                [btn setSelected:NO];
            }
        }
    }
    // 100->优惠券  101->钱包  102->条款  103->结算
    if (button.tag == 100) {
        button.enabled = NO;
        if ([NSString isStringEmpty:self.paramstring]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"优惠券暂不可用,请重新添加购买~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            button.enabled = YES;
            return ;
        }
        [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
        JMSegmentController *segmentVC = [[JMSegmentController alloc] init];
        segmentVC.cartID = self.paramstring;
        segmentVC.isSelectedYHQ = YES;
        segmentVC.selectedModelID = _yhqModelID;
        segmentVC.couponNumber = _couponNumber;
        segmentVC.directBuyGoodsTypeNumber = self.directBuyGoodsTypeNumber;
        //        segmentVC.couponData = _couponData;
        segmentVC.delegate = self;
        [self.navigationController pushViewController:segmentVC animated:YES];
    }else if (button.tag == 101) {
        _xlWallet = _xiaolulingqian;
        _availableFloat = _xiaolulingqianValue;
        if (_availableFloat > 0) {
            //            button.selected = !button.selected;
            self.isUseXLW = button.selected;
            self.isxiaoluCoin = NO;
            [self calculationLabelValue];
        }else {
            [MBProgressHUD showWarning:@"钱包不足"];
        }
    }else if (button.tag == 102) {
        _xlWallet = _xiaoluCoin;
        _availableFloat = _xiaoluCoinValue;
        if (_availableFloat > 0) {
            //            button.selected = !button.selected;
            self.isUseXLW = button.selected;
            self.isxiaoluCoin = YES;
            [self calculationLabelValue];
            
        }else {
            [MBProgressHUD showWarning:@"小鹿币不足"];
        }
        
    }else if (button.tag == 103) {
        button.selected = !button.selected;
        if (button.selected) {
            isAgreeTerms = YES;
        }else {
            isAgreeTerms = NO;
        }
    }else if (button.tag == 104) {
        button.enabled = NO;
        [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
        if (_cartsInfoLevel > _addressInfoLevel) {
            [self userNotIdCardNumberMessage];
            return ;
        }
        if (!isAgreeTerms) {
            [MBProgressHUD showWarning:@"请您阅读和同意购买条款!"];
            return ;
        }else {
            if (self.isUseXLW) {
                if (self.isEnoughBudget == NO) {
                    self.isXLWforAlipay = YES;
                    [self createPayPopView];
                }else {
                    self.isXLWforAlipay = NO;
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
// JMPurchaseHeaderViewDelegate (地址信息 , 物流信息)
- (void)composeHeaderTapView:(JMPurchaseHeaderView *)headerView TapClick:(NSInteger)index {
    // 100->地址信息点击  101->物流信息点击
    if (index == 100) {
        if (_cartsInfoLevel != 0) { // && _addressInfoLevel != 0
//            if (_cartsInfoLevel > _addressInfoLevel) {
//                _isPerfectAddressInfo = YES; // 需要去完善信息
//            }else {
//                _isPerfectAddressInfo = NO;
//            }
            JMAddressViewController *addVC = [[JMAddressViewController alloc] init];
            addVC.addressID = _addressID;
            addVC.isSelected = YES;
            addVC.cartsPayInfoLevel = _cartsInfoLevel;
            addVC.delegate = self;
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }else if (index == 101) {
        NSInteger count = self.logisticsArr.count;
        [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 60 * (count + 1)) ViewController:self.showViewVC WithBlock:^(UIView *maskView) {
        }];
    }else { }
}
// PurchaseAddressDelegate (地址选择修改代理回调)
- (void)addressView:(JMAddressViewController *)addressVC model:(JMAddressModel *)model{
    self.purchaseHeaderView.addressModel = model;
    _addressID = model.addressID;
    _addressInfoLevel = [model.personalinfo_level integerValue];
    if (_cartsInfoLevel > _addressInfoLevel) {
        [self userNotIdCardNumberMessage];
    }
//    if ([NSString isStringEmpty:model.identification_no]) {
//        _isIndentifierNum = YES;
//    }else {
//        _isIndentifierNum = NO;
//    }
}
// JMChoiseLogisControllerDelegate (选择物流代理回调)
- (void)ClickLogistics:(JMChoiseLogisController *)click Model:(JMPopLogistcsModel *)model {
    [MobClick event:@"logistics_choose"];
    self.purchaseHeaderView.logisticsLabel.text = model.name;
    _logisticsID = model.logistcsID;
}
// 优惠券
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
        _couponValue = 0;
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
// 支付方式
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
// 购买条款
- (void)composeFooterTapView:(JMPurchaseFooterView *)headerView {
    NSString *terms = promptMessage_termsOfPurchase;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买条款" message:terms delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark 网络请求 数据处理
// -> 支付提交请求
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
        _orderGoodsIDNum = dict[@"id"];
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
                    _flagCount --;
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
        //        [SVProgressHUD showErrorWithStatus:@"支付请求失败,请稍后重试!"];
        [MBProgressHUD showError:@"支付请求失败,请稍后重试!"];
    } Progress:^(float progress) {
        
    }];
}
// -> 团购支付
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
// -> 订单支付结果查询
- (void)inquiryOrder:(NSString *)orderTid {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, orderTid];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [MBProgressHUD hideHUD];
        if ([responseObject[@"is_paid"] boolValue]) {
            [self paySuccessful];
        }else {
            [self doSomeWork];
        }
    } WithFail:^(NSError *error) {
        [self doSomeWork];
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
    }];
}
#pragma mark 自定义弹出框,系统弹出框
- (void)createPayPopView {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.payView];
    self.maskView.alpha = 0;
    self.payView.cs_y = self.view.cs_h - 150;
    self.payView.payMent = self.purchaseFooterView.goodsLabel.text;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.payView.bottom = self.view.cs_h;
    }];
}
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.payView.cs_y = self.view.cs_h;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.payView removeFromSuperview];
    }];
}
- (void)userNotIdCardNumberMessage {
    NSString *msgStr = @"";
    if (_addressInfoLevel == 0) {
        msgStr = @"收货地址不完善,请填写收货地址。";
    }else {
        msgStr = @"订单中包含进口保税区发货商品，根据海关监管要求，需要提供收货人身份证信息。此信息加密保存，只用于此订单海关通关，请点击地址进行修改。\n点击\"收货地址-修改\"填写一下身份证吧";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)doSomeWork {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"支付被您取消或支付失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alterView.tag = 102;
    [alterView show];
}
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
        JMOrderListController *orderVC = [[JMOrderListController alloc] init];
        orderVC.currentIndex = 1;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else {}
}

#pragma mark 支付成功或取消后续操作
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = _orderTidNum;
    [self.navigationController pushViewController:payShareVC animated:YES];
}


#pragma mark 当前页面数据处理函数
- (NSMutableDictionary *)stringChangeDictionary:(NSString *)str {
    NSArray *firstArr = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *segment in firstArr) {
        NSArray *secondArr = [segment componentsSeparatedByString:@"="];
        [dic setObject:secondArr[1] forKey:secondArr[0]];
    }
    return dic;
}


#pragma mark ---- 点击事件 ----
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---- 通知事件 ----
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification {
    [MBProgressHUD showLoading:@""];
}
- (void)purchaseViewDidBecomeActive:(NSNotification *)notification {
    if (_flagCount > 0) {
        [self inquiryOrder:_orderGoodsIDNum];
        _flagCount --;
    }else {
        [MBProgressHUD hideHUD];
    }
}
- (void)popview{
    [MBProgressHUD hideHUD];
    [MobClick event:@"buy_cancel"];
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 1;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)paySuccessful{
    [MBProgressHUD hideHUD];
    [MobClick event:@"buy_succ"];
    if (_isTeamBuyGoods) {
        [self getTeam:_orderTidNum]; // == > 团购信息
    }else {
        [self pushShareVC];
    }
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




































































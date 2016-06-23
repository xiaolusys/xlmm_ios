//
//  XiangQingViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "XiangQingViewController.h"
#import "DingdanModel.h"
#import "MMClass.h"
#import "XiangQingView.h"
#import "JMOrderGoodsModel.h"
#import "DingDanXiangQingModel.h"
#import "UIImageView+WebCache.h"
#import "Pingpp.h"
#import "UIViewController+NavigationBar.h"
#import "ShenQingTuikuanController.h"
#import "ShenQingTuiHuoController.h"
#import "NSString+URL.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XlmmMall.h"
#import "UIColor+RGBColor.h"
#import "JMEditAddressController.h"
#import "JMEditAddressModel.h"
#import "MJExtension.h"
#import "JMOrderDetailModel.h"
#import "JMChooseLogisticsController.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "JMPopLogistcsController.h"
#import "Masonry.h"
#import "JMOrderGoodsModel.h"
#import "JMPackAgeModel.h"
#import "JMPopLogistcsModel.h"
#import "JMQueryLogInfoController.h"
#import "MJRefresh.h"


#define kUrlScheme @"wx25fcb32689872499"

@interface XiangQingViewController ()<NSURLConnectionDataDelegate, UIAlertViewDelegate,JMEditAddressControllerDelegate,JMShareViewDelegate,JMPopLogistcsControllerDelegate>{
    
    float refundPrice;
}



/**
 *  添加收货地址
 */
@property (nonatomic,strong) NSMutableDictionary *editAddDict;

@property (nonatomic,strong) JMPopLogistcsController *showViewVC;
/**
 *  包裹信息
 */
@property (nonatomic,strong) UILabel *packMessageL;
/**
 *  包裹状态
 */
@property (nonatomic,strong) UILabel *packStatusL;
/**
 *  物流公司选择
 */
@property (nonatomic,strong) UILabel *expressL;
/**
 *  包裹信息的视图 -- (添加手势)
 */
@property (nonatomic,strong) UIView *packInfoView;
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
 *  蒙版视图
 */
@property (nonatomic,strong) UIView *maskView;
/**
 *  物流包裹状态视图
 */
@property (nonatomic,strong) UIButton *baseView;
/**
 *  包裹信息模型
 */
@property (nonatomic,strong) JMPackAgeModel *packModel;

@end

@implementation XiangQingViewController{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView; // 菊花
    UIView *frontView;
    NSString *status;
//    orderGoodsModel *tuihuoModel;//详情页子订单模型
    NSString *tid;               //internal trade id
    NSArray *oidArray;           //orders
    NSMutableArray *refund_statusArray;//退款状态
    NSMutableArray *refund_status_displayArray;// 退款状态描述
    NSMutableArray *orderStatusDisplay;
    NSMutableArray *orderStatus;
    NSTimer *theTimer;
    NSString *createdString;
    NSMutableArray *logisticsInfoArray;
    NSInteger packetNum;
    NSInteger currentIndex;
    
    NSDictionary *_orderDic;
    NSString *_goodsID; // 订单ID
    NSDictionary *_refundDic;
    
    NSMutableArray *packNumArr;//包裹个数
}

- (JMEditAddressModel *)addressModel {
    if (_addressModel == nil) {
        _addressModel = [[JMEditAddressModel alloc] init];
    }
    return _addressModel;
}
- (JMOrderDetailModel *)orderDetailModel {
    if (_orderDetailModel == nil) {
        _orderDetailModel = [JMOrderDetailModel new];
    }
    return _orderDetailModel;
}
- (JMOrderGoodsModel *)orderGoodsModel {
    if (_orderGoodsModel == nil) {
        _orderGoodsModel = [JMOrderGoodsModel new];
    }
    return _orderGoodsModel;
}
- (JMPackAgeModel *)packModel {
    if (_packModel == nil) {
        _packModel = [JMPackAgeModel new];
    }
    return _packModel;
}
- (NSMutableDictionary *)editAddDict {
    if (_editAddDict == nil) {
        _editAddDict = [NSMutableDictionary dictionary];
    }
    return _editAddDict;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self downloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(btnClicked:)];
    
    //初始化数组。。。。
    
    currentIndex = 0;
    refund_status_displayArray = [[NSMutableArray alloc] initWithCapacity:0];
    refund_statusArray = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatus = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatusDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self.view addSubview:self.xiangqingScrollView];
    self.screenWidth.constant = SCREENWIDTH;//自定义宽度
    
    
//    frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    frontView.backgroundColor = [UIColor whiteColor];
//
//    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2-80);
//    [activityView startAnimating];
//    [frontView addSubview:activityView];
//    [self.view addSubview:frontView];
    
    self.quxiaoBtn.layer.cornerRadius = 20;
    self.quxiaoBtn.layer.borderWidth = 1;
    self.quxiaoBtn.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    
    
    self.buyBtn.layer.cornerRadius = 20;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    //跳转进入修改地址信息界面
    [self createAddressInfoImage];
    
    [self logisticsChange];

//    [self downloadData];
    

}



- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //http://staging.xiaolumeimei.com/rest/v2/trades/333472
    [manage GET:self.urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (!responseObject) return;
        _orderDic = [[NSDictionary alloc] init];
        _orderDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        JMOrderDetailModel *detailModel = [JMOrderDetailModel mj_objectWithKeyValues:responseObject];
        NSDictionary *dict = detailModel.user_adress;
        _refundDic = _orderDic[@"extras"];
        _editAddDict = [NSMutableDictionary dictionaryWithDictionary:dict];//self.model.mj_keyValues;
        
        [self fetchedDingdanData:_orderDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
    
}

- (void)fetchedDingdanData:(NSDictionary *)responsedata{
    if (responsedata == nil) {
        return;
    }
    
    NSDictionary *dicJson = responsedata;
    [self transferOrderModel:dicJson];
    
    [activityView removeFromSuperview];
    //订单状态
    NSInteger tradeStatus = [[dicJson objectForKey:@"status"] integerValue];
    
    //判断在详情页是否显示取消订单和重新购买按钮。。。。。
    if (tradeStatus == ORDER_STATUS_WAITPAY) {
        self.quxiaoBtn.hidden = NO;
        self.buyBtn.hidden = NO;
#pragma 显示剩余支付时间。。。。。
        createdString = [self formatterTimeString:[dicJson objectForKey:@"created"]];
        theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    } else {
        //其他订单状态
        self.quxiaoBtn.hidden = YES;
        self.buyBtn.hidden = YES;
        // === > 订单不是待付款状态
        self.bottomViewHeight.constant = -60;
        self.bottomView.hidden = YES;
    }
    
    NSString *newStr = [self formatterTimeString:dicJson[@"created"]];
    self.orderTimerLabel.text = [NSString stringWithFormat:@"下单时间:%@",newStr];
    self.orderTimerLabel.textAlignment = NSTextAlignmentRight;
    //订单编号和状态
    self.headdingdanzhuangtai.text = self.orderDetailModel.status_display;
    NSDictionary *dic = dicJson[@"user_adress"];
    self.addressModel = [JMEditAddressModel mj_objectWithKeyValues:dic];
    self.nameLabel.text = self.addressModel.receiver_name;
    self.phoneLabel.text = self.addressModel.receiver_mobile;
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",self.addressModel.receiver_state,self.addressModel.receiver_city,self.addressModel.receiver_district,self.addressModel.receiver_address];
    self.addressLabel.text = addressStr;
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];//
    _goodsID = dic[@"id"];
    tid = [dicJson objectForKey:@"id"]; //交易id号 内部使用

    [self removeAllSubviews:self.myXiangQingView];
//        if((tradeStatus == ORDER_STATUS_PAYED) || (tradeStatus == ORDER_STATUS_SENDED)){
    //需要查物流信息，查询到信息后
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *str = [NSString stringWithFormat:@"%@/rest/packageskuitem?sale_trade_id=%@", Root_URL,[dicJson objectForKey:@"tid"]];
    [manage GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!responseObject) return;
        [self setWuLiuMsg:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

    self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.02f",[[dicJson objectForKey:@"total_fee"] floatValue]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"＋¥%.02f", [[dicJson objectForKey:@"post_fee"] floatValue]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"－¥%.02f", [[dicJson objectForKey:@"discount_fee"] floatValue]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"¥%.02f", [[dicJson objectForKey:@"payment"] floatValue]];
    
    refundPrice = [[dicJson objectForKey:@"payment"] floatValue];

}

#pragma mark   订单详情各模块数据源
- (void)transferOrderModel:(NSDictionary *)dicJson{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray removeAllObjects];
    [refund_status_displayArray removeAllObjects];
    [refund_statusArray removeAllObjects];
    [orderStatus removeAllObjects];
    [orderStatusDisplay removeAllObjects];
    /**
     *  字典转模型   ===== >  dingdanModel
     */
    self.orderDetailModel = [JMOrderDetailModel mj_objectWithKeyValues:dicJson];
    /**
     *  收货地址模型
     */
    NSDictionary *addressDic = self.orderDetailModel.user_adress;
    self.addressModel = [JMEditAddressModel mj_objectWithKeyValues:addressDic];
    /**
     *  商品信息模型   ===== >  orderGoodsModel
     */
    for (NSDictionary *dic in self.orderDetailModel.orders) {
        self.orderGoodsModel = [JMOrderGoodsModel mj_objectWithKeyValues:dic];
        [dataArray addObject:self.orderGoodsModel];                                  //orders 模型数组
        [refund_status_displayArray addObject:self.orderGoodsModel.refund_status_display];//退货状态描述
        [refund_statusArray addObject:self.orderGoodsModel.refund_status];           // 返回的是数字 表示退款状态
        [orderStatus addObject:self.orderGoodsModel.status];
        [orderStatusDisplay addObject:self.orderGoodsModel.status_display];
        NSString *oid = self.orderGoodsModel.orderGoodsID;                           // 商品 ID
        [mutableArray addObject:oid];
    }
    oidArray = [[NSArray alloc] initWithArray:mutableArray];

    /**
     *  判断物流公司   只在这里判断就够了
     */
    if (self.orderDetailModel.logistics_company == nil) {
        self.logisticsLabel.text = @"小鹿推荐";
    }else {
        NSDictionary *dic = self.orderDetailModel.logistics_company;
        JMPopLogistcsModel *model = [JMPopLogistcsModel mj_objectWithKeyValues:dic];
        self.logisticsLabel.text = model.name;
        
    }
}
#pragma mark ----- 物流信息数据源
- (void)transferJMPackAgeModel:(NSDictionary *)dicJson{
    logisticsInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    packetNum = 0;
    NSString *groupKey = @"";
    for (NSDictionary *dic in dicJson) {
        JMPackAgeModel *packModel = [JMPackAgeModel mj_objectWithKeyValues:dic];
        self.packModel = packModel;
        [logisticsInfoArray addObject:packModel];
        if ((packModel.package_group_key != nil) && (![packModel.package_group_key isEqualToString:groupKey])) {
            packetNum ++;
        }
        groupKey = packModel.package_group_key;

    }
}
/**
 *   NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
 NSString *packStr = @"";
 if (packModel.ware_by_display == nil) {
 packStr = @"物流配送";
 }else {
 NSString *newStr = [packModel.ware_by_display substringToIndex:1];
 NSInteger count = [newStr integerValue] - 1;
 if (count < 0) {
 packStr = @"物流配送";
 }else {
 packStr = [NSString stringWithFormat:@"包裹%@",arr[count]];
 }
 }
 self.packMessageL.text = packStr;
 *
 *  @return
 */
#pragma mark ---- 点击修改物流公司
- (void)logisticsChange {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLogisticsClick:)];
    [self.choiseLogisticsView addGestureRecognizer:tap];
    self.choiseLogisticsView.userInteractionEnabled = NO;
    self.showViewVC = [[JMPopLogistcsController alloc] init];

}
#pragma mark ----- 商品包裹信息 创建控件 //logisticsInfoModel ==转换 > JMPackAgeModel
- (void)createProcessView:(CGRect )rect status:(NSString *)goodsStatus JMPackAgeModel:(JMPackAgeModel *)packModel{
//    if((goodsStatus != nil) && (JMPackAgeModel != nil)){
//        NSLog(@"createProcessView orderStatus=%@ time=%@ company=%@ packetId=%@", goodsStatus, JMPackAgeModel.process_time, JMPackAgeModel.logistics_company_name, JMPackAgeModel.out_sid);
//    }
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    //    view.layer.cornerRadius = 4;
    self.packInfoView = view;

    UIButton *baseView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.packInfoView addSubview:baseView];
    self.baseView = baseView;
//    self.baseView.tag = 100 + packetNum;
    [self.baseView addTarget:self action:@selector(baseViewBtn:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *lineL = [UILabel new];
    [self.packInfoView addSubview:lineL];
    lineL.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *packMessageL = [UILabel new];
    packMessageL.font = [UIFont systemFontOfSize:12.];
    [self.baseView addSubview:packMessageL];
    packMessageL.textColor = [UIColor lightGrayColor];
    self.packMessageL = packMessageL;
    
    UILabel *packStateLabel = [UILabel new];
    packStateLabel.font = [UIFont systemFontOfSize:12.];
    [self.baseView addSubview:packStateLabel];
    packStateLabel.textColor = [UIColor orangeThemeColor];
    self.packStatusL = packStateLabel;

    UILabel *bottomL = [UILabel new];
    [self.packInfoView addSubview:bottomL];
    bottomL.backgroundColor = [UIColor lineGrayColor];
    
    [self.myXiangQingView addSubview:self.packInfoView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineL.mas_bottom);
        make.left.equalTo(self.packInfoView);
        make.width.mas_equalTo(SCREENWIDTH);
        NSInteger statusCount = [self.orderDetailModel.status integerValue];
        if (statusCount >= ORDER_STATUS_PAYED) {// && statusCount < ORDER_STATUS_REFUND_CLOSE
            make.height.mas_equalTo(@35);
        }else {
            make.height.mas_equalTo(@1);
        }
        
    }];
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@20);
    }];
    
    [self.packMessageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(10);
        make.left.equalTo(self.baseView).offset(10);
    }];
    
    [self.packStatusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(10);
        make.right.equalTo(self.baseView).offset(-10);
    }];
    
    [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@1);
    }];
//
//    NSString *str = [NSString stringWithFormat:@"包裹%@",arr[0]];
//    if (self.packMessageL == nil) {
//        self.packMessageL = [UILabel new];
//    }
//    self.packMessageL.text = str;
//    
    /**
     *  判断订单状态 == 物流状态
     */
    NSInteger statusCount = [goodsStatus integerValue];
    if (statusCount == ORDER_STATUS_WAITPAY) {
         /* 
            待支付状态    只显示物流配送信息(物流信息与地址信息不可修改)  不显示包裹信息
         */
    }
    else if (statusCount == ORDER_STATUS_PAYED) {
        /** && (packModel.assign_status_display )
         *  已支付状态    不显示包裹信息   物流信息与地址信息可修改
         */
        self.choiseLogisticsView.userInteractionEnabled = YES;
        self.addressInfoImage.userInteractionEnabled = YES;
        if (packModel.assign_status_display) {
            self.packStatusL.text = packModel.assign_status_display;
        }else {
            self.packStatusL.text = @"包裹正在分配";
        }
    }
    else if (statusCount == ORDER_STATUS_SENDED) {
        /**
         *  发货状态     显示包裹信息 物流信息与地址不可修改
         */
        self.packStatusL.text = packModel.assign_status_display;
    }
    else if (statusCount == ORDER_STATUS_CONFIRM_RECEIVE) {
        /**
         *  确认收货状态
         */
        self.packStatusL.text = packModel.assign_status_display;
    }
    else if (statusCount == ORDER_STATUS_TRADE_SUCCESS) {
        /**
         *  交易成功
         */
        self.packStatusL.text = packModel.assign_status_display;
    }
    else if (statusCount == ORDER_STATUS_REFUND_CLOSE) {
        /**
         *  无退款状态
         */
    }else if (statusCount == ORDER_STATUS_TRADE_CLOSE ) {
        /**
         *  订单关闭
         */
    }
    
}

#pragma mark ----- 商品包裹信息
//- (void)packTapClick:(UITapGestureRecognizer *)tap {
//    UITapGestureRecognizer *tap1 = tap;
//    UIView *tapView = (UIView*)tap1.view;
//    
//    WuliuViewController *wuliuView = [[WuliuViewController alloc] initWithNibName:@"WuliuViewController" bundle:nil];
//    if((tapView.tag >= 100) && (logisticsInfoArray.count > tapView.tag - 100)){
//        
//        wuliuView.packetId = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:tapView.tag - 100]).out_sid;
//        wuliuView.companyCode = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:tapView.tag - 100]).logistics_company_code;
//        [self.navigationController pushViewController:wuliuView animated:YES];
//    }
//}
/**
 *  判断包裹状态  是否分包  
 */
- (void)baseViewBtn:(UIButton *)btn {
    
    if(packetNum == 0)
        return;
    
    
    
    NSString *outSidStr = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:currentIndex]).out_sid;
    NSString *logisticsCompanyCodeStr = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:btn.tag - 100]).logistics_company_code;
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];
    NSString *logName = self.logisticsLabel.text;
    if((btn.tag >= 100) && (logisticsInfoArray.count > btn.tag - 100)){
        NSDictionary *dic = [[logisticsInfoArray objectAtIndex:currentIndex] mj_keyValues];
        queryVC.packetId = outSidStr;//@"3101040539131"
        queryVC.companyCode = logisticsCompanyCodeStr; //@"YUNDA_QR";
        queryVC.logName = logName;
        queryVC.goodsListDic = dic;
        NSInteger count = currentIndex; // == 5
        NSMutableArray *orderGoodsArr = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            self.orderGoodsModel = [dataArray objectAtIndex:i];
            [orderGoodsArr addObject:self.orderGoodsModel];
        }
        queryVC.orderGoodsArr = orderGoodsArr;
        
//        queryVC.goodsModel = self.orderGoodsModel;
//        [self.navigationController pushViewController:queryVC animated:YES];
        

        
        [self.navigationController pushViewController:queryVC animated:YES];

    }
//    NSString *outSidStr = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:btn.tag - 100]).out_sid;
//    NSString *logisticsCompanyCodeStr = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:btn.tag - 100]).logistics_company_code;
//
//    WuliuViewController *wuliuView = [[WuliuViewController alloc] initWithNibName:@"WuliuViewController" bundle:nil];

}
#pragma mark ----- 物流信息点击事件
- (void)changeLogisticsClick:(UITapGestureRecognizer *)tap {
//    self.showViewVC.goodsID = _goodsID;

    JMShareView *cover = [JMShareView show];
    cover.delegate = self;
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
    if (self.showViewVC.view == nil) {
        self.showViewVC = [[JMPopLogistcsController alloc] init];
    }
    self.showViewVC.goodsID = _goodsID;
    self.showViewVC.logisticsStr = _orderDic[@"id"];
    self.showViewVC.delegate = self;
    menu.contentView = self.showViewVC.view;
    
}
- (void)ClickLogistics:(JMPopLogistcsController *)click Title:(NSString *)title {
    self.logisticsLabel.text = title;
}
#pragma mark --- 点击隐藏弹出视图 changeLogisticsClick
- (void)coverDidClickCover:(JMShareView *)cover {
    //隐藏pop菜单
    [JMPopView hide];
}

#pragma mark ----- 物流视图的显示
- (void)setWuLiuMsg:(NSDictionary *)dic {
    NSInteger statusCount = [self.orderDetailModel.status integerValue];
    NSInteger num = 0; // num -- > 显示物流状态的视图  && statusCount < ORDER_STATUS_REFUND_CLOSE
    if (statusCount >= ORDER_STATUS_PAYED) {
        num = 35;
    }else {
        num = 0;
    }
    packNumArr = [NSMutableArray array];
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    NSInteger tagNum = 0; // 表示包裹信息按钮的tag
    NSInteger nums = 20 + num;
    if (dic.count == 0){
        //无查物流信息，直接显示时间和商品即可  76 -- > 35 + 20
        self.goodsViewHeight.constant = nums + 90 * dataArray.count;
        [self createProcessView:CGRectMake(0, 0, SCREENWIDTH, nums) status:orderStatus[0] JMPackAgeModel:nil];
        NSUInteger  h=nums;
        for(int i=0; i < dataArray.count; i++){
            [self createXiangQing:CGRectMake(0, h, SCREENWIDTH, 90) number:i];
            h += 90;
        }
        return;
    }
    [self  transferJMPackAgeModel:dic];
    NSString *groupKey = @"";
    NSInteger h = 0;
    NSInteger hs = 0;
    self.goodsViewHeight.constant = packetNum * nums + logisticsInfoArray.count * 90 + 15 *(packetNum - 1);
    for(int i =0; i < logisticsInfoArray.count; i++){
        
        NSLog(@"setWuLiuMsg logis groupkey=%@  temp groupkey=%@",((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key, groupKey);
        if((((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key != nil) && (![((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key isEqualToString:groupKey])) {
            if(i != 0) h+= 15;
            [self createProcessView:CGRectMake(0, h, SCREENWIDTH, nums) status:[orderStatus objectAtIndex:i] JMPackAgeModel:((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:i])];
            h += nums;
            hs += nums;
//            self.packMessageL.text = [NSString stringWithFormat:@"包裹%@",arr[i]];
        }
//        NSString *packStr = @"";
//        if (packModel.ware_by_display == nil) {
//            packStr = @"物流配送";
//        }else {
//            NSString *newStr = [packModel.ware_by_display substringToIndex:1];
//            NSInteger count = [newStr integerValue] - 1;
//            if (count < 0) {
//                packStr = @"物流配送";
//            }else {
//                packStr = [NSString stringWithFormat:@"包裹%@",arr[count]];
//            }
//        }
        NSInteger numC = hs / 55;
        if (numC == 0) {
            return;
        }else {
            self.packMessageL.text = [NSString stringWithFormat:@"包裹%@",arr[numC - 1]];
            tagNum = numC + 100;
            self.baseView.tag = tagNum;
            currentIndex += 1;
        }
        NSNumber *numTag = [NSNumber numberWithInteger:tagNum];
        [packNumArr addObject:numTag];
        currentIndex = 0;
        
        groupKey = ((JMPackAgeModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key;
        
        [self createXiangQing:CGRectMake(0, h, SCREENWIDTH, 90) number:i];
        h += 90;
    }
}
/**
 *  设置倒计时方法
 */
- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    //  2015-10-29T15:50:19
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:createdString];
    //  NSLog(@"date = %@", date);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDate *todate = [NSDate dateWithTimeInterval:20 * 60 sinceDate:date];
    // NSLog(@"todate = %@", todate);
    //把目标时间装载入date
    //用来得到具体的时差
    NSDateComponents *d = [calendar components:unitFlags fromDate:[NSDate date] toDate:todate options:0];
    NSString *string = nil;
    string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    // NSLog(@"string = %@", string);
    
    self.remainTimeLabel.text = string;
    if ([d minute] < 0 || [d second] < 0) {
        self.remainTimeLabel.text = @"00:00";
        self.buyBtn.hidden = YES;
        self.quxiaoBtn.hidden = YES;
        self.bottomView.hidden = YES;
    }
}
- (NSString *)formatterTimeString:(NSString *)timeString{
    if (timeString == nil) {
        return nil;
    }
    if ([timeString class] == [NSNull class]) {
        return nil;
    }
    NSMutableString *newString = [NSMutableString stringWithString:timeString];
    NSRange range = {10, 1};
    [newString replaceCharactersInRange:range withString:@" "];
    
//    [newString deleteCharactersInRange:NSMakeRange(newString.length - 3, 3)];
    
    return newString;
}
- (void)createXiangQing:(CGRect )rect number:(NSInteger)index{
    NSInteger orderS = [[orderStatus objectAtIndex:index] integerValue];
    BOOL isOrderS = orderS == ORDER_STATUS_CONFIRM_RECEIVE; //(orderS == ORDER_STATUS_TRADE_SUCCESS) || (
    
    
    XiangQingView *owner = [XiangQingView new];
    JMOrderGoodsModel *orderGoods = [dataArray objectAtIndex:index];
    self.orderGoodsModel = orderGoods;
    
    [[NSBundle mainBundle] loadNibNamed:@"XiangQingView" owner:owner options:nil];
    owner.myView.frame = (rect);
    
    [owner.frontView sd_setImageWithURL:[NSURL URLWithString:[orderGoods.pic_path URLEncodedString]]];
    owner.frontView.contentMode = UIViewContentModeScaleAspectFill;
    owner.frontView.layer.masksToBounds = YES;
    owner.frontView.layer.borderWidth = 0.5;
    owner.frontView.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    owner.frontView.layer.cornerRadius = 5;
    
    owner.nameLabel.text = orderGoods.title;
    owner.sizeLabel.text = orderGoods.sku_name;
    owner.numberLabel.text = [NSString stringWithFormat:@"x%@", orderGoods.num];
    owner.priceLabel.text =[NSString stringWithFormat:@"¥%.2f", [orderGoods.payment floatValue]];
    
    if ([[orderStatus objectAtIndex:index] integerValue] == ORDER_STATUS_PAYED) {
        if ([[refund_statusArray objectAtIndex:index] integerValue] == 0) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
            [button addTarget:self action:@selector(tuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor buttonEmptyBorderColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"申请退款" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button.layer setBorderWidth:0.5];
            button.tag = 200+index;
            button.layer.cornerRadius = 12.5;
            [button.layer setBorderColor:[UIColor buttonEmptyBorderColor].CGColor];
            [owner.myView addSubview:button];
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 50, 70, 40)];
            NSString *string = [refund_statusArray objectAtIndex:index];
            label.text = string;
            if ([string integerValue] == REFUND_STATUS_NO_REFUND ) {
                label.text = @"";
            }
            else if ([string integerValue] == REFUND_STATUS_BUYER_APPLY ) {
                label.text = @"已经申请退款";
            }
            else if ([string integerValue] == REFUND_STATUS_SELLER_AGREED ) {
                label.text = @"卖家同意退款";
            }
            else if ([string integerValue] == REFUND_STATUS_BUYER_RETURNED_GOODS ) {
                label.text = @"已经退货";
            }
            else if ([string integerValue] == REFUND_STATUS_SELLER_REJECTED ) {
                label.text = @"卖家拒绝退款";
            }
            else if ([string integerValue] == REFUND_STATUS_WAIT_RETURN_FEE ) {
                label.text = @"退款中";
            }
            else if ([string integerValue] == REFUND_STATUS_REFUND_CLOSE ) {
                label.text = @"退款关闭";
            }
            else if ([string integerValue] == REFUND_STATUS_REFUND_SUCCESS ) {
                label.text = @"退款成功";
            }
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor darkGrayColor];
            [owner.myView addSubview:label];
        }
    } else if ([[orderStatus objectAtIndex:index] integerValue] == ORDER_STATUS_SENDED){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
        [button addTarget:self action:@selector(qianshou:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.layer setBorderWidth:0.5];
        button.tag = 200+index;
        button.layer.cornerRadius = 12.5;
        [button.layer setBorderColor:[UIColor orangeThemeColor].CGColor];
        [owner.myView addSubview:button];
    } else if (isOrderS && [[refund_statusArray objectAtIndex:index] integerValue] == REFUND_STATUS_NO_REFUND){
        if ([[refund_statusArray objectAtIndex:index] integerValue] == 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
        [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"退货退款" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.layer setBorderWidth:0.5];
        button.tag = 200+index;
        button.layer.cornerRadius = 12.5;
        [button.layer setBorderColor:[UIColor orangeThemeColor].CGColor];
        [owner.myView addSubview:button];
            if (orderGoods.kill_title) {
                button.enabled = NO;
                [button setTitle:@"秒杀款不退不换" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
                CGRect rect = button.frame;
                rect.size.width = 112;
                rect.origin.x -= 40;
                button.frame = rect;
            }
        }
    }else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 50, 70, 40)];
        NSString *string = [refund_statusArray objectAtIndex:index];
        NSString *statusStr = [refund_status_displayArray objectAtIndex:index];
        // 判断退款订单状态  显示给客服看。。。。。
        label.text = statusStr;
        if ([string integerValue] == REFUND_STATUS_NO_REFUND) {
            label.text = @"";
        }
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor darkGrayColor];
        [owner.myView addSubview:label];
    }
    [self.myXiangQingView addSubview:owner.myView];
    [frontView removeFromSuperview];
}

- (void)removeAllSubviews:(UIView *)v{
    while (v.subviews.count) {
        UIView* child = v.subviews.lastObject;
        [child removeFromSuperview];
    }
}
#pragma mark -- 退货--
- (void)qianshou:(UIButton *)button{
    NSLog(@"确认签收");
    //   192.168.1.31:9000/rest/v1/order/id/confirm_sign ;
    //  同步post
    JMOrderGoodsModel *model = [dataArray objectAtIndex:button.tag - 200];
    
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
            [button removeTarget:self action:@selector(qianshou:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            alterView.message = @"签收失败";
        }
        [alterView show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark
- (void)tuihuotuikuan:(UIButton *)button{
    NSLog(@"退货退款");
    //  dingdanModel -- > 
    NSInteger i = button.tag - 200;
    self.orderGoodsModel = [dataArray objectAtIndex:i];
    ShenQingTuiHuoController *tuiHuoVC = [[ShenQingTuiHuoController alloc] initWithNibName:@"ShenQingTuiHuoController" bundle:nil];
    tuiHuoVC.refundPrice = [self.orderGoodsModel.payment floatValue];
    tuiHuoVC.dingdanModel = self.orderGoodsModel;
    tuiHuoVC.tid = tid;
    tuiHuoVC.oid = [oidArray objectAtIndex:i];
    tuiHuoVC.status = self.orderGoodsModel.status_display;
    
    [self.navigationController pushViewController:tuiHuoVC animated:YES];
    
}
- (void)tuikuan:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    //进入退货界面；tuihuoModel -- >   orderGoodsModel
    NSInteger i = button.tag - 200;
//    NSDictionary *dic = [[dataArray objectAtIndex:i] mj_keyValues];
    self.orderGoodsModel = [dataArray objectAtIndex:i];
    
    ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
    
    tuikuanVC.dingdanModel = self.orderGoodsModel;
    tuikuanVC.refundDic = _refundDic;
    tuikuanVC.tid = tid;
    tuikuanVC.oid = [oidArray objectAtIndex:i];
    tuikuanVC.status = self.orderGoodsModel.status_display;
    [self.navigationController pushViewController:tuikuanVC animated:YES];
}
- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
    });
}

#pragma mark ---- 修改地址信息 增加点击事件
- (void)createAddressInfoImage {
    self.addressInfoImage.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressInfoClick:)];
    tap.numberOfTapsRequired = 1; // 单击
    [self.addressInfoImage addGestureRecognizer:tap];
}
- (void)addressInfoClick:(UITapGestureRecognizer *)tap {

    JMEditAddressController *editVC = [[JMEditAddressController alloc] init];
    editVC.delegate = self;
    editVC.editDict = (NSMutableDictionary *)[NSDictionary dictionaryWithDictionary:_orderDic];
    
    [self.navigationController pushViewController:editVC animated:YES];
}
/**
 *  修改地址的代理回调方法
 */
- (void)updateEditerWithmodel:(NSDictionary *)dic {
    self.nameLabel.text = dic[@"receiver_name"];
    self.phoneLabel.text = dic[@"receiver_mobile"];
    NSString *addStr = [NSString stringWithFormat:@"%@-%@-%@-%@",dic[@"receiver_state"],dic[@"receiver_city"],dic[@"receiver_district"],dic[@"receiver_address"]];
    self.addressLabel.text = addStr;
}
#pragma mark ---- 取消订单
- (IBAction)quxiaodingdan:(id)sender {
    NSLog(@"取消订单");
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小鹿美美" message:@"取消的产品可能会被人抢走哦~\n要取消吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}
#pragma mark --AlertViewDelegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%lD", (long)buttonIndex);
    if (buttonIndex == 1) {
        NSLog(@"stringURL = %@", self.urlString);
        NSMutableString *string = [[NSMutableString alloc] initWithString:self.urlString];
//        NSRange range =  [string rangeOfString:@"/details"];
//        [string deleteCharactersInRange:range];
        NSLog(@"newstring = %@", string);
        
        NSURL *url = [NSURL URLWithString:string];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"DELETE"];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        
        [self performSelector:@selector(poptoView) withObject:nil afterDelay:.3];
    }
}

- (void)poptoView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 重新购买
- (IBAction)goumai:(id)sender {
    NSLog(@"重新购买");
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/trades/%@",Root_URL,_orderDic[@"id"]];
    
    // NSLog(@"stringURL = %@", self.urlString);
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlStr];
//    NSRange range =  [string rangeOfString:@"/details"];
//
    //    [string deleteCharactersInRange:range];  http://staging.xiaolumeimei.com/rest/v2/trades/333644/charge

    [string appendString:@"/charge"];
    NSLog(@"newstring = %@", string);
    
//    NSString *str1 = @"http://m.xiaolumeimei.com/rest/v1/trades/354679/charge";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (!responseObject)return;
        NSError *parseError = nil;
        NSDictionary *dic = responseObject;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        XiangQingViewController * __weak weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
//                     [self.navigationController popViewControllerAnimated:YES];
                }
//[weakSelf showAlertMessage:result];
            }];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark --NSURLConnectionDataDelegate--
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //  NSLog(@"111 : %@", response);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    __unused NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //  NSLog(@"222 : %@", dic);
    NSString *charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //  NSLog(@"string = %@", charge);
    
    XiangQingViewController * __weak weakSelf = self;
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
}
@end

/**
 self.dingdanModel = [DingdanModel new];
 self.dingdanModel.dingdanID = [dicJson objectForKey:@"id"];
 self.dingdanModel.dingdanURL = [dicJson objectForKey:@"url"];
 self.dingdanModel.dingdanbianhao = [dicJson objectForKey:@"tid"];
 self.dingdanModel.imageURLString = [dicJson objectForKey:@"order_pic"];
 self.dingdanModel.dingdanTime = [dicJson objectForKey:@"created"];
 self.dingdanModel.status_display = [dicJson objectForKey:@"status_display"];
 self.dingdanModel.status = [dicJson objectForKey:@"status"];
 self.dingdanModel.dingdanJine = [dicJson objectForKey:@"payment"];
 self.dingdanModel.created = [dicJson objectForKey:@"created"];// 创建时间。。。
 self.dingdanModel.pay_time = [dicJson objectForKey:@"pay_time"];//付款时间。。。
 self.dingdanModel.consign_time = [dicJson objectForKey:@"consign_time"];//发货时间。。。。
 
 self.dingdanModel.ordersArray = dataArray;
 NSLog(@"dataArray = %@", dataArray);//orders 模型数组
 NSLog(@"refund_status_display = %@", refund_status_displayArray);//退货状态描述
 NSLog(@"refund_status = %@", refund_statusArray);//退货状态编码 0，1，2，3，4，5，6，7
 

 *
 //    for (NSDictionary *dic in orderArray) {
 //        orderGoodsModel *model = [orderGoodsModel new];
 //        model.urlString = [dic objectForKey:@"pic_path"];
 //        model.sizeString = [dic objectForKey:@"sku_name"];
 //        model.numberString = [dic objectForKey:@"num"];
 //        model.total_fee = [dic objectForKey:@"total_fee"];
 //        model.payment = [dic objectForKey:@"payment"];
 //        model.nameString = [dic objectForKey:@"title"];
 //        model.orderID = [dic objectForKey:@"id"];
 //        model.killTitle = [[dic objectForKey:@"kill_title"] boolValue];
 //        model.status_display = [dic objectForKey:@"status_display"];
 //        [dataArray addObject:model];
 //
 //        [refund_status_displayArray addObject:[dic objectForKey:@"refund_status_display"]];
 //        [refund_statusArray addObject:[dic objectForKey:@"refund_status"]];
 //        [orderStatus addObject:[dic objectForKey:@"status"]];
 //        [orderStatusDisplay addObject:[dic objectForKey:@"status_display"]];
 //        NSString *oid = [dic objectForKey:@"id"];
 //        [mutableArray addObject:oid];
 //    }
 
 
 for (NSDictionary *dic in dicJson) {
 JMPackAgeModel *model = [JMPackAgeModel new];
 model.title = [dic objectForKey:@"title"];
 model.pic_path = [dic objectForKey:@"pic_path"];
 model.num = [dic objectForKey:@"num"];
 model.payment = [dic objectForKey:@"payment"];
 model.assign_status_display = [dic objectForKey:@"assign_status_display"];
 model.ware_by_display = [dic objectForKey:@"ware_by_display"];
 model.out_sid = [dic objectForKey:@"out_sid"];
 model.logistics_company_name = [dic objectForKey:@"logistics_company_name"];
 model.logistics_company_code = [dic objectForKey:@"logistics_company_code"];
 model.process_time = [dic objectForKey:@"process_time"] ;
 model.package_group_key = [dic objectForKey:@"package_group_key"];
 [logisticsInfoArray addObject:model];
 
 if((model.package_group_key != nil) && (![model.package_group_key isEqualToString:groupKey])) {
 packetNum++;
 }
 groupKey = model.package_group_key;
 
 }
 
 if ([goodsStatus integerValue] == ORDER_STATUS_WAITPAY) { // 等待付款 --可以选择修改物流
 self.packStatusL.text = self.orderDetailModel.status_display; // === > 物流的状态
 self.packInfoView.userInteractionEnabled = YES;
 
 } else if ([goodsStatus integerValue] == ORDER_STATUS_PAYED){ // 已支付
 //        if ([self.orderDetailModel.created isEqual:[NSNull null]]) {
 //
 //        }
 
 
 if(packModel == nil || packModel.assign_status_display == nil || packModel.process_time == nil){
 //            self.packMessageL.text = packStr;
 self.packStatusL.text = self.orderDetailModel.status_display;
 if (self.orderDetailModel.pay_time != nil) {
 self.packInfoView.userInteractionEnabled = YES;
 }
 }
 else{
 self.packStatusL.text = packModel.assign_status_display;
 //            self.packStatusL.text =  self.orderDetailModel.logistics_company;
 }
 
 //某个商品已经是已发货了，那么也显示可以查询物流信息
 if(goodsStatus !=nil && [goodsStatus integerValue] == ORDER_STATUS_SENDED){
 self.packStatusL.text = _orderDetailModel.logistics_company;
 //            self.packStatusL.text = [NSString stringWithFormat:@"%@ %@ %@",  JMPackAgeModel.assign_status_display, JMPackAgeModel.logistics_company_name, JMPackAgeModel.out_sid];
 self.packInfoView.userInteractionEnabled = YES;
 
 }
 } else if ([goodsStatus integerValue] == ORDER_STATUS_SENDED){
 if(packModel == nil || packModel.assign_status_display == nil || packModel.process_time == nil){
 self.packStatusL.text = self.orderDetailModel.logistics_company;
 }
 else{
 self.packStatusL.text = packModel.assign_status_display;
 //            self.packStatusL.text = [NSString stringWithFormat:@"%@ %@ %@",  JMPackAgeModel.assign_status_display, JMPackAgeModel.logistics_company_name, JMPackAgeModel.out_sid];
 //            timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", JMPackAgeModel.process_time];
 }
 view.userInteractionEnabled = YES;
 
 } else if ([goodsStatus integerValue] == ORDER_STATUS_TRADE_SUCCESS){ // 交易成功
 
 self.packStatusL.text = self.orderDetailModel.status_display;
 //        if(self.dingdanModel.consign_time != nil){
 //            NSString *newStr = [self formatterTimeString:self.dingdanModel.consign_time];
 //            if(newStr != nil){
 //                self.packMessageL.text = packStr;
 //            }
 //        }
 self.packMessageL.text = packStr;
 
 } else if ([goodsStatus integerValue] == ORDER_STATUS_TRADE_CLOSE){
 self.packStatusL.text = self.orderDetailModel.status_display;
 self.packMessageL.text = packStr;
 
 } else if([goodsStatus integerValue] == ORDER_STATUS_CONFIRM_RECEIVE){
 
 self.packStatusL.text = self.orderDetailModel.status_display;
 //        if(self.dingdanModel.consign_time != nil){
 //            NSString *newStr = [self formatterTimeString:self.orderDetailModel.consign_time];
 //            if(newStr != nil){
 //                self.packMessageL.text = packStr;
 //            }
 //        }
 self.packMessageL.text = packStr;
 }
 else if([goodsStatus integerValue] == ORDER_STATUS_REFUND_CLOSE){
 // do other things
 //        self.packStatusL.text = @"订单创建成功";
 //        if(self.dingdanModel.created != nil){
 //            self.packMessageL.text = packStr;
 //        }
 self.packStatusL.text = self.orderGoodsModel.refund_status_display;
 self.packMessageL.text = packStr;
 }
 
 
 NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.urlString);
 NSLog(@"tuihuomodel payment= %@", tuikuanVC.dingdanModel.payment);
 NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.numberString);
 NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.sizeString);
 NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.nameString);
 
 
 else if ([[orderStatus objectAtIndex:index] integerValue] == ORDER_STATUS_CONFIRM_RECEIVE &&
 [[refund_statusArray objectAtIndex:index] integerValue] == REFUND_STATUS_NO_REFUND){
 UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
 [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
 [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
 button.backgroundColor = [UIColor whiteColor];
 [button setTitle:@"退货退款" forState:UIControlStateNormal];
 button.titleLabel.font = [UIFont systemFontOfSize:12];
 [button.layer setBorderWidth:0.5];
 button.tag = 200+index;
 button.layer.cornerRadius = 12.5;
 [button.layer setBorderColor:[UIColor orangeThemeColor].CGColor];
 [owner.myView addSubview:button];
 if (orderGoods.kill_title) {
 button.enabled = NO;
 [button setTitle:@"秒杀款不退不换" forState:UIControlStateNormal];
 [button setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
 button.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
 CGRect rect = button.frame;
 rect.size.width = 112;
 rect.origin.x -= 40;
 button.frame = rect;
 }
 }
 else{
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 50, 70, 40)];
 
 NSString *string = [refund_statusArray objectAtIndex:index];
 
 // 判断退款订单状态  显示给客服看。。。。。
 label.text = string;
 if ([string integerValue] == REFUND_STATUS_NO_REFUND ) {
 label.text = @"";
 }
 else if ([string integerValue] == REFUND_STATUS_BUYER_APPLY ) {
 label.text = @"已经申请退款";
 }
 else if ([string integerValue] == REFUND_STATUS_SELLER_AGREED ) {
 label.text = @"卖家同意退款";
 }
 else if ([string integerValue] == REFUND_STATUS_BUYER_RETURNED_GOODS ) {
 label.text = @"已经退货";
 }
 else if ([string integerValue] == REFUND_STATUS_SELLER_REJECTED ) {
 label.text = @"卖家拒绝退款";
 }
 else if ([string integerValue] == REFUND_STATUS_WAIT_RETURN_FEE ) {
 label.text = @"退款中";
 }
 else if ([string integerValue] == REFUND_STATUS_REFUND_CLOSE ) {
 label.text = @"退款关闭";
 }
 else if ([string integerValue] == REFUND_STATUS_REFUND_SUCCESS ) {
 label.text = @"退款成功";
 }
 
 label.numberOfLines = 0;
 label.font = [UIFont systemFontOfSize:12];
 label.textAlignment = NSTextAlignmentLeft;
 label.textColor = [UIColor darkGrayColor];
 [owner.myView addSubview:label];
 }

 
 */




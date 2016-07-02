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
#import "JMGoodsShowController.h"
#import "JMGoodsShowView.h"
#import "JMTimeLineView.h"
#import "JMPackAgeModel.h"
#import "JMNORefundView.h"
#import "JMPopViewAnimationSpring.h"

#define kUrlScheme @"wx25fcb32689872499"

@interface XiangQingViewController ()<JMNORefundViewDelegate,JMGoodsShowControllerDelegate,NSURLConnectionDataDelegate, UIAlertViewDelegate,JMEditAddressControllerDelegate,JMShareViewDelegate,JMPopLogistcsControllerDelegate>{
    
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
/**
 *  商品展示cell
 */
@property (nonatomic,strong) JMGoodsShowController *goodsShowVC;
/**
 *  包裹信息Model
 */
@property (nonatomic,strong) JMPackAgeModel *packageModel;

@property (nonatomic, strong) JMNORefundView *popView;

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
    
    
    NSMutableArray *_logisticsArr; //包裹分组信息
    NSMutableArray *_dataSource; //商品分组信息
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
    self.xiangqingScrollView.showsVerticalScrollIndicator = NO;
    
    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(btnClicked:)];
    currentIndex = 0;
    refund_status_displayArray = [[NSMutableArray alloc] initWithCapacity:0];
    refund_statusArray = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatus = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatusDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _logisticsArr = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.xiangqingScrollView];
    self.screenWidth.constant = SCREENWIDTH;//自定义宽度
    
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
    
    [self timeLine];
}

- (JMGoodsShowController *)goodsShowVC {
    if (!_goodsShowVC) {
        _goodsShowVC = [[JMGoodsShowController alloc] init];
    }
    return _goodsShowVC;
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
#pragma mark ---- 点击修改物流公司
- (void)logisticsChange {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLogisticsClick:)];
    [self.choiseLogisticsView addGestureRecognizer:tap];
    self.choiseLogisticsView.userInteractionEnabled = NO;
    self.showViewVC = [[JMPopLogistcsController alloc] init];
    
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
- (void)setWuLiuMsg:(NSArray *)dic {
    
    [_logisticsArr removeAllObjects];
    [_dataSource removeAllObjects];
    if (dic.count == 0) {
        CGFloat goodsH = 90 * dataArray.count;
        self.goodsViewHeight.constant = goodsH;
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dataArray];
        self.goodsShowVC.dataSource = arr;
        self.goodsShowVC.logisticsArr = _logisticsArr;
        self.goodsShowVC.delegate = self;
        JMGoodsShowView *goodsShowView = [[JMGoodsShowView alloc] init];
        goodsShowView.frame = CGRectMake(0, 0, SCREENWIDTH, goodsH);
        [self.myXiangQingView addSubview:goodsShowView];
        goodsShowView.backgroundColor = [UIColor orangeColor];
        goodsShowView.contentView = self.goodsShowVC.view;
        [_dataSource addObject:dataArray];
    }else {
        NSInteger count = [self.orderGoodsModel.status integerValue];
        if (count == ORDER_STATUS_PAYED) {
            self.choiseLogisticsView.userInteractionEnabled = YES;
            self.addressInfoImage.userInteractionEnabled = YES;
        }
        NSDictionary *dicts = dic[0];
        NSInteger number = 0;
        NSString *package = dicts[@"package_group_key"];
        NSMutableArray *logisArr = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dict in dic) {
            self.packModel = [JMPackAgeModel mj_objectWithKeyValues:dict];
            [logisArr addObject:self.packModel];
            [dataArr addObject:dataArray[number]];
            number ++;
            if (number == dic.count) {
                [_logisticsArr addObject:logisArr];
                [_dataSource addObject:dataArr];
            }else {
                NSDictionary * dict2 = dic[number];
                NSString *package2 = dict2[@"package_group_key"];
                
                if (package == package2) {
                    
                }else {
                    package = package2;
                    [_logisticsArr addObject:logisArr];
                    [_dataSource addObject:dataArr];
                    logisArr = [NSMutableArray array];
                    dataArr = [NSMutableArray array];
                }
            }
        }
        NSInteger numCount = 0;
        numCount = _dataSource.count;
        CGFloat goodsH = 90 * dataArray.count + 35 * numCount;
        self.goodsViewHeight.constant = goodsH;
        self.goodsShowVC.dataSource = _dataSource;
        self.goodsShowVC.logisticsArr = _logisticsArr;
        self.goodsShowVC.delegate = self;
        JMGoodsShowView *goodsShowView = [[JMGoodsShowView alloc] init];
        goodsShowView.frame = CGRectMake(0, 0, SCREENWIDTH, goodsH);
        [self.myXiangQingView addSubview:goodsShowView];
        goodsShowView.backgroundColor = [UIColor orangeColor];
        goodsShowView.contentView = self.goodsShowVC.view;
        
    }

}
- (void)composeWithLogistics:(JMGoodsShowController *)logistics didClickButton:(NSInteger)index {
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];
    
    NSArray *arr = _dataSource[index];
    NSArray *logisArr = _logisticsArr[index];
    queryVC.orderDataSource = arr;
    queryVC.logisDataSource = logisArr;

    queryVC.logName = self.logisticsLabel.text;

    [self.navigationController pushViewController:queryVC animated:YES];
}
- (void)composeOptionTapClick:(JMGoodsShowController *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row {
    JMQueryLogInfoController *queryVC = [[JMQueryLogInfoController alloc] init];

    NSArray *arr = _dataSource[section];
    queryVC.orderDataSource = arr;
    
    if (_logisticsArr.count == 0) {
        return ;
    }else {
        NSArray *array = _logisticsArr[section];
        queryVC.logisDataSource = array;
    }
    
    queryVC.logName = self.logisticsLabel.text;
    [self.navigationController pushViewController:queryVC animated:YES];
}
#pragma mark -- 商品可选状态
- (void)composeOptionBtnClick:(JMGoodsShowController *)goodsShow Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
    // 100 申请退款 101 确认收货 102 退货退款 103 秒杀不退不换
    NSArray *arr = _dataSource[section];
    JMOrderGoodsModel *model = arr[row];
    if (button.tag == 100) {
        self.packageModel = [[JMPackAgeModel alloc] init];
        if (_logisticsArr.count > 0) {
            NSArray *arr = _logisticsArr[section];
            self.packageModel = arr[row];
        }else {
            self.packageModel = nil;
        }
        
        BOOL isWarehouseOrder = (self.packageModel.assign_time != nil || self.packageModel.book_time != nil || self.packageModel.finish_time != nil);
        
        if (isWarehouseOrder) {
            [self returnPopView];
            [self.view addSubview:self.maskView];
            [self.view addSubview:self.popView];
            [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
        
        }else {
            ShenQingTuikuanController *tuikuanVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
            
            tuikuanVC.dingdanModel = model;
            tuikuanVC.refundDic = _refundDic;
            tuikuanVC.tid = tid;
            tuikuanVC.oid = model.orderGoodsID;
            tuikuanVC.status = model.status_display;
            tuikuanVC.button = button;
            [self.navigationController pushViewController:tuikuanVC animated:YES];
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
        tuiHuoVC.status = self.orderGoodsModel.status_display;
        
        [self.navigationController pushViewController:tuiHuoVC animated:YES];
        
    }else {
        
    }
}
#pragma mark -- 弹出视图
- (void)returnPopView {
    /**
     判断是否为第一次打开 -- 选择弹出优惠券弹窗
     */
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefundpopView)]];
    JMNORefundView *popView = [JMNORefundView defaultPopView];
    self.popView = popView;
    self.popView.delegate = self;
    
    

}
- (void)composeNoRefundButton:(JMNORefundView *)refundButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideRefundpopView];
    }else {
        [self hideRefundpopView];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  隐藏
 */
- (void)hideRefundpopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
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


- (void)removeAllSubviews:(UIView *)v{
    while (v.subviews.count) {
        UIView* child = v.subviews.lastObject;
        [child removeFromSuperview];
    }
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
#pragma mark -- 时间轴
//订单创建  支付成功  产品发货 产品签收 交易完成
- (void)timeLine {
    NSDictionary *dic = self.goodsArr[0];
    JMOrderGoodsModel *goodsModel = [JMOrderGoodsModel mj_objectWithKeyValues:dic];
    NSInteger countNum = [goodsModel.status integerValue];
    NSInteger refundNum = [goodsModel.refund_status integerValue];
    
    NSArray *desArr = [NSArray array];
    NSInteger count = 0;
    int i = 0;
    BOOL isCountNum = !(countNum == ORDER_STATUS_REFUND_CLOSE || countNum == ORDER_STATUS_TRADE_CLOSE);
    BOOL isRefundNum = (refundNum == REFUND_STATUS_NO_REFUND || refundNum == REFUND_STATUS_REFUND_CLOSE);
    if (isCountNum && isRefundNum) {
        self.timeLineViewH.constant = 60.;
        self.topLineH.constant = 60.;
        desArr = @[@"订单创建",@"支付成功",@"产品发货",@"产品签收",@"交易完成"];
        for (i = 0; i < desArr.count; i++) {
            if (countNum == i) {
                if (countNum >= 1) {
                    i --;
                }
                break;
            }else {
                continue;
            }
        }
        count = i + 1;
        
        self.lineTimeView.frame = CGRectMake(0, 0, SCREENWIDTH, 160);
        self.lineTimeView.backgroundColor = [UIColor orangeColor];
        
        UIScrollView *timeLineView = [[UIScrollView alloc] init];
        [self.lineTimeView addSubview:timeLineView];
        timeLineView.frame = CGRectMake(0, 0, SCREENWIDTH, 60);
        
        timeLineView.backgroundColor = [UIColor lineGrayColor];
        
        JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:timeLineView.frame];
        timeLineV.backgroundColor = [UIColor lineGrayColor];
        [timeLineView addSubview:timeLineV];
        
        timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
        timeLineView.showsHorizontalScrollIndicator = NO;
    }else {
        self.timeLineViewH.constant = 0.;
        self.topLineH.constant = 0;
        self.lineTimeView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
    }
}


@end




























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
#import "PerDingdanModel.h"
#import "DingDanXiangQingModel.h"
#import "UIImageView+WebCache.h"
#import "Pingpp.h"
#import "UIViewController+NavigationBar.h"
#import "ShenQingTuikuanController.h"
#import "ShenQingTuiHuoController.h"
#import "NSString+URL.h"
#import "WuliuViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XlmmMall.h"
#import "DingdanModel.h"
#import "UIColor+RGBColor.h"
#import "LogisticsModel.h"
#import "JMEditAddressController.h"
#import "JMEditAddressModel.h"
#import "MJExtension.h"
#import "JMOrderDetailModel.h"


#define kUrlScheme @"wx25fcb32689872499"

@interface XiangQingViewController ()<NSURLConnectionDataDelegate, UIAlertViewDelegate,JMEditAddressControllerDelegate>{
    
    float refundPrice;
}



@property (nonatomic,strong) JMEditAddressModel *model;

@property (nonatomic,strong) NSMutableDictionary *editAddDict;



@end


//订单详情页


@implementation XiangQingViewController{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView;
    UIView *frontView;
    NSString *status;
    PerDingdanModel *tuihuoModel;//详情页子订单模型
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
}
- (JMEditAddressModel *)model {
    if (_model == nil) {
        _model = [[JMEditAddressModel alloc] init];
    }
    return _model;
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
    
    
    frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    frontView.backgroundColor = [UIColor whiteColor];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2-80);
    [activityView startAnimating];
    [frontView addSubview:activityView];
    [self.view addSubview:frontView];
    
    self.quxiaoBtn.layer.cornerRadius = 20;
    self.quxiaoBtn.layer.borderWidth = 1;
    self.quxiaoBtn.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    
    
    self.buyBtn.layer.cornerRadius = 20;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    //跳转进入修改地址信息界面
    [self createAddressInfoImage];
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actiondo:(id)sender{
    UITapGestureRecognizer *tap = sender;
    UIView *tapView = (UIView*)tap.view;
    
    WuliuViewController *wuliuView = [[WuliuViewController alloc] initWithNibName:@"WuliuViewController" bundle:nil];
    if((tapView.tag >= 100) && (logisticsInfoArray.count > tapView.tag - 100)){
        
        
        wuliuView.packetId = ((LogisticsModel *)[logisticsInfoArray objectAtIndex:tapView.tag - 100]).out_sid;
        wuliuView.companyCode = ((LogisticsModel *)[logisticsInfoArray objectAtIndex:tapView.tag - 100]).logistics_company_code;
        [self.navigationController pushViewController:wuliuView animated:YES];
    }
    
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    //    [self downLoadWithURLString:self.urlString andSelector:@selector(fetchedDingdanData:)];
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
        self.model = [JMEditAddressModel mj_objectWithKeyValues:dict];

//        detailModel.logistic_company_code = responseObject[@"logistic_company"];
        _editAddDict = self.model.mj_keyValues;
        
        [self fetchedDingdanData:_orderDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
    
}

- (void)fetchedDingdanData:(NSDictionary *)responsedata{
    if (responsedata == nil) {
        //   NSLog(@"下载失败");
        return;
    }
    
    NSDictionary *dicJson = responsedata;
    //    NSLog(@"fetchedDingdanData JSON = %@", dicJson);
    [self transferOrderModel:dicJson];
    
    [activityView removeFromSuperview];
    //订单状态
    NSInteger tradeStatus = [[dicJson objectForKey:@"status"] integerValue];
    
    //判断在详情页是否显示取消订单和重新购买按钮。。。。。
    if (tradeStatus == ORDER_STATUS_WAITPAY) {
        //   NSLog(@"待支付状态订单订单");
        self.quxiaoBtn.hidden = NO;
        self.buyBtn.hidden = NO;
        
#pragma 显示剩余支付时间。。。。。
        createdString = [self formatterTimeString:[dicJson objectForKey:@"created"]];
        //  NSLog(@"created:%@", createdString);
        
        theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
        
    } else {
        // NSLog(@"其他状态订单");
        self.quxiaoBtn.hidden = YES;
        self.buyBtn.hidden = YES;
        
        NSLog(@"订单不是待付款状态");
        self.bottomViewHeight.constant = -60;
        
        self.bottomView.hidden = YES;
    }
    
    //订单编号和状态
    NSString *statusDisplay = [dicJson objectForKey:@"status_display"];
    self.headdingdanzhuangtai.text = statusDisplay;
    self.nameLabel.text = _model.receiver_name;
    self.phoneLabel.text = _model.receiver_mobile;

    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",_model.receiver_state,_model.receiver_city,_model.receiver_district,_model.receiver_address];
    self.addressLabel.text = addressStr;
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];//
    
    tid = [dicJson objectForKey:@"id"]; //交易id号 内部使用
    
    [self removeAllSubviews:self.myXiangQingView];
    //    if((tradeStatus == ORDER_STATUS_PAYED) || (tradeStatus == ORDER_STATUS_SENDED)){
    //需要查物流信息，查询到信息后
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *str = [NSString stringWithFormat:@"%@/rest/packageskuitem?sale_trade_id=%@", Root_URL,[dicJson objectForKey:@"tid"]];
    [manage GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setWuLiuMsg:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"packageskuitem failed.");
    }];
    //    }
    //    else{
    //        //不用查物流信息，直接显示时间和商品即可
    //        self.goodsViewHeight.constant = 76 + 90 * dataArray.count;
    //        [self createProcessView:CGRectMake(0, 0, SCREENWIDTH, 76) status:orderStatus[0] logisticsModel:nil];
    //        NSUInteger  h=76;
    //        for(int i=0; i < dataArray.count; i++){
    //            [self createXiangQing:CGRectMake(0, h, SCREENWIDTH, 90) number:i];
    //            h += 90;
    //        }
    //    }
    
    self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.02f",[[dicJson objectForKey:@"total_fee"] floatValue]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"＋¥%.02f", [[dicJson objectForKey:@"post_fee"] floatValue]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"－¥%.02f", [[dicJson objectForKey:@"discount_fee"] floatValue]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"¥%.02f", [[dicJson objectForKey:@"payment"] floatValue]];
    
    refundPrice = [[dicJson objectForKey:@"payment"] floatValue];
    
    
    
}

- (void)transferOrderModel:(NSDictionary *)dicJson{
    NSArray *orderArray = [dicJson objectForKey:@"orders"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray removeAllObjects];
    [refund_status_displayArray removeAllObjects];
    [refund_statusArray removeAllObjects];
    [orderStatus removeAllObjects];
    [orderStatusDisplay removeAllObjects];
    
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
    
    for (NSDictionary *dic in orderArray) {
        PerDingdanModel *model = [PerDingdanModel new];
        model.urlString = [dic objectForKey:@"pic_path"];
        model.sizeString = [dic objectForKey:@"sku_name"];
        model.numberString = [dic objectForKey:@"num"];
        model.total_fee = [dic objectForKey:@"total_fee"];
        model.payment = [dic objectForKey:@"payment"];
        model.nameString = [dic objectForKey:@"title"];
        model.orderID = [dic objectForKey:@"id"];
        model.killTitle = [[dic objectForKey:@"kill_title"] boolValue];
        model.status_display = [dic objectForKey:@"status_display"];
        [dataArray addObject:model];
        
        [refund_status_displayArray addObject:[dic objectForKey:@"refund_status_display"]];
        [refund_statusArray addObject:[dic objectForKey:@"refund_status"]];
        [orderStatus addObject:[dic objectForKey:@"status"]];
        [orderStatusDisplay addObject:[dic objectForKey:@"status_display"]];
        NSString *oid = [dic objectForKey:@"id"];
        [mutableArray addObject:oid];
    }
    self.dingdanModel.ordersArray = dataArray;
    NSLog(@"dataArray = %@", dataArray);//orders 模型数组
    NSLog(@"refund_status_display = %@", refund_status_displayArray);//退货状态描述
    NSLog(@"refund_status = %@", refund_statusArray);//退货状态编码 0，1，2，3，4，5，6，7
    
    oidArray = [[NSArray alloc] initWithArray:mutableArray];
    NSLog(@"oids = %@", oidArray);
}

- (void)transferLogisticsModel:(NSDictionary *)dicJson{
    
    logisticsInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    packetNum = 0;
    NSString *groupKey = @"";
    
    for (NSDictionary *dic in dicJson) {
        LogisticsModel *model = [LogisticsModel new];
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
    
}

- (void)createProcessView:(CGRect )rect status:(NSString *)goodsStatus logisticsModel:(LogisticsModel *)logisticsModel{
    if((goodsStatus != nil) && (logisticsModel != nil)){
        NSLog(@"createProcessView orderStatus=%@ time=%@ company=%@ packetId=%@", goodsStatus, logisticsModel.process_time, logisticsModel.logistics_company_name, logisticsModel.out_sid);
    }
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor backgroundlightGrayColor];
    //    view.layer.cornerRadius = 4;
    view.tag = 100 + currentIndex;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 1, 76)];
    lineView.backgroundColor = [UIColor orangeThemeColor];
    [view addSubview:lineView];
    
    UIView *ballView = [[UIView alloc] initWithFrame:CGRectMake(16, 18, 10, 10)];
    ballView.backgroundColor = [UIColor orangeThemeColor];
    ballView.layer.cornerRadius = 6;
    [view addSubview:ballView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 10, 200, 15)];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:timeLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 32, 250, 17)];
    statusLabel.textColor = [UIColor blackColor];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:statusLabel];
    
    UILabel *packetLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 54, 250, 17)];
    packetLabel.textColor = [UIColor blackColor];
    packetLabel.font = [UIFont systemFontOfSize:12];
    packetLabel.text = @"以下商品由同一个包裹发出";
    [view addSubview:packetLabel];
    [self.myXiangQingView addSubview:view];
    
    
    if ([goodsStatus integerValue] == ORDER_STATUS_WAITPAY) {
        statusLabel.text = @"订单创建成功";
        if(self.dingdanModel.created != nil){
            NSString *newStr = [self formatterTimeString:self.dingdanModel.created ];
            timeLabel.text = newStr;
        }
        
    } else if ([goodsStatus integerValue] == ORDER_STATUS_PAYED){
        if(logisticsModel == nil || logisticsModel.assign_status_display == nil || logisticsModel.process_time == nil){
            statusLabel.text = self.dingdanModel.status_display ;
            if(self.dingdanModel.pay_time != nil){
                NSString *newStr = [self formatterTimeString:self.dingdanModel.pay_time ];
                timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", newStr];
            }
        }
        else{
            statusLabel.text = logisticsModel.assign_status_display;
            timeLabel.text =  [NSString stringWithFormat:@"%@:%@", @"时间", logisticsModel.process_time];
        }
        
        //某个商品已经是已发货了，那么也显示可以查询物流信息
        if(goodsStatus !=nil && [goodsStatus integerValue] == ORDER_STATUS_SENDED){
            statusLabel.text = [NSString stringWithFormat:@"%@ %@ %@",  logisticsModel.assign_status_display, logisticsModel.logistics_company_name, logisticsModel.out_sid];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 30, 30, 15, 15)];
            [img setImage:[UIImage imageNamed:@"rightArrow.png"]];
            [view addSubview:img];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actiondo:)];
            [view addGestureRecognizer:tapGesture];
        }
    } else if ([goodsStatus integerValue] == ORDER_STATUS_SENDED){
        if(logisticsModel == nil || logisticsModel.assign_status_display == nil || logisticsModel.process_time == nil){
            statusLabel.text = [NSString stringWithFormat:@"%@", self.dingdanModel.status_display ];
            if(self.dingdanModel.consign_time != nil){
                NSString *newStr = [self formatterTimeString:self.dingdanModel.consign_time];
                timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", newStr];
            }
        }
        else{
            statusLabel.text = [NSString stringWithFormat:@"%@ %@ %@",  logisticsModel.assign_status_display, logisticsModel.logistics_company_name, logisticsModel.out_sid];
            timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", logisticsModel.process_time];
        }
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 30, 30, 15, 15)];
        [img setImage:[UIImage imageNamed:@"rightArrow.png"]];
        [view addSubview:img];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actiondo:)];
        [view addGestureRecognizer:tapGesture];
        
    } else if ([goodsStatus integerValue] == ORDER_STATUS_TRADE_SUCCESS){
        
        statusLabel.text = [NSString stringWithFormat:@"%@", self.dingdanModel.status_display ];
        if(self.dingdanModel.consign_time != nil){
            NSString *newStr = [self formatterTimeString:self.dingdanModel.consign_time];
            if(newStr != nil){
                timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", newStr];
            }
        }
        
        
    } else if ([goodsStatus integerValue] == ORDER_STATUS_TRADE_CLOSE){
        statusLabel.text = @"订单创建成功";
        if(self.dingdanModel.created != nil){
            NSString *newStr = [self formatterTimeString:self.dingdanModel.created ];
            timeLabel.text = newStr;
        }
    } else if([goodsStatus integerValue] == ORDER_STATUS_CONFIRM_RECEIVE){
        
        statusLabel.text = [NSString stringWithFormat:@"%@", self.dingdanModel.status_display ];
        if(self.dingdanModel.consign_time != nil){
            NSString *newStr = [self formatterTimeString:self.dingdanModel.consign_time];
            if(newStr != nil){
                timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"时间", newStr];
            }
        }
        
    } else if([goodsStatus integerValue] == ORDER_STATUS_REFUND_CLOSE){
        // do other things
        statusLabel.text = @"订单创建成功";
        if(self.dingdanModel.created != nil){
            NSString *newStr = [self formatterTimeString:self.dingdanModel.created ];
            //            NSString *timeString = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];//发货时间。。。。
            timeLabel.text = newStr;
        }
    }
    
    
    
    
}

- (void)setWuLiuMsg:(NSDictionary *)dic {
    if (dic.count == 0){
        NSLog(@"setWuLiuMsg dic count=0");
        //无查物流信息，直接显示时间和商品即可
        self.goodsViewHeight.constant = 76 + 90 * dataArray.count;
        [self createProcessView:CGRectMake(0, 0, SCREENWIDTH, 76) status:orderStatus[0] logisticsModel:nil];
        NSUInteger  h=76;
        for(int i=0; i < dataArray.count; i++){
            [self createXiangQing:CGRectMake(0, h, SCREENWIDTH, 90) number:i];
            h += 90;
        }
        return;
    }
    
    [self  transferLogisticsModel:dic];
    
    NSString *groupKey = @"";
    NSInteger h = 0;
    self.goodsViewHeight.constant = packetNum * 76 + logisticsInfoArray.count * 90 + 15 *(packetNum - 1);
    for(int i =0; i < logisticsInfoArray.count; i++){
        currentIndex = i;
        NSLog(@"setWuLiuMsg logis groupkey=%@  temp groupkey=%@",((LogisticsModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key, groupKey);
        if((((LogisticsModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key != nil) && (![((LogisticsModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key isEqualToString:groupKey])) {
            if(i != 0) h+= 15;
            [self createProcessView:CGRectMake(0, h, SCREENWIDTH, 76) status:[orderStatus objectAtIndex:i] logisticsModel:((LogisticsModel *)[logisticsInfoArray objectAtIndex:i])];
            h += 76;
        }
        groupKey = ((LogisticsModel *)[logisticsInfoArray objectAtIndex:i]).package_group_key;
        
        [self createXiangQing:CGRectMake(0, h, SCREENWIDTH, 90) number:i];
        h += 90;
    }
}

//设计倒计时方法。。。。
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
    if ([d minute] <0 || [d second] < 0) {
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
    return newString;
}


- (void)createXiangQing:(CGRect )rect number:(NSInteger)index{
    XiangQingView *owner = [XiangQingView new];
    PerDingdanModel *model = [dataArray objectAtIndex:index];
    
    
    [[NSBundle mainBundle] loadNibNamed:@"XiangQingView" owner:owner options:nil];
    owner.myView.frame = (rect);
    
    [owner.frontView sd_setImageWithURL:[NSURL URLWithString:[model.urlString URLEncodedString]]];
    owner.frontView.contentMode = UIViewContentModeScaleAspectFill;
    owner.frontView.layer.masksToBounds = YES;
    owner.frontView.layer.borderWidth = 0.5;
    owner.frontView.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    owner.frontView.layer.cornerRadius = 5;
    
    owner.nameLabel.text = model.nameString;
    owner.sizeLabel.text = model.sizeString;
    owner.numberLabel.text = [NSString stringWithFormat:@"x%@", model.numberString];
    owner.priceLabel.text =[NSString stringWithFormat:@"¥%.1f", [model.payment floatValue]];
    
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
            NSString *string = [refund_status_displayArray objectAtIndex:index];
            label.text = string;
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
    } else if ([[orderStatus objectAtIndex:index] integerValue] == ORDER_STATUS_TRADE_SUCCESS &&
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
        if (model.killTitle) {
            button.enabled = NO;
            [button setTitle:@"秒杀款不退不换" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
            CGRect rect = button.frame;
            rect.size.width = 112;
            rect.origin.x -= 40;
            button.frame = rect;
        }
    } else if ([[orderStatus objectAtIndex:index] integerValue] == ORDER_STATUS_CONFIRM_RECEIVE &&
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
        if (model.killTitle) {
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
        NSString *string = [refund_status_displayArray objectAtIndex:index];
        
        
        // 判断退款订单状态  显示给客服看。。。。。
        label.text = string;
        if ([string integerValue] == REFUND_STATUS_NO_REFUND ) {
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
    PerDingdanModel *model = [dataArray objectAtIndex:button.tag - 200];
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/order/%@/confirm_sign", Root_URL, model.orderID];
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
    
    NSInteger i = button.tag - 200;
    tuihuoModel = [dataArray objectAtIndex:i];
    ShenQingTuiHuoController *tuikuanVC = [[ShenQingTuiHuoController alloc] initWithNibName:@"ShenQingTuiHuoController" bundle:nil];
    tuikuanVC.refundPrice = [tuihuoModel.payment floatValue];
    tuikuanVC.dingdanModel = tuihuoModel;
    
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.urlString);
    NSLog(@"tuihuomodel payment= %@", tuikuanVC.dingdanModel.payment);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.numberString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.sizeString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.nameString);
    tuikuanVC.tid = tid;
    tuikuanVC.oid = [oidArray objectAtIndex:i];
    tuikuanVC.status = self.dingdanModel.status_display;
    
    NSLog(@"tid = %@, \noid = %@ \nstatus = %@", tuikuanVC.tid, tuikuanVC.oid, tuikuanVC.status);
    [self.navigationController pushViewController:tuikuanVC animated:YES];
    
    
    
    
}
- (void)tuikuan:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    //进入退货界面；
    NSInteger i = button.tag - 200;
    tuihuoModel = [dataArray objectAtIndex:i];
    
    ShenQingTuikuanController *tuiHuoVC = [[ShenQingTuikuanController alloc] initWithNibName:@"ShenQingTuikuanController" bundle:nil];
    
    tuiHuoVC.dingdanModel = tuihuoModel;
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.urlString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.payment);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.numberString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.sizeString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.nameString);
    tuiHuoVC.tid = tid;
    tuiHuoVC.oid = [oidArray objectAtIndex:i];
    tuiHuoVC.status = self.dingdanModel.status_display;
    
    NSLog(@"tid = %@, \noid = %@ \nstatus = %@", tuiHuoVC.tid, tuiHuoVC.oid, tuiHuoVC.status);
    
    //
    [self.navigationController pushViewController:tuiHuoVC animated:YES];
    
    
    
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
    self.addressInfoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressInfoClick:)];
    //点击的次数
    tap.numberOfTapsRequired = 1; // 单击
    //给self.view添加一个手势监测；
    
    [self.addressInfoImage addGestureRecognizer:tap];
    
}
- (void)addressInfoClick:(UITapGestureRecognizer *)tap {
    
    //    JMEditAddressModel *editModel = [[JMEditAddressModel alloc] init];
    //    editModel.receiver_name = _editAddDict[@"receiver_name"];
    //
    JMEditAddressController *editVC = [[JMEditAddressController alloc] init];
    editVC.delegate = self;
    editVC.editDict = _editAddDict;
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (void)updateEditerWithmodel:(NSDictionary *)dic {
    
    JMEditAddressModel *model = [JMEditAddressModel mj_objectWithKeyValues:dic];
    
    
    self.nameLabel.text = dic[@"receiver_name"];
    self.phoneLabel.text = model.receiver_mobile;
    NSString *addStr = [NSString stringWithFormat:@"%@%@%@%@",model.receiver_state,model.receiver_city,model.receiver_district,model.receiver_address];
    self.addressLabel.text = addStr;
    
    
    
}

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
        NSRange range =  [string rangeOfString:@"/details"];
        [string deleteCharactersInRange:range];
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
- (IBAction)goumai:(id)sender {
    NSLog(@"重新购买");
    
    // NSLog(@"stringURL = %@", self.urlString);
    NSMutableString *string = [[NSMutableString alloc] initWithString:self.urlString];
    NSRange range =  [string rangeOfString:@"/details"];
    [string deleteCharactersInRange:range];
    [string appendString:@"/charge"];
    NSLog(@"newstring = %@", string);
    
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
                    // [self.navigationController popViewControllerAnimated:YES];
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

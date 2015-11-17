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
#import "TuihuoController.h"
#import "Pingpp.h"
#import "UIViewController+NavigationBar.h"
#import "ShenQingTuikuanController.h"
#import "ShenQingTuiHuoController.h"
#import "NSString+URL.h"
#import "WuliuViewController.h"


#define kUrlScheme @"wx25fcb32689872499"

@interface XiangQingViewController ()<NSURLConnectionDataDelegate, UIAlertViewDelegate>{
}


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
    NSString *tradeId; //unique trade id for user
    NSTimer *theTimer;
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
    
    refund_status_displayArray = [[NSMutableArray alloc] initWithCapacity:0];
    refund_statusArray = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatus = [[NSMutableArray alloc] initWithCapacity:0];
    orderStatusDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];

    
    [self.view addSubview:self.xiangqingScrollView];
    self.screenWidth.constant = SCREENWIDTH;//自定义宽度
    self.myViewHeight.constant = 0;
    
    
    frontView = [[UIView alloc] initWithFrame:self.view.bounds];
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actiondo:)];
    
    [self.WuliuView addGestureRecognizer:tapGesture];
    
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actiondo:(id)sender{
    WuliuViewController *wuliuView = [[WuliuViewController alloc] initWithNibName:@"WuliuViewController" bundle:nil];
    
    wuliuView.tradeId = tradeId;
    [self.navigationController pushViewController:wuliuView animated:YES];
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    [self downLoadWithURLString:self.urlString andSelector:@selector(fetchedDingdanData:)];
    
}

- (void)fetchedDingdanData:(NSData *)responsedata{
    if (responsedata == nil) {
        NSLog(@"下载失败");
        return;
    }
    
    NSError *error = nil;
    
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"解析失败");
        return;
    }
    NSLog(@"JSON = %@", dicJson);
    
    [activityView removeFromSuperview];
    //订单状态
    NSString *statusname = [dicJson objectForKey:@"status_display"];
    status = [dicJson objectForKey:@"status_display"];
    //判断在详情页是否显示取消订单和重新购买按钮。。。。。
    if ([statusname isEqualToString:@"待付款"]) {
        NSLog(@"待支付状态订单订单");
        self.quxiaoBtn.hidden = NO;
        self.buyBtn.hidden = NO;
        
        
    //    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(aa) userInfo:nil repeats:YES];
        
        
    } else {
        NSLog(@"其他状态订单");
        self.quxiaoBtn.hidden = YES;
        self.buyBtn.hidden = YES;
    }

    //订单编号和状态
    
    
   // self.headdingdanzhuangtai.text = [dicJson objectForKey:@"status_display"];
    
    
    NSString *statusDisplay = [dicJson objectForKey:@"status_display"];
    if (![statusDisplay isEqualToString:@"待付款"]) {
        NSLog(@"订单不是待付款状态");
        self.bottomViewHeight.constant = -60;
        
        self.bottomView.hidden = YES;
    }
    
    if ([statusDisplay isEqualToString:@"待付款"]) {
        self.zhuangtaiLabel.text = @"订单创建成功";

    } else if ([statusDisplay isEqualToString:@"已付款"]){
        self.zhuangtaiLabel.text = @"您已提交了订单，请等待系统确认";
        self.headdingdanzhuangtai.text = @"待发货";
    } else if (([statusDisplay isEqualToString:@"已发货"])){
        self.zhuangtaiLabel.text = @"到达目的地网点上海杨浦区公司";
        self.headdingdanzhuangtai.text = @"待收货";
    } else if (([statusDisplay isEqualToString:@"交易成功"])){
        self.zhuangtaiLabel.text = @"已签收";
        self.headdingdanzhuangtai.text = @"交易成功";

    } else if (([statusDisplay isEqualToString:@"交易关闭"])){
        self.zhuangtaiLabel.text = @"交易关闭";
        self.headdingdanzhuangtai.text = @"交易关闭";

    }
    
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];//
    
    tid = [dicJson objectForKey:@"id"]; //交易id号 内部使用
    tradeId = [dicJson objectForKey:@"tid"]; //交易ID，客户可见
    
    NSMutableString *string = [NSMutableString stringWithString:[dicJson objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
    [string deleteCharactersInRange:range];
    [string insertString:@"  " atIndex:range.location];
    self.finishedLabel.text = string;//时间 创建订单时间  付款时间 发货时间
    
    self.lastStatusLabel.text = [dicJson objectForKey:@"status_display"];
    self.yuanqiuView.layer.cornerRadius = 6;
    self.timeLabel.text = string;
    self.jineLabel.text = [NSString stringWithFormat:@"￥%.1f", [[dicJson objectForKey:@"payment"] floatValue]];
    
    self.nameLabel.text = [dicJson objectForKey:@"receiver_name"];
    self.phoneLabel.text = [dicJson objectForKey:@"receiver_mobile"];
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",
                           [dicJson objectForKey:@"receiver_state"],
                           [dicJson objectForKey:@"receiver_city"],
                           [dicJson objectForKey:@"receiver_district"],
                            [dicJson objectForKey:@"receiver_address"]];
    self.addressLabel.text = addressStr;
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dicJson objectForKey:@"total_fee"] floatValue]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"＋¥%@", [dicJson objectForKey:@"post_fee"]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"－¥%@", [dicJson objectForKey:@"discount_fee"]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dicJson objectForKey:@"payment"] floatValue]];
    
    
    
    NSArray *orderArray = [dicJson objectForKey:@"orders"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray removeAllObjects];
    
    
    for (NSDictionary *dic in orderArray) {
        PerDingdanModel *model = [PerDingdanModel new];
        model.urlString = [dic objectForKey:@"pic_path"];
        model.sizeString = [dic objectForKey:@"sku_name"];
        model.numberString = [dic objectForKey:@"num"];
        model.priceString = [dic objectForKey:@"total_fee"];
        model.nameString = [dic objectForKey:@"title"];
        model.orderID = [dic objectForKey:@"id"];
        [dataArray addObject:model];
        
        [refund_status_displayArray addObject:[dic objectForKey:@"refund_status_display"]];
        [refund_statusArray addObject:[dic objectForKey:@"refund_status"]];
        [orderStatus addObject:[dic objectForKey:@"status"]];
        [orderStatusDisplay addObject:[dic objectForKey:@"status_display"]];
        NSString *oid = [dic objectForKey:@"id"];
        [mutableArray addObject:oid];
    }
    NSLog(@"dataArray = %@", dataArray);//orders 模型数组
    NSLog(@"refund_status_display = %@", refund_status_displayArray);//退货状态描述
    NSLog(@"refund_status = %@", refund_statusArray);//退货状态编码 0，1，2，3，4，5，6，7
    
    oidArray = [[NSArray alloc] initWithArray:mutableArray];
    NSLog(@"oids = %@", oidArray);
    NSLog(@"tid = %@", tid);
    [self createXiangQing];

    
}

- (void)createXiangQing{
    NSUInteger number = dataArray.count;
    self.myViewHeight.constant = number * 90;
    XiangQingView *owner = [XiangQingView new];
    PerDingdanModel *model = nil;
    for (int i = 0; i<number ; i++) {
        
        
        [[NSBundle mainBundle] loadNibNamed:@"XiangQingView" owner:owner options:nil];
        owner.myView.frame = CGRectMake(0, 0 + 90 * i, SCREENWIDTH, 90);
        
        model = [dataArray objectAtIndex:i];
        [owner.frontView sd_setImageWithURL:[NSURL URLWithString:[model.urlString URLEncodedString]]];
        owner.frontView.layer.masksToBounds = YES;
        owner.frontView.layer.borderWidth = 0.5;
        owner.frontView.layer.borderColor = [UIColor colorWithR:151 G:151 B:151 alpha:1].CGColor;
        owner.frontView.layer.cornerRadius = 5;
        
        owner.nameLabel.text = model.nameString;
        owner.sizeLabel.text = model.sizeString;
        owner.numberLabel.text = [NSString stringWithFormat:@"x%@", model.numberString];
        owner.priceLabel.text =[NSString stringWithFormat:@"¥%.1f", [model.priceString floatValue]];
       
        if ([[orderStatusDisplay objectAtIndex:i] isEqualToString:@"已付款"]) {
            if ([[refund_statusArray objectAtIndex:i] integerValue] == 0) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
                [button addTarget:self action:@selector(tuikuan:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor colorWithR:245 G:166 B:35 alpha:1] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor whiteColor];
                [button setTitle:@"申请退款" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [button.layer setBorderWidth:0.5];
                button.tag = 200+i;
                button.layer.cornerRadius = 12.5;
                [button.layer setBorderColor:[UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor];
                [owner.myView addSubview:button];
            } else {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 50, 70, 40)];
                NSString *string = [refund_status_displayArray objectAtIndex:i];
                label.text = string;
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:12];
                label.textAlignment = NSTextAlignmentLeft;
                label.textColor = [UIColor darkGrayColor];
                [owner.myView addSubview:label];
            }
            
           
        
        } else if ([[orderStatusDisplay objectAtIndex:i] isEqualToString:@"已发货"]){
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
            [button addTarget:self action:@selector(qianshou:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithR:245 G:166 B:35 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"确认收货" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button.layer setBorderWidth:0.5];
            button.tag = 200+i;
            button.layer.cornerRadius = 12.5;
            [button.layer setBorderColor:[UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor];
            [owner.myView addSubview:button];
        } else if ([[orderStatusDisplay objectAtIndex:i] isEqualToString:@"交易成功"]){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
            [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithR:245 G:166 B:35 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"退货退款" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button.layer setBorderWidth:0.5];
            button.tag = 200+i;
            button.layer.cornerRadius = 12.5;
            [button.layer setBorderColor:[UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor];
            [owner.myView addSubview:button];
        } else if ([[orderStatusDisplay objectAtIndex:i] isEqualToString:@"确认签收"]){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 55, 70, 25)];
            [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithR:245 G:166 B:35 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"退货退款" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button.layer setBorderWidth:0.5];
            button.tag = 200+i;
            button.layer.cornerRadius = 12.5;
            [button.layer setBorderColor:[UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor];
            [owner.myView addSubview:button];
        }
        
        
        else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, 50, 70, 40)];
            NSString *string = [refund_status_displayArray objectAtIndex:i];
            if ([string isEqualToString:@"没有退款"] ) {
               // string = @"";
            }
            label.text = string;
            label.numberOfLines = 0;
            
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor darkGrayColor];
            [owner.myView addSubview:label];
            
            
        }
        [self.myXiangQingView addSubview:owner.myView];
        
    }
    [frontView removeFromSuperview];
    
    

}




#pragma mark -- 退货--

- (void)qianshou:(UIButton *)button{
    NSLog(@"确认签收");
    
 //   192.168.1.31:9000/rest/v1/order/id/confirm_sign ;
    //  同步post
    PerDingdanModel *model = [dataArray objectAtIndex:button.tag - 200];
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/order/%@/confirm_sign", Root_URL, model.orderID];
    NSLog(@"url string = %@", string);
    NSURL *url = [NSURL URLWithString:string];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
//    NSString *str = @"type=focus-c";//设置参数
//    
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
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
    //[self.navigationController popViewControllerAnimated:YES];
    
    
 
    
}

#pragma mark
- (void)tuihuotuikuan:(UIButton *)button{
    NSLog(@"退货退款");
    
    NSInteger i = button.tag - 200;
    tuihuoModel = [dataArray objectAtIndex:i];
    ShenQingTuiHuoController *tuikuanVC = [[ShenQingTuiHuoController alloc] initWithNibName:@"ShenQingTuiHuoController" bundle:nil];
    
    tuikuanVC.dingdanModel = tuihuoModel;
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.urlString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.priceString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.numberString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.sizeString);
    NSLog(@"tuihuomodel = %@", tuikuanVC.dingdanModel.nameString);
    tuikuanVC.tid = tid;
    tuikuanVC.oid = [oidArray objectAtIndex:i];
    tuikuanVC.status = self.zhuangtaiLabel.text;
    
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
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.priceString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.numberString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.sizeString);
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.nameString);
    tuiHuoVC.tid = tid;
    tuiHuoVC.oid = [oidArray objectAtIndex:i];
    tuiHuoVC.status = self.zhuangtaiLabel.text;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    }
}

- (IBAction)goumai:(id)sender {
    NSLog(@"重新购买");
    
   // NSLog(@"stringURL = %@", self.urlString);
    NSMutableString *string = [[NSMutableString alloc] initWithString:self.urlString];
    NSRange range =  [string rangeOfString:@"/details"];
    [string deleteCharactersInRange:range];
    [string appendString:@"/charge"];
    NSLog(@"newstring = %@", string);
    
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    
}




#pragma mark --NSURLConnectionDataDelegate--


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"111 : %@", response);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"222 : %@", dic);
    NSString *charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      NSLog(@"string = %@", charge);
    
    XiangQingViewController * __weak weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            
            NSLog(@"completion block: %@", result);
            
            if (error == nil) {
                NSLog(@"PingppError is nil");
            } else {
                NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                [self.navigationController popViewControllerAnimated:YES];
            }
            //[weakSelf showAlertMessage:result];
        }];
    });
}
@end

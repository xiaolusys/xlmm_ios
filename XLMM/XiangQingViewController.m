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

#define kUrlScheme @"wx25fcb32689872499"

@interface XiangQingViewController ()<NSURLConnectionDataDelegate, UIAlertViewDelegate>{
    NSString *tid;
    NSArray *oidArray;
    NSMutableArray *refund_statusArray;
    NSMutableArray *refund_status_displayArray;
    
}




@end

@implementation XiangQingViewController{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView;
    UIView *frontView;
    NSString *status;
    PerDingdanModel *tuihuoModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self createInfo];
    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(btnClicked:)];
    refund_status_displayArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    refund_statusArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.xiangqingScrollView];
    self.screenWidth.constant = SCREENWIDTH;
    self.myViewHeight.constant = 0;
    
    
    frontView = [[UIView alloc] initWithFrame:self.view.frame];
    frontView.backgroundColor = [UIColor whiteColor];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2-80);
    [activityView startAnimating];
    [frontView addSubview:activityView];
    [self.view addSubview:frontView];
    
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/details", _dingdanModel.dingdanURL];
//    NSLog(@"detailsURL = %@", urlString);
    
    
    [self downLoadWithURLString:self.urlString andSelector:@selector(fetchedDingdanData:)];
    
}

- (void)fetchedDingdanData:(NSData *)responsedata{
    NSError *error = nil;
    
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSLog(@"JSON = %@", dicJson);
    
    [activityView removeFromSuperview];
    NSString *statusname = [dicJson objectForKey:@"status_display"];
    status = [dicJson objectForKey:@"status_display"];
    if ([statusname isEqualToString:@"交易关闭"] || [statusname isEqualToString:@"交易成功"]) {
        NSLog(@"交易订单已经关闭");
        self.quxiaoBtn.hidden = YES;
        self.buyBtn.hidden = YES;
    }

    self.zhuangtaiLabel.text = [dicJson objectForKey:@"status_display"];
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];
    
    tid = [dicJson objectForKey:@"id"];
    
    
    NSMutableString *string = [NSMutableString stringWithString:[dicJson objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
    [string deleteCharactersInRange:range];
    [string insertString:@"  " atIndex:range.location];
    self.finishedLabel.text = string;
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
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%.1f", [[dicJson objectForKey:@"total_fee"] floatValue]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"post_fee"]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥-%@", [dicJson objectForKey:@"discount_fee"]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"￥%.1f", [[dicJson objectForKey:@"payment"] floatValue]];
    
    
    
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
        [dataArray addObject:model];
        
        [refund_status_displayArray addObject:[dic objectForKey:@"refund_status_display"]];
        [refund_statusArray addObject:[dic objectForKey:@"refund_status"]];
        
        
        
        NSString *oid = [dic objectForKey:@"id"];
        [mutableArray addObject:oid];
    }
       NSLog(@"dataArray = %@", dataArray);
    NSLog(@"refund_status_display = %@", refund_status_displayArray);
    NSLog(@"refund_status = %@", refund_statusArray);
    
    oidArray = [[NSArray alloc] initWithArray:mutableArray];
    NSLog(@"oids = %@", oidArray);
    NSLog(@"tid = %@", tid);
    [self createXiangQing];
    
    
    
 
    NSLog(@"finished!");
    
}

- (void)createXiangQing{
    NSUInteger number = dataArray.count;
    self.myViewHeight.constant = number * 120;
    XiangQingView *owner = [XiangQingView new];
    PerDingdanModel *model = nil;
    for (int i = 0; i<number ; i++) {
        
        
        [[NSBundle mainBundle] loadNibNamed:@"XiangQingView" owner:owner options:nil];
        owner.myView.frame = CGRectMake(0, 0 + 120 * i, SCREENWIDTH, 120);
        
        model = [dataArray objectAtIndex:i];
        [owner.frontView sd_setImageWithURL:[NSURL URLWithString:model.urlString]];
        owner.nameLabel.text = model.nameString;
        owner.sizeLabel.text = model.sizeString;
        owner.numberLabel.text = [NSString stringWithFormat:@"%@", model.numberString];
        owner.priceLabel.text =[NSString stringWithFormat:@"¥%.1f", [model.priceString floatValue]];
        
        if ([status isEqualToString:@"已发货"]||[status isEqualToString:@"已付款"]) {
            
            self.quxiaoBtn.hidden = YES;
            self.buyBtn.hidden = YES;
        }
        if ([[refund_statusArray objectAtIndex:i] integerValue] == 0 && ![status isEqualToString:@"待付款"] && ![status isEqualToString:@"交易关闭"] && ![status isEqualToString:@"交易成功"]) {
            
        
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(240, 75, 60, 32)];
            [button addTarget:self action:@selector(tuihuo:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"我要退" forState:UIControlStateNormal];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderWidth:1];
            button.tag = 200+i;
            button.layer.cornerRadius = 6;
            [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
            [owner.myView addSubview:button];
        
        } else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(220, 75, 130, 32)];
            NSString *string = [refund_status_displayArray objectAtIndex:i];
            if ([string isEqualToString:@"没有退款"]) {
                string = @"";
            }
            label.text = string;
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

- (void)tuihuo:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    //进入退货界面；
    NSInteger i = button.tag - 200;
    tuihuoModel = [dataArray objectAtIndex:i];
    
    TuihuoController *tuiHuoVC = [[TuihuoController alloc] initWithNibName:@"TuihuoController" bundle:nil];
    
    tuiHuoVC.dingdanModel = tuihuoModel;
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.urlString);
//    @property (nonatomic, copy)NSString *nameString;
//    @property (nonatomic, copy)NSString *sizeString;
//    @property (nonatomic, copy)NSString *numberString;
//    @property (nonatomic, copy)NSString *priceString;
//    @property (nonatomic, copy)NSString *urlString;
    
    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.priceString);

    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.numberString);

    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.sizeString);

    NSLog(@"tuihuomodel = %@", tuiHuoVC.dingdanModel.nameString);
    tuiHuoVC.tid = tid;
    tuiHuoVC.oid = [oidArray objectAtIndex:i];
    tuiHuoVC.status = self.zhuangtaiLabel.text;
    
    NSLog(@"tid = %@, \noid = %@", tuiHuoVC.tid, tuiHuoVC.oid);
    
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

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"订单详情";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 12, 12, 22);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}



- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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

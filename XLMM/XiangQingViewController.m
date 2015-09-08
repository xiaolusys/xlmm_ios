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

@interface XiangQingViewController ()<NSURLConnectionDataDelegate>




@end

@implementation XiangQingViewController{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView;
    UIView *frontView;
    NSString *status;
    PerDingdanModel *tuihuoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInfo];
    
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
    
    [self downloadData];
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
    if ([statusname isEqualToString:@"交易关闭"]) {
        NSLog(@"交易订单已经关闭");
        self.quxiaoBtn.hidden = YES;
        self.buyBtn.hidden = YES;
    }

    self.zhuangtaiLabel.text = [dicJson objectForKey:@"status_display"];
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];
    
    
    
    NSMutableString *string = [NSMutableString stringWithString:[dicJson objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
    [string deleteCharactersInRange:range];
    [string insertString:@"  " atIndex:range.location];
    self.finishedLabel.text = string;
    self.lastStatusLabel.text = [dicJson objectForKey:@"status_display"];
    self.yuanqiuView.layer.cornerRadius = 6;
    self.timeLabel.text = string;
    self.jineLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"payment"]];
    
    self.nameLabel.text = [dicJson objectForKey:@"receiver_name"];
    self.phoneLabel.text = [dicJson objectForKey:@"receiver_mobile"];
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",
                           [dicJson objectForKey:@"receiver_state"],
                           [dicJson objectForKey:@"receiver_city"],
                           [dicJson objectForKey:@"receiver_district"],
                            [dicJson objectForKey:@"receiver_address"]];
    self.addressLabel.text = addressStr;
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"total_fee"]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"post_fee"]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥-%@", [dicJson objectForKey:@"discount_fee"]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"payment"]];
    
    
    
    NSArray *orderArray = [dicJson objectForKey:@"orders"];
    for (NSDictionary *dic in orderArray) {
        PerDingdanModel *model = [PerDingdanModel new];
        model.urlString = [dic objectForKey:@"pic_path"];
        model.sizeString = [dic objectForKey:@"sku_name"];
        model.numberString = [dic objectForKey:@"num"];
        model.priceString = [dic objectForKey:@"total_fee"];
        model.nameString = [dic objectForKey:@"title"];
        [dataArray addObject:model];
        
    }
       NSLog(@"dataArray = %@", dataArray);
    
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
        owner.priceLabel.text =[NSString stringWithFormat:@"¥%@", model.priceString];
        
        if ([status isEqualToString:@"已发货"]||[status isEqualToString:@"已付款"]) {
            
            self.quxiaoBtn.hidden = YES;
            self.buyBtn.hidden = YES;
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
        
        }
        
        
        
        [self.myXiangQingView addSubview:owner.myView];
        
    }
    
    [frontView removeFromSuperview];
    

}

#pragma mark -- 退货--

- (void)tuihuo:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    //进入退货界面；
    tuihuoModel = [dataArray objectAtIndex:(button.tag-200)];
    
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"111 : %@", response);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"222 : %@", dic);
    
    NSLog(@"string = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"3333 : %@", connection);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
    
}
@end

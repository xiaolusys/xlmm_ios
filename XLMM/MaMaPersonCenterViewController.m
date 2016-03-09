
//  MaMaPersonCenterViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaPersonCenterViewController.h"
#import "FSLineChart.h"
#import "MMClass.h"
#import "UIColor+FSPalette.h"
#import "MaMaOrderTableViewCell.h"
#import "MaMaOrderModel.h"
#import "PublishNewPdtViewController.h"
#import "AFNetworking.h"
#import "TixianViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaMaCarryLogViewController.h"
#import "TuijianErweimaViewController.h"
#import "MamaActivityViewController.h"
#import "ActivityViewController2.h"
#import "MaMaShareSubsidiesViewController.h"
#import "ProductSelectionListViewController.h"
#import "MaMaShopViewController.h"
#import "FensiListViewController.h"
#import "MaMaShareSubsidiesViewController.h"
#import "UIViewController+NavigationBar.h"
#import "SVProgressHUD.h"

#import "MaMaHuoyueduViewController.h"




@interface MaMaPersonCenterViewController ()<UITableViewDataSource, UITabBarDelegate, UITableViewDelegate, UIScrollViewDelegate>{
    NSMutableArray *dataArray;
    CGFloat widthOfChart;
    float ticheng;
    NSInteger dingdanshu;
//    UIView *circleView;
//    UIView *lineView;
    
    NSString *nickName;
    float ableTixianJine;
    
    NSMutableArray *allDingdan;
    
    CGPoint scrollViewContentOffset;
    
    NSString *share_mmcode;
    
//    NSNumber *_money;
//    NSNumber *_clickTotalMoney;
    
}

@property (nonatomic, strong)FSLineChart *lineChart;

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)NSString *earningsRecord;
@property (nonatomic, strong)NSString *orderRecord;

//分享点击补贴
@property (weak, nonatomic) IBOutlet UILabel *clickNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickMoney;

@property (weak, nonatomic) IBOutlet UILabel *updateClickMoenyLabel;

@property (nonatomic, strong)NSNumber *money;
@property (nonatomic, strong)NSNumber *clickTotalMoney;

@property (copy, nonatomic) NSString *mamalink;
@property (nonatomic, strong) UIImageView *mamaHuoyueduImageView;

@end

@implementation MaMaPersonCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc] initWithCapacity:30];
    self.dataArr = [[NSMutableArray alloc] init];
    allDingdan = [[NSMutableArray alloc] init];
    widthOfChart = 50;
    self.headViewWidth.constant = SCREENWIDTH;
    [self.mamaTableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    
    self.mamaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootScrollView];
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm", Root_URL];
    
    //点击分享补贴
    UITapGestureRecognizer *tapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShareView)];
    [self.shareSubsidies addGestureRecognizer:tapShare];
    
    [self downloadData];
    [self downloadDataWithUrlString:string selector:@selector(fetchedMaMaData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/agency_info", Root_URL] selector:@selector(fetchedInfoData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/pmt/shopping", Root_URL] selector:@selector(fetchedDingdanjilu:)];
    
//    //主页新的数据
//    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self updateMaMaHome:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    [self prepareData];
    [self createChart:dataArray];
    
    
    [self prepareTableData];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headimageClicked:)];
    [self.jineLabel addGestureRecognizer:tap];
    self.jineLabel.userInteractionEnabled = YES;
    
    [self createHuoYueDuView];
    
//    self.fensilabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fensiList:)];
//  //  [self.fensiLabel addGestureRecognizer:tap1];
//    [self.fensilabel addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huoyueduDetails)];
    
    [self.mamaHuoyueduView addGestureRecognizer:tap1];
    
}

- (void)huoyueduDetails{
    NSLog(@"huoyuedu");
    
    MaMaHuoyueduViewController *VC = [[MaMaHuoyueduViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)createHuoYueDuView{
  self.huoyueduView.transform = CGAffineTransformMakeRotation(M_PI * 24/180);
    
    
    NSInteger huoyuezhi = arc4random()%(NSInteger)(SCREENWIDTH);
    huoyuezhi = SCREENWIDTH * 0.25;
    CGFloat percent = (CGFloat)huoyuezhi/SCREENWIDTH*100;
    self.huoyuedulabel.text = [NSString stringWithFormat:@"%%%.0f",100 - percent];
    self.huoyueduLeft.constant = 0 - huoyuezhi;
    self.huoyueduRight.constant = huoyuezhi ;
    
    
    
}

//- (void)updateMaMaHome:(NSDictionary *)dataDic {
////    NSLog(@"%@", dataDic);
//    NSDictionary *mamaDic = [dataDic objectForKey:@"mama_fortune"];
//    self.inviteLabel.text = [mamaDic objectForKey:@"invite_num"];
////    self.
//    
//}


//- (void)fensiList:(UITapGestureRecognizer *)recognizer{
//    NSLog(@"fensi");
//    FensiListViewController *fensiVC = [[FensiListViewController alloc] init];
//    [self.navigationController pushViewController:fensiVC animated:YES];
//}

#pragma mark -获取订单记录

- (void)fetchedDingdanjilu:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSString *count = [dic objectForKey:@"count"];
        self.dingdanyilu.text = [NSString stringWithFormat:@"%ld", (long)[count integerValue]];
        self.orderRecord = [NSString stringWithFormat:@"%ld", (long)[count integerValue]];
        self.order.text = [NSString stringWithFormat:@"%@个订单", self.orderRecord];
    }
    
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/fanlist", Root_URL];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
    
}

- (void)fetchedData:(NSData *)data{
    if (data == nil) {
        return;
    }
//    NSError *error = nil;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    if (error == nil) {
//        self.fensilabel.text = [NSString stringWithFormat:@"%ld", array.count];
//
//        if (array.count == 0) {
//            NSLog(@"您的粉丝列表为空");
//        } else {
//                       //生成粉丝列表。。。
//           // [self createFanlistWithArray:array];
//        }
//    } else {
//        NSLog(@"error = %@", error);
//    }
    
}

// 返回一周的订单数。。。。
- (NSInteger)sumofoneWeek:(NSArray *)weekArray{
    NSInteger sum = 0;
    for (int i = 0; i < weekArray.count; i++) {
        sum += [weekArray[i] integerValue];
    }
    return sum;
    
}

#pragma mark --进入提现界面

- (void)headimageClicked:(UITapGestureRecognizer *)tap{
    TixianViewController *vc = [[TixianViewController alloc] initWithNibName:@"TixianViewController" bundle:nil];
    vc.cantixianjine = ableTixianJine;
    vc.name = nickName;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --获取历史积累收益

- (void)fetchedInfoData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSString *mco = [[dicJson objectForKey:@"mmclog"] objectForKey:@"mci"];
        share_mmcode = [dicJson objectForKey:@"share_mmcode"];
        self.mamalink = [dicJson objectForKey:@"mama_link"];
        
        //获取点击补贴
        self.money = dicJson[@"clk_money"];
        NSDictionary *mmclog = dicJson[@"mmclog"];
        self.clickTotalMoney = mmclog[@"clki"];
        NSLog(@"%@",[dicJson objectForKey:@"fans_num"]);
        
        self.fensilabel.text = [NSString stringWithFormat:@"粉丝数%@", [dicJson objectForKey:@"fans_num"]];
        
        self.account.text = [NSString stringWithFormat:@"账户余额%.2f",[mco floatValue]];
        self.earningsRecord = [NSString stringWithFormat:@"%.2f",[mco floatValue]];
    }
}


#pragma mark --获取小鹿妈妈信息：等级，账户余额， 可提现金额， 名称等。。。

- (void)fetchedMaMaData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *arrJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
    //    NSLog(@"dicJson = %@", arrJson);
        if (arrJson.count == 0) {
            return;
        }
        NSDictionary *dic = [arrJson objectAtIndex:0];
        self.levelLabel.text = [NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]];
      //  NSLog(@"%@",[NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]]);
        self.jineLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"get_cash_display"] floatValue]];
        ableTixianJine = [[dic objectForKey:@"coulde_cashout"] floatValue];
        nickName = [dic objectForKey:@"weikefu"];
    }
    
}

#pragma mark --ScrollViewDelegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  NSLog(@"%f", scrollView.contentOffset.x/SCREENWIDTH);
    NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
    
    
    scrollViewContentOffset = scrollView.contentOffset;
    NSInteger count = allDingdan.count;
   // NSLog(@"count = %ld", count);
    
    NSInteger days = (count - page - 1)*7;
  //  NSLog(@"days = %ld", days);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/shopping/shops_by_day?days=%ld", Root_URL, (long)days];
  //  NSLog(@"urlstring = %@", urlString);
    
    //改变竖线的位置。。。。
    [self createChart:allDingdan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
    
        [self maMaOrderInfoData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}




- (void)downloadDataWithUrlString:(NSString *)urlString selector:(SEL)aSelector{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
        
    });
}

#pragma mark --获取今日订单数据。。。。
- (void)prepareTableData{
    NSString *orderUrl = [NSString stringWithFormat:@"%@/rest/v1/pmt/shopping/shops_by_day", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:orderUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        [self maMaOrderInfoData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

//更新订单数据。
- (void)maMaOrderInfoData:(NSDictionary *)dic {
    
    [self.dataArr removeAllObjects];
    
    //点击补贴
    NSNumber *clicks = dic[@"clk_money"];
    
//    _money = dic[@"clk_money"];
//    NSDictionary *mmclog = dic[@"mmclog"];
//    _clickTotalMoney = mmclog[@"clki"];
    
    
    self.updateClickMoenyLabel.text = [NSString stringWithFormat:@"今日补贴%0.1f", [clicks floatValue]];

//    if ([clicks intValue] > 0) {
//        self.shareSubsidies.hidden = NO;
//        self.clickedViewHeight.constant = 45;
//        self.clickNumLabel.text = [NSString stringWithFormat:@"%@用户通过点击你的分享", dic[@"clicks"]];
//        
//        self.updateClickMoenyLabel.text = [NSString stringWithFormat:@"今日补贴--%@", dic[@"click_money"]];
////        self.clickMoney.text = [NSString stringWithFormat:@"+%@",  dic[@"click_money"]];
//    }else {
//        self.shareSubsidies.hidden = YES;
//        self.clickedViewHeight.constant = 0;
//    }
    
    NSArray *array = dic[@"shops"];
    if (array.count == 0){
//        self.dingdanLabel.text = @"订单 0      收入 0.00";
        self.dingdanLabel.text = @"0";
        self.shouyiLabel.text = @"0.00";
        [self.mamaTableView reloadData];
        return;

    }
        
    ticheng = 0.0;
    dingdanshu = array.count;
    
    for (NSDictionary *orderDic in array) {
        MaMaOrderModel *orderM = [[MaMaOrderModel alloc] init];
        [orderM setValuesForKeysWithDictionary:orderDic];
        ticheng += [orderM.ticheng_cash floatValue];
        [self.dataArr addObject:orderM];
    }
//    self.dingdanLabel.text = [NSString stringWithFormat:@"订单 %ld    收入 %.2f", (long)dingdanshu, ticheng];
    self.dingdanLabel.text = [NSString stringWithFormat:@"%ld", (long)dingdanshu];
    self.shouyiLabel.text = [NSString stringWithFormat:@"%.2f", ticheng];
    
    //[self.mamaTableView reloadData];
}


 //根据订单数据 画表格。。。。
- (void)createChart:(NSMutableArray *)chartData {
    
    NSInteger count = [chartData count];
    self.mamaScrollView.contentSize = CGSizeMake(SCREENWIDTH * count, 120);
    self.mamaScrollView.bounces = NO;
    self.mamaScrollView.showsHorizontalScrollIndicator = NO;
    self.mamaScrollView.delegate = self;
    self.mamaScrollView.contentOffset = scrollViewContentOffset;
    self.mamaScrollView.pagingEnabled = YES;
    
    NSArray *array = self.mamaScrollView.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    
    
    for (int i = 0; i < allDingdan.count; i++) {
        UIView *shartView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * (count - i - 1) + 20, 0, SCREENWIDTH - 40, 120)];
        
        shartView.tag = 1001 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [shartView addGestureRecognizer:tap];
        
        NSMutableArray *mutabledingdan = [allDingdan[i] mutableCopy];
        
        for (int k = 0; k < mutabledingdan.count/2; k++) {
            [mutabledingdan exchangeObjectAtIndex:k withObjectAtIndex:mutabledingdan.count- k - 1];
        }
        
       // NSLog(@"每周订单数%@", mutabledingdan);
        
        FSLineChart *linechart = [self chart2:mutabledingdan];
        [shartView addSubview:linechart];
        
        UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        circleView.backgroundColor = [UIColor orangeThemeColor];
        circleView.layer.cornerRadius = 3;
        circleView.tag = 300;
        [shartView addSubview:circleView];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
        lineView.backgroundColor = [UIColor orangeThemeColor];
        lineView.tag = 400;
        [shartView addSubview:lineView];
        
        
        CGPoint point = [linechart getPointForIndex:6];
        circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
        lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
        
        [self.mamaScrollView addSubview:shartView];
        
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREENWIDTH *allDingdan.count, 0.5)];
    bottomLine.backgroundColor = [UIColor lineGrayColor];
    [self.mamaScrollView addSubview:bottomLine];

}

// 点击表格 更新数据
- (void)tapClicked:(UITapGestureRecognizer *)recognizer{

    
    UIView *weekView = [recognizer view];
    NSInteger week = weekView.tag - 1000;
    
   // NSLog(@"第 %ld 周订单数据", week);
    
   // NSLog(@"weekView subView = %@", [weekView subviews]);
    

    CGPoint location = [recognizer locationInView:recognizer.view];
  //  NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
   // NSLog(@"width = %f", width);
    CGFloat unitwidth = (SCREENWIDTH - 50)/6;
  //  NSLog(@"unit = %.0f", unitwidth);
    int index = (int)((width + unitwidth/2 - 5 ) /unitwidth);
    
  //  NSLog(@"index = %d", index);

    

    FSLineChart *linechart = [weekView subviews][0];
    UIView *circleView = [weekView viewWithTag:300];
    UIView *lineView = [weekView viewWithTag:400];
    

    
    CGPoint point = [linechart getPointForIndex:index];
   // NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    
    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
    
    NSInteger days = (6 - index) + (week - 1)*7;
    
    //NSLog(@"days = %ld", days);

//    _clickDate = days;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/shopping/shops_by_day?days=%ld", Root_URL, (long)days];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        [self maMaOrderInfoData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


//制作表格。。。
-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 120)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 6;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 1;
    self.lineChart.drawInnerGrid = NO;
    
    
    [self.lineChart setChartData:chartData];
  
    [self.lineChart showLineViewAfterDelay:self.lineChart.animationDuration];
   
    return self.lineChart;
}

//  获取表格数据
- (void)prepareData{
    
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v1/pmt/shopping/days_num?days=91", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chartUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        NSMutableArray *data = [responseObject mutableCopy];
     //   NSLog(@"%@", responseObject);
        NSMutableArray *weekArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < data.count; i++) {
            [weekArray addObject:data[i]];
            
            if ((i +1)%7 == 0) {
                NSInteger sum = [self sumofoneWeek:weekArray];
          //   NSLog(@"第%d周订单的和为：%ld",(int)i/7, sum);
                if (sum == 0) {
                    break;
                }
                [allDingdan addObject:[weekArray copy]];
                [weekArray removeAllObjects];
            }
        }
     // NSLog(@"%@", allDingdan);
        if (allDingdan.count > 0) {
            self.mamaimage.hidden = YES;
            self.mamalabel.hidden = YES;
        }
        scrollViewContentOffset = CGPointMake(SCREENWIDTH*allDingdan.count - SCREENWIDTH, 0);
       [self createChart:allDingdan];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark --TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableViewHeight.constant = self.dataArr.count *80;
    
   return (self.dataArr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MaMaOrderTableViewCell *cell = (MaMaOrderTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:@"MaMaOrder" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[MaMaOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaMaOrder"];
        }
        MaMaOrderModel *orderM = self.dataArr[indexPath.row];
        [cell fillDataOfCell:orderM];
        
        return cell;
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

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendProduct:(id)sender {
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}

- (IBAction)MamaOrderClicked:(id)sender {
    MaMaOrderListViewController *orderList = [[MaMaOrderListViewController alloc] init];
    orderList.orderRecord = self.orderRecord;
    [self.navigationController pushViewController:orderList animated:YES];
}

- (IBAction)MamaCarryLogClicked:(id)sender {
    MaMaCarryLogViewController *carry = [[MaMaCarryLogViewController alloc] init];
    
    carry.earningsRecord = self.earningsRecord;
    [self.navigationController pushViewController:carry animated:YES];
}

- (IBAction)erweima:(id)sender {
    
    NSLog(@"推荐二维码");
    
    TuijianErweimaViewController *erweima = [[TuijianErweimaViewController alloc] init];
    
    erweima.imagelink = share_mmcode;
    erweima.mamalink = self.mamalink;
    [self.navigationController pushViewController:erweima animated:YES];
    
    
}

- (IBAction)jingxuanliebiao:(id)sender {
    MaMaShopViewController *shop = [[MaMaShopViewController alloc] init];
    [self.navigationController pushViewController:shop animated:YES];
}

- (IBAction)xuanpinliebiao:(id)sender {
    ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
    [self.navigationController pushViewController:product animated:YES];
}

- (IBAction)shareSubsidiesAction:(id)sender {
    MaMaShareSubsidiesViewController *share = [[MaMaShareSubsidiesViewController alloc] init];
    share.clickTotalMoeny = self.clickTotalMoney;
    share.todayMoney = self.money;
    
    [self.navigationController pushViewController:share animated:YES];
}


- (IBAction)huodongzhongxin:(id)sender {
    MamaActivityViewController *activityVC = [[MamaActivityViewController alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (IBAction)fansList:(id)sender {
    FensiListViewController *fensiVC = [[FensiListViewController alloc] init];
    [self.navigationController pushViewController:fensiVC animated:YES];
}

- (IBAction)boutiqueActivities:(id)sender {
    //精品活动
    [SVProgressHUD showInfoWithStatus:@"程序猿正在努力开发..."];
}

- (void)clickShareView {
//    MaMaShareSubsidiesViewController *share = [[MaMaShareSubsidiesViewController alloc] init];
//    share.clickDate = _clickDate;
//    share.todayMoney = _money;
//    [self.navigationController pushViewController:share animated:YES];
}

@end

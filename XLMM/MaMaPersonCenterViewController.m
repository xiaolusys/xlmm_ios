//
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
    
    
}

@property (nonatomic, strong)FSLineChart *lineChart;

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation MaMaPersonCenterViewController



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
    self.fabuButton.layer.borderWidth = 1;
    self.fabuButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    self.fabuButton.layer.cornerRadius = 20;
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/xlmm", Root_URL];

    
    
    
    [self downloadDataWithUrlString:string selector:@selector(fetchedMaMaData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/xlmm/agency_info", Root_URL] selector:@selector(fetchedInfoData:)];
    
    [self prepareData];
    [self createChart:dataArray];
    
    
    [self prepareTableData];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headimageClicked:)];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled = YES;
    
    

    
}

// 返回一周的订单数。。。。
- (NSInteger)sumofoneWeek:(NSArray *)weekArray{
    NSInteger sum = 0;
    for (int i = 0; i < weekArray.count; i++) {
        sum += [weekArray[i] integerValue];
    }
    return sum;
    
}

- (void)headimageClicked:(UITapGestureRecognizer *)tap{
    NSLog(@"0");
    NSLog(@"提现");
    TixianViewController *vc = [[TixianViewController alloc] initWithNibName:@"TixianViewController" bundle:nil];
    vc.cantixianjine = ableTixianJine;
    vc.name = nickName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetchedInfoData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSLog(@"json = %@", dicJson);
    }
}

- (void)fetchedMaMaData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *arrJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSLog(@"dicJson = %@", arrJson);
        if (arrJson.count == 0) {
            return;
        }
        NSDictionary *dic = [arrJson objectAtIndex:0];
        self.levelLabel.text = [NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]];
        NSLog(@"%@",[NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]]);
        self.jineLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"get_cash_display"] floatValue]];
        ableTixianJine = [[dic objectForKey:@"coulde_cashout"] floatValue];
        nickName = [dic objectForKey:@"weikefu"];
    }
    
}

#pragma mark --ScrollViewDelegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%f", scrollView.contentOffset.x/SCREENWIDTH);
    NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
    
    
    scrollViewContentOffset = scrollView.contentOffset;
    NSInteger count = allDingdan.count;
    NSLog(@"count = %ld", count);
    
    NSInteger days = (count - page - 1)*7;
    NSLog(@"days = %ld", days);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day?days=%ld", Root_URL, days];
    NSLog(@"urlstring = %@", urlString);
    
    //改变竖线的位置。。。。
    [self createChart:allDingdan];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSArray *data = responseObject;
        [self maMaOrderInfoData:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}




- (void)downloadDataWithUrlString:(NSString *)urlString selector:(SEL)aSelector{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
        
    });
}
- (void)prepareTableData{
    NSString *orderUrl = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:orderUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSArray *data = responseObject;
        [self maMaOrderInfoData:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}
- (void)maMaOrderInfoData:(NSArray *)array {
    
    [self.dataArr removeAllObjects];
    ticheng = 0.0;
    dingdanshu = array.count;
    NSLog(@"array = %@", array);
    for (NSDictionary *orderDic in array) {
        MaMaOrderModel *orderM = [[MaMaOrderModel alloc] init];
        [orderM setValuesForKeysWithDictionary:orderDic];
        ticheng += [orderM.ticheng_cash floatValue];
        [self.dataArr addObject:orderM];
    }
    NSLog(@"今日订单%ld 今日收入%.2f", dingdanshu, ticheng);
    self.dingdanLabel.text = [NSString stringWithFormat:@"今日订单 %ld    今日收入 %.2f", dingdanshu, ticheng];
    
    [self.mamaTableView reloadData];
}
- (void)createChart:(NSMutableArray *)chartData {
    
    NSInteger count = [chartData count];
    self.mamaScrollView.contentSize = CGSizeMake(SCREENWIDTH * count, 120);
    self.mamaScrollView.bounces = NO;
    self.mamaScrollView.showsHorizontalScrollIndicator = NO;
    self.mamaScrollView.delegate = self;
    self.mamaScrollView.contentOffset = scrollViewContentOffset;
    self.mamaScrollView.pagingEnabled = YES;
    
    
    
    
    for (int i = 0; i < allDingdan.count; i++) {
        UIView *shartView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * (count - i - 1) + 20, 0, SCREENWIDTH - 40, 120)];
        
        shartView.tag = 1001 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [shartView addGestureRecognizer:tap];
        
        NSMutableArray *mutabledingdan = [allDingdan[i] mutableCopy];
        
        for (int k = 0; k < mutabledingdan.count/2; k++) {
            [mutabledingdan exchangeObjectAtIndex:k withObjectAtIndex:mutabledingdan.count- k - 1];
        }
        
        NSLog(@"每周订单数%@", mutabledingdan);
        
        FSLineChart *linechart = [self chart2:mutabledingdan];
        [shartView addSubview:linechart];
        
        UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        circleView.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
        circleView.layer.cornerRadius = 3;
        circleView.tag = 300;
        [shartView addSubview:circleView];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
        lineView.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
        lineView.tag = 400;
        [shartView addSubview:lineView];
        
        
        CGPoint point = [linechart getPointForIndex:6];
        circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
        lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
        
        [self.mamaScrollView addSubview:shartView];
        
    }
    
    

   
    
    
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREENWIDTH *allDingdan.count, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithR:218 G:218 B:218 alpha:1];
    [self.mamaScrollView addSubview:bottomLine];
    
    
    CGPoint point = [self.lineChart getPointForIndex:chartData.count - 1];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    
   
}







- (void)updateSelectedViewWithPoint:(CGPoint)point{
//    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
//    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115 - point.y);
}
//CGPoint p = [self getPointForIndex:i withScale:scale];
//UIView *view = [[UIView alloc] initWithFrame:CGRectMake(p.x, p.y, 0.5, 115 - p.y)];
//view.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
//[self addSubview:view];

- (void)tapClicked:(UITapGestureRecognizer *)recognizer{

    
    UIView *weekView = [recognizer view];
    NSInteger week = weekView.tag - 1000;
    
    NSLog(@"第 %ld 周订单数据", week);
    
    NSLog(@"weekView subView = %@", [weekView subviews]);
    

    CGPoint location = [recognizer locationInView:recognizer.view];
    NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
    NSLog(@"width = %f", width);
    int index = (int)((width + 25) / ((SCREENWIDTH - 10)/6));
    
    NSLog(@"index = %d", index);

    

    FSLineChart *linechart = [weekView subviews][0];
    UIView *circleView = [weekView viewWithTag:300];
    UIView *lineView = [weekView viewWithTag:400];
    

    
    CGPoint point = [linechart getPointForIndex:index];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    
    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
    
    NSInteger days = (6 - index) + (week - 1)*7;
    
    NSLog(@"days = %ld", days);

    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day?days=%ld", Root_URL, days];
    NSLog(@"urlstring = %@", urlString);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSArray *data = responseObject;
        [self maMaOrderInfoData:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 120)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 6;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    
  
    
    //    lineChart.labelForIndex = ^(NSUInteger item) {
    //         return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    //    };
    //
    //    lineChart.labelForValue = ^(CGFloat value) {
    //        return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%.f €", value];
    //    };
    
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 0.01;
    self.lineChart.drawInnerGrid = NO;
    
    
    [self.lineChart setChartData:chartData];
    
    
   
    return self.lineChart;
}


- (void)prepareData{
    
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v1/shopping/days_num?days=91", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chartUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        NSMutableArray *data = [responseObject mutableCopy];
        NSLog(@"%@", responseObject);
        NSMutableArray *weekArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < data.count; i++) {
            [weekArray addObject:data[i]];
            
            if ((i +1)%7 == 0) {
                NSInteger sum = [self sumofoneWeek:weekArray];
                NSLog(@"第%d周订单的和为：%ld",(int)i/7, sum);
                if (sum == 0) {
                    break;
                }
                [allDingdan addObject:[weekArray copy]];
                [weekArray removeAllObjects];
            }
        }
        NSLog(@"%@", allDingdan);
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
    NSLog(@"发布产品");
    
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}


@end

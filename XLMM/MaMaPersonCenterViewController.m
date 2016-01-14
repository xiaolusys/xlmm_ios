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



@interface MaMaPersonCenterViewController ()<UITableViewDataSource, UITabBarDelegate>{
    NSMutableArray *dataArray;
    CGFloat widthOfChart;
    float ticheng;
    NSInteger dingdanshu;
    UIView *circleView;
    UIView *lineView;
    
    NSString *nickName;
    float ableTixianJine;
    
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
    self.mamaScrollView.contentSize = CGSizeMake(50 * 90 + 24, 120);
    self.mamaScrollView.bounces = NO;
    self.mamaScrollView.showsHorizontalScrollIndicator = NO;
    self.mamaScrollView.contentOffset = CGPointMake(50 * 90 - SCREENWIDTH + 24, 0);
    //self.mamaScrollView.pagingEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [self.mamaScrollView addGestureRecognizer:tap];
   
     [self.mamaScrollView addSubview:[self chart2:chartData]];
    
    

    circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    circleView.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    circleView.layer.cornerRadius = 3;
    [self.mamaScrollView addSubview:circleView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
    lineView.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    [self.mamaScrollView addSubview:lineView];
    
    
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 115, 4524, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithR:218 G:218 B:218 alpha:1];
    [self.mamaScrollView addSubview:bottomLine];
    
    
    CGPoint point = [self.lineChart getPointForIndex:chartData.count - 1];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    [self updateSelectedViewWithPoint:point];
    
   
}
- (void)updateSelectedViewWithPoint:(CGPoint)point{
    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115 - point.y);
}
//CGPoint p = [self getPointForIndex:i withScale:scale];
//UIView *view = [[UIView alloc] initWithFrame:CGRectMake(p.x, p.y, 0.5, 115 - p.y)];
//view.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
//[self addSubview:view];

- (void)tapClicked:(UITapGestureRecognizer *)recognizer{
 //   UIScrollView *scrollView = (UIScrollView*)recognizer.view;
   // NSLog(@"scrollView = %@", scrollView);

    CGPoint location = [recognizer locationInView:recognizer.view];
    //NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
    NSInteger index = (int)(width + 25) / 50;
    NSLog(@"index = %ld", index);
    NSInteger days = 90 - index;
    NSLog(@"%ld天前的数据",days);

    
    CGPoint point = [self.lineChart getPointForIndex:index];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    [self updateSelectedViewWithPoint:point];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day?days=%ld", Root_URL, days];
    NSLog(@"urlstring = %@", urlString);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSArray *data = responseObject;
        [self maMaOrderInfoData:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    //chart data
}



-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, 50 * 90 + 10, 120)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 90;
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
    self.lineChart.animationDuration = 1.0;
    self.lineChart.drawInnerGrid = NO;
    self.lineChart.animationDuration = 0.1;
    
    
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
        
        for (int i = 0; i < data.count/2; i++) {
            [data exchangeObjectAtIndex:i withObjectAtIndex:(data.count - i - 1)];
        }
        
        NSLog(@"%@", data);
       // self.dataArr = data;
        
        [self createChart:data];

        
        
        
        
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

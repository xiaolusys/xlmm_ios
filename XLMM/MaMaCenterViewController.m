//
//  MaMaCenterViewController.m
//  XLMM
//
//  Created by younishijie on 15/12/31.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MaMaCenterViewController.h"
#import "MaMaOrderTableViewCell.h"
#import "MaMaChartTableViewCell.h"
#import "MMClass.h"
#import "AFHTTPRequestOperationManager.h"
#import "MaMaOrderModel.h"
#import "PublishNewPdtViewController.h"
#import "TixianViewController.h"
#import "FSLineChart.h"



@interface MaMaCenterViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *chartPoint;

@end

@implementation MaMaCenterViewController
{
    UIButton *backButton;
    UILabel *jineLabel;
    UILabel *levelLabel;
    UILabel *jiluLabel;
    UILabel *shouyiLabel;
    float ticheng;
    NSInteger dingdanshu;
    UILabel *dingdanLabel;
    
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)chartPoint {
    if (!_chartPoint) {
        self.chartPoint = [NSMutableArray arrayWithCapacity:0];
    }
    return _chartPoint;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mamaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60) style:UITableViewStylePlain];
    self.mamaTableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    UIView *headView;
    
    NSLog(@"%f, %f",self.view.frame.size.width, self.view.frame.size.height );
    NSLog(@"%f, %f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MaMaHeadView" owner:nil options:nil];
    headView = views[0];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 245);
    self.mamaTableView.showsVerticalScrollIndicator = NO;
    backButton = [headView viewWithTag:100];
    levelLabel = [headView viewWithTag:200];
    jineLabel = [headView viewWithTag:300];
    jiluLabel = [headView viewWithTag:400];
    shouyiLabel = [headView viewWithTag:500];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tixianClicked:)];
    [jineLabel addGestureRecognizer:tap];
    jineLabel.userInteractionEnabled = YES;
    
    [backButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    levelLabel.text = @"12";
    jineLabel.text = @"300";
    jiluLabel.text = @"400";
    shouyiLabel.text = @"500";
    
    
    
    
    self.mamaTableView.tableHeaderView = headView;
    
    [self.mamaTableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    [self.mamaTableView registerClass:[MaMaChartTableViewCell class] forCellReuseIdentifier:@"MaMaChart"];
    
    self.mamaTableView.delegate = self;
    self.mamaTableView.dataSource = self;
    
   
    
    dingdanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, SCREENWIDTH, 40)];
    dingdanLabel.text = [NSString stringWithFormat:@"今日订单%ld 今日收入%.2f", dingdanshu,ticheng];
                         
    dingdanLabel.textColor = [UIColor colorWithRed: 98/256.0 green: 98/256.0 blue:98/256.0 alpha:1.0];
   dingdanLabel.font = [UIFont systemFontOfSize:14];
    dingdanLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.mamaTableView addSubview:dingdanLabel];
    dingdanLabel.textColor = [UIColor colorWithRed: 98/256.0 green: 98/256.0 blue:98/256.0 alpha:1.0];
    
    [self.view addSubview:self.mamaTableView];
    
    [self downloadData];  
    
}

- (void)tixianClicked:(id)sender{
    NSLog(@"提现");
    TixianViewController *vc = [[TixianViewController alloc] initWithNibName:@"TixianViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
  
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/xlmm", Root_URL];
    [self downloadDataWithUrlString:string selector:@selector(fetchedMaMaData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/xlmm/agency_info", Root_URL] selector:@selector(fetchedInfoData:)];
    
    //mama今日订单列表
    NSString *orderUrl = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:orderUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSArray *data = responseObject;
        [self maMaOrderInfoData:data];
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    //chart data
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v1/shopping/days_num?days=7", Root_URL];
    [manager GET:chartUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        
        NSMutableArray *data = [responseObject mutableCopy];
        NSLog(@"%@", responseObject);

        for (int i = 0; i < data.count/2; i++) {
            [data exchangeObjectAtIndex:i withObjectAtIndex:(data.count - i - 1)];
        }
        
        NSLog(@"%@", data);
        self.chartPoint = data;
       


        
        
        [self.mamaTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)fetchedInfoData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
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
        levelLabel.text = [NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]];
        jineLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"get_cash_display"] floatValue]];
    }
    
}

- (void)maMaOrderInfoData:(NSArray *)array {
    
    [self.dataArr removeAllObjects];
    ticheng = 0.0;
    dingdanshu = array.count;
    for (NSDictionary *orderDic in array) {
        MaMaOrderModel *orderM = [[MaMaOrderModel alloc] init];
        [orderM setValuesForKeysWithDictionary:orderDic];
        
        ticheng += [orderM.ticheng_cash floatValue];
        
        
        
        
        [self.dataArr addObject:orderM];
    }
    NSLog(@"今日订单%ld 今日收入%.2f", dingdanshu, ticheng);
    dingdanLabel.text = [NSString stringWithFormat:@"今日订单%ld 今日收入%.2f", dingdanshu, ticheng];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    
    [self.mamaTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
  //  [self.mamaTableView reloadData];
}

- (void)downloadDataWithUrlString:(NSString *)urlString selector:(SEL)aSelector{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
        
    });
}
- (void)backClicked:(UIButton *)button{
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

#pragma mark --TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return (self.dataArr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }else {
        return 80;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        MaMaChartTableViewCell *cell = (MaMaChartTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:@"MaMaChart" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[MaMaChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaMaChart"];
            
        }
        
       // cell.orderNum.text = [NSString stringWithFormat:@"今日订单%ld 今日收入%.2f", dingdanshu, ticheng];

        
        if (self.chartPoint.count > 0) {
            [cell createChart:self.chartPoint];
            for (int i = 0; i < 7; i++) {
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake((6 - i)*(SCREENWIDTH - 10)/6 - 20,44, 50, 80);
                btn.backgroundColor = [UIColor clearColor];
                btn.alpha = 0.2;
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                NSLog(@"%@", cell.subviews);
                    
            }
        }
       
        return cell;

    } else {
        MaMaOrderTableViewCell *cell = (MaMaOrderTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:@"MaMaOrder" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[MaMaOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaMaOrder"];
            
        }
        MaMaOrderModel *orderM = self.dataArr[indexPath.row];
        [cell fillDataOfCell:orderM];
      
        return cell;
    }
}

- (void)buttonClicked:(UIButton *)button{
    NSLog(@"button.tag = %d", (int) button.tag);
    
    
    int days = (int)button.tag - 100;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/shopping/shops_by_day?days=%d", Root_URL, days];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publishNewPmt:(id)sender {
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
//    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:publish];
//    [self presentViewController:navC animated:YES completion:nil];
    
}
@end

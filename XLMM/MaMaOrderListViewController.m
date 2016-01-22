//
//  MaMaOrderListViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaOrderListViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "MaMaOrderModel.h"
#import "MaMaOrderTableViewCell.h"
#import "CarryLogHeaderView.h"


@interface MaMaOrderListViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

@property (nonatomic, strong)NSString *nextPage;
@end

@implementation MaMaOrderListViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"订单列表" selecotr:@selector(backClickAction)];
    
    [self createTableView];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/shopping", Root_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark ---数据处理
- (void)dataAnalysis:(NSDictionary *)data {
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    for (NSDictionary *order in results) {
        MaMaOrderModel *orderM = [[MaMaOrderModel alloc] init];
        [orderM setValuesForKeysWithDictionary:order];
        NSString *date = [self dateDeal:orderM.shoptime];
        self.dataArr = [[self.dataDic allKeys] mutableCopy];
        //判断对应键值的数组是否存在
        if ([self.dataArr containsObject:date]) {
            NSMutableArray *orderArr = self.dataDic[date];
            [orderArr addObject:orderM];
        }else {
            NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
            [orderArr addObject:orderM];
            [self.dataDic setObject:orderArr forKey:date];
        }
    }
    self.dataArr = [[self.dataDic allKeys] mutableCopy];
    self.dataArr = [self sortAllKeyArray:self.dataArr];
    [self.tableView reloadData];
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSArray *strarray = [str componentsSeparatedByString:@"T"];
    NSString *date = strarray[0];
    return date;
}

//将所有的key排序
- (NSMutableArray *)sortAllKeyArray:(NSMutableArray *)keyArr {
    for (int i = 0; i < keyArr.count; i++) {
        for (int j = 0; j < keyArr.count - i - 1; j++) {
            if ([keyArr[j] intValue] < [keyArr[j + 1] intValue]) {
                NSNumber *temp = keyArr[j + 1];
                keyArr[j + 1] = keyArr[j];
                keyArr[j] = temp;
            }
        }
    }
    return keyArr;
}


#pragma mark ---UItableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.dataArr[section];
    NSMutableArray *orderArr = self.dataDic[key];
    return orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *orderArr = self.dataDic[key];
    MaMaOrderModel *orderM = orderArr[indexPath.row];
    MaMaOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaMaOrder"];
    if (!cell) {
        cell = [[MaMaOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MaMaOrder"];
    }
    cell.orderStatic.text = orderM.get_status_display;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
    CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30); 
    //计算金额
    NSString *key = self.dataArr[section];
    NSMutableArray *orderArr = self.dataDic[key];
    int total = 0;
    NSString *date;
    for (MaMaOrderModel *model in orderArr) {
        total = [model.rebeta_cash intValue] + total;
        date = [self dateDeal:model.shoptime];
    }
    
    [headerV yearLabelAndTotalMoneyLabelText:date total:[NSString stringWithFormat:@"%d", total]];
    return headerV;
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

@end

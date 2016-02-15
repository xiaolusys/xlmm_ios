//
//  MaMaShareSubsidiesViewController.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaShareSubsidiesViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MaMaShareSubsidiesViewCell.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "ShareClickModel.h"
#import "CarryLogModel.h"
#import "CarryLogHeaderView.h"

@interface MaMaShareSubsidiesViewController ()
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UILabel *moneyText;

@property (nonatomic, strong)NSString *nextPage;
@end

static NSString *cellIdentifier = @"shareSubsidies";
@implementation MaMaShareSubsidiesViewController

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
    
    [self createNavigationBarWithTitle:@"分享补贴" selecotr:@selector(backClickAction)];
    [self createTableView];
    
    //网络请求
//    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/clicklog/click_by_day?days=%ld", Root_URL, (long)self.clickDate];
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/carrylog/get_clk_list", Root_URL];
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        
        [self dataDeal:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MaMaShareSubsidiesViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 25, 85, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"今日补贴";
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 75, 45, 145, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = [NSString stringWithFormat:@"%0.2f", [self.todayMoney floatValue]];
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    CGFloat titleLabelY = CGRectGetMaxY(titleLabel.frame);
    self.moneyText = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 110, titleLabelY, 100, 30)];
    self.moneyText.font = [UIFont systemFontOfSize:18];
    self.moneyText.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:self.moneyText];
    
    //历史点击修改
    CGFloat moneyTextY = CGRectGetMaxY(self.moneyText.frame) + 10;
    NSLog(@"moneyTextY:%f", moneyTextY);
    UILabel *history = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, moneyTextY, 60, 40)];
    history.text = @"历史累积";
    history.font = [UIFont systemFontOfSize:14];
    [headerV addSubview:history];
    
    UILabel *totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 + 10, moneyTextY, 90, 40)];
    totalMoney.text = @"15.00";
    totalMoney.font = [UIFont systemFontOfSize:14];
    [headerV addSubview:totalMoney];
    
    self.tableView.tableHeaderView = headerV;
    
    [self.view addSubview:self.tableView];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 数据处理
- (void)dataDeal:(NSDictionary *)dic {
    self.nextPage = dic[@"next"];
    NSArray *clicks = dic[@"results"];
    
//    self.moneyText.text = [NSString stringWithFormat:@"%@", dic[@"all_income"]];
    NSLog(@"%@", clicks);
    for (NSDictionary *click in clicks) {
//        ShareClickModel *clickM = [[ShareClickModel alloc] init];
//        [clickM setValuesForKeysWithDictionary:click];
//        [self.dataArr addObject:clickM];
        CarryLogModel *carryM = [[CarryLogModel alloc] init];
        [carryM setValuesForKeysWithDictionary:click];
        
        NSString *date = [self dateDeal:carryM.carry_date];
        self.dataArr = [[self.dataDic allKeys] mutableCopy];
        if ([self.dataArr containsObject:date]) {
            //已经含有key
            NSMutableArray *orderArr = [self.dataDic objectForKey:date];
            [orderArr addObject:carryM];
        }else {
            //没有key
            NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
            [orderArr addObject:carryM];
            [self.dataDic setObject:orderArr forKey:date];
        }

    }
    self.dataArr = [[self.dataDic allKeys]mutableCopy];
    self.dataArr = [self sortAllKeyArray:self.dataArr];
    
    [self.tableView reloadData];
    
    [self.tableView reloadData];
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSString *year = [str substringToIndex:7];
    NSString *date = [year stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"date:%@", date);
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
#pragma mark UItabelView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.dataArr[section];
    return [self.dataDic[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *order = self.dataDic[key];
    CarryLogModel *clickModel = order[indexPath.row];
    MaMaShareSubsidiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[MaMaShareSubsidiesViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell fillCell:clickModel];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
    CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
    //计算金额
    NSString *key = self.dataArr[section];
    NSMutableArray *orderArr = self.dataDic[key];
    float total = 0.0;
    NSString *date;
    for (CarryLogModel *model in orderArr) {
        total = [model.value_money floatValue] + total;
        date = model.carry_date;
    }
    
    [headerV shareYearLabelAndTotalMoneyLabelText:date total:[NSString stringWithFormat:@"%.2f", total]];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
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

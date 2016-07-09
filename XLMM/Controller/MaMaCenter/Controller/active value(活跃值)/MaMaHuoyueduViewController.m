//
//  MaMaHuoyueduViewController.m
//  XLMM
//
//  Created by younishijie on 16/3/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaHuoyueduViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "HuoyuezhiTableViewCell.h"
#import "HuoyuezhiModel.h"
#import "MJRefresh.h"
#import "NSString+DeleteT.h"
#import "AFNetworking.h"
#import "CarryLogHeaderView.h"
#import "SVProgressHUD.h"

@interface MaMaHuoyueduViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

@property (nonatomic, strong)NSString *nextPage;

@end

@implementation MaMaHuoyueduViewController

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
    [MobClick beginLogPageView:@"MaMaHuoyueduViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"MaMaHuoyueduViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"活跃值" selecotr:@selector(backClicked:)];
    
    [self.tableView registerClass:[HuoyuezhiTableViewCell class] forCellReuseIdentifier:@"HuoyueZhiCell"];
    self.tableView.rowHeight = 80;
    
    [self createHeaderView];
    
    //添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if([self.nextPage class] == [NSNull class]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self loadMore];
    }];
    
    //网络请求
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/mama/activevalue", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (!responseObject)return;
        [self fetchListDic:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)createHeaderView {
    //添加header
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 25, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"近30天活跃值";
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREENWIDTH, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = [NSString stringWithFormat:@"%@", self.activeValueNum];
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    self.tableView.tableHeaderView = headerV;
}

//加载更多
- (void)loadMore {
    if ([self.nextPage class] == [NSNull class]) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.nextPage parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self fetchListDic:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (void)fetchListDic:(NSDictionary *)data{
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    for (NSDictionary *active in results) {
        HuoyuezhiModel *activeM = [[HuoyuezhiModel alloc] init];
        [activeM setValuesForKeysWithDictionary:active];
        NSString *date = [self dateDeal:activeM.date_field];
        self.dataArr = [[self.dataDic allKeys] mutableCopy];
        //判断对应键值的数组是否存在
        if ([self.dataArr containsObject:date]) {
            NSMutableArray *orderArr = self.dataDic[date];
            [orderArr addObject:activeM];
        }else {
            NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
            [orderArr addObject:activeM];
            [self.dataDic setObject:orderArr forKey:date];
        }
    }
    self.dataArr = [[self.dataDic allKeys] mutableCopy];
    self.dataArr = [self sortAllKeyArray:self.dataArr];
    [self.tableView reloadData];
}


//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSString *date = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
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

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = self.dataArr[section];
    NSMutableArray *activeArr = self.dataDic[key];
    return activeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HuoyuezhiTableViewCell" owner:nil options:nil];
    HuoyuezhiTableViewCell *cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *activeArr = self.dataDic[key];
    HuoyuezhiModel *active = activeArr[indexPath.row];
    [cell fillDataOfCell:active];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
    CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
//    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
    //计算金额
    NSString *key = self.dataArr[section];
    NSMutableArray *activeArr = self.dataDic[key];
    HuoyuezhiModel *activeM = [activeArr firstObject];
    
    [headerV activeHeaderViewYearAndDay:activeM.date_field total:[NSString stringWithFormat:@"%d", [activeM.today_carry intValue]]];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
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

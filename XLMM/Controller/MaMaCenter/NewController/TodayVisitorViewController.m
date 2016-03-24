//
//  TodayVisitorViewController.m
//  XLMM
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TodayVisitorViewController.h"
#import "MMClass.h"
#import "SVProgressHUD.h"
#import "UIViewController+NavigationBar.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "FensiTableViewCell.h"
#import "VisitorModel.h"

@interface TodayVisitorViewController ()
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *nextPage;

@end

@implementation TodayVisitorViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //http://192.168.1.13:8000/rest/v2/mama/visitor?from=3
    [self createNavigationBarWithTitle:@"今日访客" selecotr:@selector(backClicked:)];
    
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FensiTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FensiCell"];
    //添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if([self.nextPage class] == [NSNull class]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self downloadData:NO];
    }];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self downloadData:YES];
    
}

- (void)downloadData:(BOOL)type{
    NSString *str = nil;
    if (type) {
        str = [NSString stringWithFormat:@"%@/rest/v2/mama/visitor?from=%ld", Root_URL, (long)[self.visitorDate integerValue]];
    }else {
        str = self.nextPage;
    }
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self fetchedData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)fetchedData:(NSDictionary *)dic{
    [SVProgressHUD dismiss];
    [self.tableView.mj_footer endRefreshing];
    if (dic.count == 0) {
        return;
    }else {
        //生成粉丝列表
        self.nextPage = dic[@"next"];
        NSArray *array = dic[@"results"];
        for (NSDictionary *dic in array) {
            VisitorModel *visitorM = [[VisitorModel alloc] init];
            [visitorM setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:visitorM];
        }
        [self.tableView reloadData];
    }
    
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FensiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FensiCell"];
    if (cell == nil) {
        cell = [[FensiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FensiCell"];
    }
    VisitorModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell fillVisitorData:model];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
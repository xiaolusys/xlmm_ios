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

@interface MaMaShareSubsidiesViewController ()
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UILabel *moneyText;
@end

static NSString *cellIdentifier = @"shareSubsidies";
@implementation MaMaShareSubsidiesViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
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
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/clicklog/click_by_day?days=%ld", Root_URL, (long)self.clickDate];
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
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 165)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 25, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"今日补贴";
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 75, 45, 150, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = [NSString stringWithFormat:@"%@", self.todayMoney];
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    CGFloat lineViewY = CGRectGetMaxY(lineView.frame);
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineViewY + 13, 18, 18)];
    imageV.image = [UIImage imageNamed:@"totalClick.png"];
    [headerV addSubview:imageV];
    CGFloat imageVX = CGRectGetMaxX(imageV.frame) + 10;
    UILabel *totalText = [[UILabel alloc] initWithFrame:CGRectMake(imageVX, lineViewY + 7, 80, 30)];
    totalText.text = @"历史累积";
    totalText.font = [UIFont systemFontOfSize:14];
    [headerV addSubview:totalText];
    self.moneyText = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 110, lineViewY + 7, 100, 30)];
    self.moneyText.font = [UIFont systemFontOfSize:18];
    self.moneyText.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:self.moneyText];
    
    self.tableView.tableHeaderView = headerV;
    
    [self.view addSubview:self.tableView];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 数据处理
- (void)dataDeal:(NSDictionary *)dic {
    NSArray *clicks = dic[@"results"];
    self.moneyText.text = [NSString stringWithFormat:@"%@", dic[@"all_income"]];
    for (NSDictionary *click in clicks) {
        ShareClickModel *clickM = [[ShareClickModel alloc] init];
        [clickM setValuesForKeysWithDictionary:click];
        [self.dataArr addObject:clickM];
    }
    
    [self.tableView reloadData];
}

#pragma mark UItabelView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareClickModel *clickModel = self.dataArr[indexPath.row];
    MaMaShareSubsidiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[MaMaShareSubsidiesViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell fillCell:clickModel];
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

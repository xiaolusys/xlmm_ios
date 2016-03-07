//
//  FensiListViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "FensiListViewController.h"
#import "UIViewController+NavigationBar.h"
#import "FensiTableViewCell.h"
#import "MMClass.h"
#import "FanceModel.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"


@interface FensiListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *nextPage;

@end

@implementation FensiListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"粉丝列表" selecotr:@selector(backClicked:)];
    [self.view addSubview:self.tableView];
    
    //添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if([self.nextPage class] == [NSNull class]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self loadMore];
    }];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self downloadData];
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_fans_list", Root_URL];
    //    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
    
}
- (void)loadMore {
    NSString *string = self.nextPage;
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
}

- (void)fetchedData:(NSData *)data{
    [SVProgressHUD dismiss];
    [self.tableView.mj_footer endRefreshing];
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (dic.count == 0) {
        return;
    }else {
        //生成粉丝列表
        self.nextPage = dic[@"next"];
        NSArray *array = dic[@"results"];
        [self createFanlistWithArray:array];
    }
    
}

- (void)createFanlistWithArray:(NSArray *)array{
    for (NSDictionary *dic in array) {
        FanceModel *fan = [[FanceModel alloc] initWithInfo:dic];
        [self.dataArray addObject:fan];
    }
    [self.tableView reloadData];
}



- (void)backClicked:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentify = @"CellIdentify";
    
    FensiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FensiTableViewCell" owner:self options:nil] lastObject];
    }
    FanceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell fillData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UIImageView *image = [[UIImageView alloc] init];
    //    image.image = [UIImage imageNamed:@"Icon-60@3x"];
    return cell;
}
@end

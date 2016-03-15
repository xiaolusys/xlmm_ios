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







@interface MaMaHuoyueduViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *nextString;





@end

@implementation MaMaHuoyueduViewController

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
    self.dataArray = [[NSMutableArray alloc] init];
    [self createNavigationBarWithTitle:@"活跃值" selecotr:@selector(backClicked:)];
    
    
    //  http://192.168.1.13:8000/rest/v2/mama/activevalue
    
   
    
    
    [self.tableView registerClass:[HuoyuezhiTableViewCell class] forCellReuseIdentifier:@"HuoyueZhiCell"];
   
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
    // 设置文字

    
}

- (void)loadNewData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/mama/activevalue", Root_URL];
    MMLOG(string);
    [self downLoadWithURLString:string andSelector:@selector(fetchListData:)];

}

- (void)loadMoreData{
    if (self.nextString == nil) {
        //下页为空
        
        [self.tableView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    } else {
        [self downLoadWithURLString:self.nextString andSelector:@selector(fetchMoreList:)];
    }
    
}

- (void)fetchListData:(NSData *)data{
    [self.dataArray removeAllObjects];
    
    
    [self.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    NSArray *results = [dic objectForKey:@"results"];
    
    for (NSDictionary *info in results) {
        HuoyuezhiModel *model = [[HuoyuezhiModel alloc] init];
        [model setValuesForKeysWithDictionary:info];
       
        
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
    
    
 
    NSLog(@"self.dataArray = %@", self.dataArray);
    if ([[dic objectForKey:@"next"] class] == [NSNull class]) {
        self.nextString = nil;
        
    } else {
        self.nextString = [dic objectForKey:@"next"];
        
        
    }
    
    MMLOG(self.nextString);
    
   

    
}

- (void)fetchMoreList:(NSData *)data{
    
    [self.tableView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    

    
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    
    NSArray *results = [dic objectForKey:@"results"];
    
    for (NSDictionary *info in results) {
        HuoyuezhiModel *model = [[HuoyuezhiModel alloc] init];
        [model setValuesForKeysWithDictionary:info];
        
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
    
    NSLog(@"self.dataArray = %@", self.dataArray);
    
    self.nextString = [dic objectForKey:@"next"];
    
    MMLOG(self.nextString);
    
    if ([self.nextString class] == [NSNull class]) {
        //下页为空
    } else {
        [self downLoadWithURLString:self.nextString andSelector:@selector(fetchMoreList:)];
    }

}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HuoyuezhiTableViewCell" owner:nil options:nil];
    HuoyuezhiTableViewCell *cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    HuoyuezhiModel *model = self.dataArray[indexPath.row];
    cell.timeLabel.text = [NSString dateDeleteT:model.created];
    cell.typeLabel.text = model.value_type_name;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@", model.value_num];
    cell.carryLabel.text = [NSString stringWithFormat:@"%@", model.today_carry];
    cell.statusLabel.text = model.status_display;
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

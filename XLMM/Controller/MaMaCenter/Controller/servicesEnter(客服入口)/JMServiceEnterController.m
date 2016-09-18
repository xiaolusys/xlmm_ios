//
//  JMServiceEnterController.m
//  XLMM
//
//  Created by zhang on 16/8/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMServiceEnterController.h"
#import "MMClass.h"
#import "JMServiceEnterCell.h"
#import "UdeskChatViewController.h"
#import "Udesk.h"


@interface JMServiceEnterController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JMServiceEnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"客服咨询" selecotr:@selector(backClick:)];
    [self createDataSource];
    [self createTableView];
    
}
- (void)createDataSource {
    self.dataSource = @[@{@"iconImage":@"serviceOnlineConsulting",
                          @"title":@"在线咨询",
                          @"descTitle":@"在线常见疑难问题解答"},
                        @{@"iconImage":@"serviceHotLine",
                          @"title":@"客服热线",
                          @"descTitle":@"021-60927905"}
                        ];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *JMServiceEnterCellID = @"JMServiceEnterCell";
    JMServiceEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:JMServiceEnterCellID];
    if (cell == nil) {
        cell = [[JMServiceEnterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMServiceEnterCellID];
    }
    cell.dataDic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UD_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
        UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
        [self.navigationController pushViewController:chat animated:YES];
    }else {
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"JMServiceEnterController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"JMServiceEnterController"];
}
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


@end



















/**
 *
 */









































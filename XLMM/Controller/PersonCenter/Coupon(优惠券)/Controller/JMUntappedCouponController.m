//
//  JMUntappedCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUntappedCouponController.h"
#import "MMClass.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JMCouponModel.h"
#import "JMCouponRootCell.h"
//#import "JMSelecterButton.h"

@interface JMUntappedCouponController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JMCouponModel *couponModel;
//下拉的标志
@property (nonatomic) BOOL isPullDown;

//@property (nonatomic, strong) JMSelecterButton *sureButton;
@end

@implementation JMUntappedCouponController {
    NSString *_urlStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabelView];
    
    [self createPullHeaderRefresh];
//    [self createUsedButton];
}
- (NSInteger)couponCount {
    return 0;
}
- (NSString *)urlStr {
    return [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=0",Root_URL];
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)createTabelView {
    CGFloat tableViewH = 0.;
    if ([self couponCount] == 5) {
        tableViewH = 60.;
    }else {
        tableViewH = 0.;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 99 - tableViewH) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    //    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self loadDataSource];
    }];
}

- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }

}
- (void)loadDataSource{
    NSString *string = [self urlStr];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        [self.dataSource removeAllObjects];
        [self refetch:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
- (void)refetch:(NSArray *)data {
    for (NSDictionary *dict in data) {
        self.couponModel = [JMCouponModel mj_objectWithKeyValues:dict];
        [self.dataSource addObject:self.couponModel];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMCouponController";
    JMCouponRootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMCouponRootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.couponModel = self.dataSource[indexPath.row];
    [cell configData:self.couponModel Index:[self couponCount]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self couponCount] == 0) {
        
        
        
        
    }else if ([self couponCount] == 5) {
        //购物选择优惠券
        self.couponModel = self.dataSource[indexPath.row];
            
    }else {
        
        
    }
}
//- (void)createUsedButton {
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
@end

































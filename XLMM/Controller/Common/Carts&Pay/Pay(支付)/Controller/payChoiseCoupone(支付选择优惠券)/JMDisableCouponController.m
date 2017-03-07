//
//  JMDisableCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMDisableCouponController.h"
#import "JMCouponRootCell.h"
#import "JMCouponModel.h"
#import "CSTableViewPlaceHolderDelegate.h"
#import "JMReloadEmptyDataView.h"

@interface JMDisableCouponController ()<UITableViewDelegate,UITableViewDataSource,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;


@end

@implementation JMDisableCouponController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView cs_reloadData];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 110;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMUsableCouponController";
    JMCouponRootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMCouponRootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMCouponModel *couponModel = [[JMCouponModel alloc] init];
    couponModel = self.dataSource[indexPath.row];
    [cell configData:couponModel Index:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"emptyYouhuiquanIcon" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}
//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT - 80) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" BackImage:@"emptyYouhuiquanIcon" InfoStr:@"快去逛逛"];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
//        }
//    };
//}

- (void)gotoLeadingView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}




























@end


















































































































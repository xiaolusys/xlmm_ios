//
//  JMUntappedCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUntappedCouponController.h"
#import "JMCouponModel.h"
#import "JMCouponRootCell.h"
#import "JMEmptyView.h"
#import "JMReloadEmptyDataView.h"
#import "CSTableViewPlaceHolderDelegate.h"

//#import "JMSelecterButton.h"

@interface JMUntappedCouponController ()<UITableViewDataSource,UITableViewDelegate,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JMCouponModel *couponModel;
@property (nonatomic, assign) BOOL isPopToRootView;
//@property (nonatomic, strong) JMSelecterButton *sureButton;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

@implementation JMUntappedCouponController {
    NSString *_urlStr;
    
    UIView *emptyView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabelView];
//    [self displayEmptyView];
    
}
- (NSInteger)couponCount {
    return 0;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)createTabelView {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 110;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)setCouponArray:(NSArray *)couponArray {
    _couponArray = couponArray;
    if (couponArray.count == 0) {
//        [self emptyView];
    }else {
        for (NSDictionary *dic in couponArray) {
            self.couponModel = [JMCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:self.couponModel];
        }
    }
    [self.tableView cs_reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
    if ([self couponCount] == 8) {
        NSLog(@"couponCount == 8 被点击");
    }
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
//            self.isPopToRootView = YES;
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
//        }
//    };
//}

- (void)displayEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyYHQView" owner:nil options:nil];
    UIView *empty = views[0];
    UIButton *button = (UIButton *)[empty viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoLeadingView) forControlEvents:UIControlEventTouchUpInside];
    emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    emptyView.backgroundColor = [UIColor backgroundlightGrayColor];
    emptyView.hidden = YES;
    [self.view addSubview:emptyView];
    empty.frame = CGRectMake(0, SCREENHEIGHT/2 - 100, SCREENWIDTH, 220);
    [emptyView addSubview:empty];
}
- (void)gotoLeadingView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPopToRootView = NO;
    [self.tableView.mj_header beginRefreshing];
    [MobClick beginLogPageView:@"YouHuiQuan"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPopToRootView) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    }
    [MobClick endLogPageView:@"YouHuiQuan"];
}
@end

































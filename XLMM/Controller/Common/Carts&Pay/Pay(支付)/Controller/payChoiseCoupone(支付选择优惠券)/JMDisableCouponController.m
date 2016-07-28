//
//  JMDisableCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMDisableCouponController.h"
#import "MMClass.h"
#import "JMCouponRootCell.h"
#import "JMCouponModel.h"

@interface JMDisableCouponController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation JMDisableCouponController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self displayEmptyView];
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count == 0) {
        self.emptyView.hidden = NO;
    }else {
        self.emptyView.hidden = YES;
    }
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 110;
    self.tableView.tableFooterView = nil;

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
- (void)displayEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyYHQView" owner:nil options:nil];
    UIView *empty = views[0];
    UIButton *button = (UIButton *)[empty viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoLeadingView) forControlEvents:UIControlEventTouchUpInside];
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.emptyView.backgroundColor = [UIColor backgroundlightGrayColor];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    empty.frame = CGRectMake(0, SCREENHEIGHT/2 - 100, SCREENWIDTH, 220);
    [self.emptyView addSubview:empty];
}
- (void)gotoLeadingView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}




























@end


















































































































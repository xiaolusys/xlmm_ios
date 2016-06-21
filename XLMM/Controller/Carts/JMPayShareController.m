//
//  JMPayShareController.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayShareController.h"
#import "JMPaySucTitleView.h"
#import "UIColor+RGBColor.h"
#import "JMSelecterButton.h"
#import "Masonry.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "JMSharePackView.h"
#import "JMBuyerAddressCell.h"

@interface JMPayShareController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) JMPaySucTitleView *paySuccessView;

@property (nonatomic,strong) JMSharePackView *sharePackView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JMPayShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"支付成功" selecotr:@selector(backClick:)];
    
    [self createTableView];
    [self topShowTitle];
    
//    [self.tableView setTableHeaderView:self.paySuccessView];
//    [self.tableView setTableFooterView:self.sharePackView];
    self.tableView.rowHeight = 100;
//    self.tableView.estimatedRowHeight = 90;
    
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView = nil;
}

- (void)topShowTitle {
    
    JMPaySucTitleView *paySuccessView = [[JMPaySucTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
    [self.view addSubview:paySuccessView];
    self.paySuccessView = paySuccessView;
    
    JMSharePackView *sharePackView = [[JMSharePackView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 230)];
    [self.view addSubview:sharePackView];
    self.sharePackView = sharePackView;
    
    self.tableView.tableHeaderView = self.paySuccessView;
    self.tableView.tableFooterView = self.sharePackView;

//    kWeakSelf
    
//    [self.paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).offset(64);
//        make.left.equalTo(weakSelf.tableView);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@260);
//    }];
//    
//    [self.sharePackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.equalTo(weakSelf.view);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@230);
//    }];
    
    
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMBuyerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBuyerAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end















































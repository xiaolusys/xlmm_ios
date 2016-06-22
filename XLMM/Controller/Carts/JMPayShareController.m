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
    
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = nil;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
}

- (void)topShowTitle {
    
    JMPaySucTitleView *paySuccessView = [JMPaySucTitleView enterHeaderView];
    self.paySuccessView = paySuccessView;
    
    JMSharePackView *sharePackView = [JMSharePackView enterHeaderView];
    self.sharePackView = sharePackView;
    
    self.tableView.tableHeaderView = self.paySuccessView;
    self.tableView.tableFooterView = self.sharePackView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMBuyerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBuyerAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end















































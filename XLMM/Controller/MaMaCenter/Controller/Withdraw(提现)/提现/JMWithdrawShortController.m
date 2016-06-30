//
//  JMWithdrawShortController.m
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithdrawShortController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"

@interface JMWithdrawShortController ()<UITableViewDelegate,UITableViewDataSource>

/*
 我的余额
 */
@property (nonatomic,strong) UIView *myBlanceView;
@property (nonatomic,strong) UILabel *blanceLabel;
@property (nonatomic,strong) UILabel *blanceMoneyLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JMWithdrawShortController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    [self createCoupon];
    
}

#pragma mark --- 取现金额不足100显示领取优惠券视图
- (void)createCoupon {
    /*
     我的余额
     */
    UIView *myBlanceView = [[UIView alloc] init];
    [self.view addSubview:myBlanceView];
    self.myBlanceView = myBlanceView;
    self.myBlanceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *blanceLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceLabel];
    self.blanceLabel = blanceLabel;
    self.blanceLabel.font = [UIFont systemFontOfSize:14.];
    self.blanceLabel.text = @"小鹿妈妈账户余额：";
    
    UILabel *blanceMoneyLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceMoneyLabel];
    self.blanceMoneyLabel = blanceMoneyLabel;
    self.blanceMoneyLabel.font = [UIFont systemFontOfSize:12.];
    self.blanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.myBalance];
    
    UIView *headView = [UIView new];
    [self.view addSubview:headView];
    
    UILabel *notEngouthLabel = [UILabel new];
    [self.view addSubview:notEngouthLabel];
    
    UILabel *convertCouponLabel = [UILabel new];
    [self.view addSubview:convertCouponLabel];
    
    
    kWeakSelf
    //我的余额
    [self.myBlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myBlanceView).offset(20);
        make.left.equalTo(weakSelf.myBlanceView.mas_left).offset(11);
        make.height.mas_equalTo(@20);
    }];
    
    [self.blanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.blanceLabel.mas_centerY);
        make.left.equalTo(weakSelf.blanceLabel.mas_right).offset(5);
    }];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myBlanceView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@80);
    }];
    
    [notEngouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(10);
        make.right.equalTo(headView).offset(-10);
    }];
    
    [convertCouponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.bottom.equalTo(headView).offset(-20);
    }];
    
    
    
}
- (void)createTabelView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, SCREENWIDTH, SCREENHEIGHT - 200) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    return cell;
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end







































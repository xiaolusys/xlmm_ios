//
//  JMChoiseWithDrawController.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChoiseWithDrawController.h"
#import "MMClass.h"
#import "JMChoiseWithDrawCell.h"
#import "TixianViewController.h"
#import "JMWithdrawShortController.h"
#import "JMWithdrawCashController.h"
#import "TixianHistoryViewController.h"

@interface JMChoiseWithDrawController () <UITableViewDataSource,UITableViewDelegate> {
    NSArray *cellDataArr;              // 自定义在cell上展示的类型
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *withDrawDescLabel;

@end

@implementation JMChoiseWithDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClick:)];
    cellDataArr = @[@{
                        @"title":@"小额提现",
                        @"descTitle":@"提现金额小于等于6元"
                        },
                    @{
                        @"title":@"整额提现",
                        @"descTitle":@"提现金额为100元200元整"
                        },
                    @{
                        @"title":@"兑换现金券",
                        @"descTitle":@"提现现金券为20元50元整"
                        }
                    ];
    [self createRightButonItem];
    [self createTableView];
    [self loadCashoutPolicyData];
    
}

- (void)loadCashoutPolicyData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/cashout_policy",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.withDrawDescLabel.text = responseObject[@"message"];
        NSString *string = [NSString stringWithFormat:@"提现金额%@元至%@元",responseObject[@"min_cashout_amount"],responseObject[@"audit_cashout_amount"]];
        cellDataArr = @[@{
                            @"title":@"快速提现",
                            @"descTitle":string
                            },
                        @{
                            @"title":@"整额提现",
                            @"descTitle":@"提现金额为100元200元整"
                            },
                        @{
                            @"title":@"兑换现金券",
                            @"descTitle":@"提现现金券为20元50元整"
                            }
                        ];
        
        self.moneyLabel.text = CS_FLOAT(self.myBlance);
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    UILabel *takeoutMoney = [[UILabel alloc] init];
    [headerView addSubview:takeoutMoney];
    takeoutMoney = takeoutMoney;
    takeoutMoney.text = @"我的余额(元)";
    takeoutMoney.font = CS_SYSTEMFONT(13.);
    takeoutMoney.textAlignment = NSTextAlignmentCenter;
    
    [takeoutMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView).offset(20);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [headerView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    self.moneyLabel.font = CS_SYSTEMFONT(40.);
    self.moneyLabel.text = CS_FLOAT(self.myBlance);
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(takeoutMoney.mas_centerX);
        make.top.equalTo(takeoutMoney.mas_bottom).offset(10);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    self.tableView.tableFooterView = footerView;
    UILabel *withDrawDescLabel = [UILabel new];
    [footerView addSubview:withDrawDescLabel];
    withDrawDescLabel.font = CS_SYSTEMFONT(13.);
    withDrawDescLabel.textColor = [UIColor dingfanxiangqingColor];
    withDrawDescLabel.numberOfLines = 0;
    self.withDrawDescLabel = withDrawDescLabel;
    [withDrawDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(footerView).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    
    
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"JMChoiseWithDrawCell";
    JMChoiseWithDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JMChoiseWithDrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = cellDataArr[indexPath.row];
    cell.withDrawDic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (index == 0) { // 小额提现
        JMWithdrawCashController *drawCash = [[JMWithdrawCashController alloc] init];
        drawCash.myBlabce = self.myBlance;
        drawCash.isMaMaWithDraw = YES;
        drawCash.block=^(CGFloat money){
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
        };
        [self.navigationController pushViewController:drawCash animated:YES];
    }else if (index == 1) { // 整额提现
        TixianViewController *vc = [[TixianViewController alloc] init];
        vc.cantixianjine = self.myBlance;
//        vc.activeValue = [_activeValueNum integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2) { // 兑换优惠券
        JMWithdrawShortController *shortVC = [[JMWithdrawShortController alloc] init];
        shortVC.myBalance = self.myBlance;
//        shortVC.descStr = self.extraModel.cashout_reason;
        [self.navigationController pushViewController:shortVC animated:YES];
    }else { }
    
    
    
}

#pragma mark ---- 导航栏右侧体现历史
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"提现历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
    TixianHistoryViewController *historyVC = [[TixianHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}



- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}



@end


/**
 *  
 
 
 //        NSInteger code = [self.extraModel.could_cash_out integerValue]; // 1.提现 0.兑换优惠券
 //        if (code == 1) {
 //            TixianViewController *vc = [[TixianViewController alloc] init];
 //            vc.cantixianjine = _carryValue;
 //            vc.activeValue = [_activeValueNum integerValue];
 //            [self.navigationController pushViewController:vc animated:YES];
 //        }else {
 //            JMWithdrawShortController *shortVC = [[JMWithdrawShortController alloc] init];
 //            shortVC.myBalance = _carryValue;
 //            shortVC.descStr = self.extraModel.cashout_reason;
 //            [self.navigationController pushViewController:shortVC animated:YES];
 //        }
 
 
 
 */














































































//
//  JMWithDrawDetailController.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithDrawDetailController.h"
#import "MMClass.h"
#import "JMTimeLineView.h"
#import "JMWithDrawDetailCell.h"
#import "TixianViewController.h"
#import "JMWithdrawCashController.h"
#import "Account1ViewController.h"
#import "JMToolTimeLineView.h"


@interface JMWithDrawDetailController () <UITableViewDataSource,UITableViewDelegate> {
    NSArray *timeLineTitleArr;         // 时间轴标题
    NSArray *timeLineTimeArray;        // 时间轴时间
    NSArray *cellDataArr;              // 自定义在cell上展示的类型
    NSArray *imageArray;               // 图片数组
    NSInteger flag;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIView *timeLineBaseView;

@end

@implementation JMWithDrawDetailController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMWithDrawDetailController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMWithDrawDetailController"];
}
- (void)setIsActiveValue:(BOOL)isActiveValue {
    _isActiveValue = isActiveValue;

}
- (void)setDrawDict:(NSDictionary *)drawDict {
    _drawDict = drawDict;
    
    flag = 1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"账单明细" selecotr:@selector(backClickedesllect:)];
    
    timeLineTitleArr = [NSArray array];
    timeLineTimeArray = [NSArray array];
    cellDataArr = [NSArray array];
    if (flag == 1) {
        
    }else {
        if (self.isActiveValue) {
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout", Root_URL];
            [self loadStatusData:urlString];
        }else {
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/get_budget_detail", Root_URL];
            [self loadStatusData:urlString];
        }
    }
    
    cellDataArr = @[@{
                      @"title":@"提现至账户",
                      @"descTitle":@"测试数据测试数据测试数据"
                      },
                    @{
                      @"title":@"创 建 时 间",
                      @"descTitle":@"测试数据测试数据"
                      }
                    ];
    timeLineTitleArr = @[@"金额冻结",@"审核中",@"提现成功"];
    imageArray = @[@[@"ice_Image",@"dispose_Image",@"success_Image_nomal"],
                   @[@"ice_Image",@"dispose_Image",@"success_Image"]];
    
    [self createTableView];
    
}
- (void)loadStatusData:(NSString *)urlString {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) return ;
        NSArray *results = responseObject[@"results"];
        NSDictionary *dict = results[0];
        [self fetchData:dict];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"查询有误"];
    } Progress:^(float progress) {
    }];
    
    
}
- (void)fetchData:(NSDictionary *)dict {
    NSString *timeString = dict[@"budget_date"];
    timeLineTimeArray = @[timeString,timeString,timeString];

    JMToolTimeLineView *timeLineView = [[JMToolTimeLineView alloc] initWithTimeArray:timeLineTimeArray andTimeDesArray:timeLineTitleArr ImageArray:imageArray andCurrentStatus:2 andFrame:self.timeLineBaseView.bounds];
    [self.timeLineBaseView addSubview:timeLineView];

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 240)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    UILabel *takeoutMoney = [[UILabel alloc] init];
    [headerView addSubview:takeoutMoney];
    takeoutMoney = takeoutMoney;
    takeoutMoney.text = @"出账余额(元)";
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
    self.moneyLabel.text = @"888.88";
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(takeoutMoney.mas_centerX);
        make.top.equalTo(takeoutMoney.mas_bottom).offset(10);
    }];
    
    UIView *timeLineBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 120)];
    [headerView addSubview:timeLineBaseView];
    self.timeLineBaseView = timeLineBaseView;
    
    NSString *budgetType = @"提现至账户:";
    if (flag == 1) {
        if ([self.drawDict[@"budget_type"] boolValue]) {
            takeoutMoney.text = @"出账金额(元)";
        }else {
            takeoutMoney.text = @"入账金额(元)";
            budgetType = @"收入至账户:";
            timeLineTitleArr = @[@"金额冻结",@"审核中",@"入账成功"];
        }
        self.moneyLabel.text = CS_FLOAT([self.drawDict[@"budeget_detail_cash"] floatValue]);
        NSString *timeStr = self.drawDict[@"budget_date"];
        NSString *typeStr = self.drawDict[@"budget_log_type"];
        cellDataArr = @[@{
                            @"title":budgetType,
                            @"descTitle":typeStr
                            },
                        @{
                            @"title":@"创 建 时 间:",
                            @"descTitle":timeStr
                            }
                        ];
        timeLineTimeArray = @[timeStr,timeStr,timeStr];
        JMToolTimeLineView *timeLineView = [[JMToolTimeLineView alloc] initWithTimeArray:timeLineTimeArray andTimeDesArray:timeLineTitleArr ImageArray:imageArray andCurrentStatus:2 andFrame:self.timeLineBaseView.bounds];
        [self.timeLineBaseView addSubview:timeLineView];
        
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"JMWithDrawDetailCell";
    JMWithDrawDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JMWithDrawDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = cellDataArr[indexPath.row];
    cell.withDrawDic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)backClickedesllect:(id)sender {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[TixianViewController class]] || [temp isKindOfClass:[JMWithdrawCashController class]] || [temp isKindOfClass:[Account1ViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
    
}




@end

















































































































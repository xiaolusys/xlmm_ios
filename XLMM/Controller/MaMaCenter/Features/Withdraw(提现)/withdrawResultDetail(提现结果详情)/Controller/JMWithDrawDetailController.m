//
//  JMWithDrawDetailController.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithDrawDetailController.h"
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

@property (nonatomic, strong) UILabel *takeoutMoney;

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
- (void)setMamaWithDrawHistoryDict:(NSDictionary *)mamaWithDrawHistoryDict {
    _mamaWithDrawHistoryDict = mamaWithDrawHistoryDict;
    flag = 1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"账单明细" selecotr:@selector(backClickedesllect:)];
    timeLineTitleArr = [NSArray array];
    timeLineTimeArray = [NSArray array];
    cellDataArr = [NSArray array];
    cellDataArr = @[@{
                        @"title":@"收 支 类 型",
                        @"descTitle":@"暂无数据,请稍后查询"
                        },
                    @{
                        @"title":@"创 建 时 间:",
                        @"descTitle":@"暂无数据,请稍后查询"
                        }
                    ];
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
    
    imageArray = @[@[@"ice_Image",@"dispose_Image",@"success_Image_nomal"],
                   @[@"ice_Image",@"dispose_Image",@"success_Image"]];
    
    [self createTableView];
    
}
- (void)loadStatusData:(NSString *)urlString {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) return ;
        NSArray *results = responseObject[@"results"];
        if (results.count == 0) {
            self.moneyLabel.text = @"暂无数据,请稍后查询。 如有疑问请询问小鹿美美客服哦~!";
        }else {
            NSDictionary *dict = results[0];
            [self fetchData:dict ActiveValye:self.isActiveValue];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"查询有误"];
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchData:(NSDictionary *)dict ActiveValye:(BOOL)isMaMaWithDraw {
    NSString *budgetType = @"提现至账户:";
    NSInteger statusCode = 2;
    if (isMaMaWithDraw) {
        NSString *timeString = dict[@"created"];
        NSString *timeStr = [timeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *timeS = [timeStr substringWithRange:NSMakeRange(5,11)];
        timeLineTimeArray = @[timeS,timeS,timeS];
        self.moneyLabel.text = CS_FLOAT([dict[@"value_money"] floatValue]);
        cellDataArr = @[@{
                            @"title":budgetType,
                            @"descTitle":dict[@"get_cash_out_type_display"]
                            },
                        @{
                            @"title":@"创 建 时 间:",
                            @"descTitle":timeStr
                            }
                        ];
        timeLineTitleArr = @[@"金额冻结",dict[@"get_status_display"],@"提现成功"];
        if ([dict[@"status"] isEqual:@"approved"]) {  // 审核状态在下方 注释块中
            statusCode = 3;
        }
    }else {
        NSString *budgetType = @"提现至账户:";
        if ([dict[@"status"] integerValue] == 0) {
            statusCode = 3;
        }
        NSString *statusDescStr = dict[@"get_status_display"];
        if ([dict[@"budget_type"] boolValue]) {
            self.takeoutMoney.text = @"出账金额(元)";
            timeLineTitleArr = @[@"金额冻结",statusDescStr,@"提现成功"];
        }else {
            self.takeoutMoney.text = @"入账金额(元)";
            budgetType = @"收入至账户:";
            timeLineTitleArr = @[@"金额冻结",statusDescStr,@"入账成功"];
        }
        self.moneyLabel.text = CS_FLOAT([dict[@"budeget_detail_cash"] floatValue]);
        NSString *timeStr = dict[@"budget_date"];
        NSString *typeStr = dict[@"desc"];
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
    }

    [self.tableView reloadData];
    JMToolTimeLineView *timeLineView = [[JMToolTimeLineView alloc] initWithTimeArray:timeLineTimeArray andTimeDesArray:timeLineTitleArr ImageArray:imageArray andCurrentStatus:statusCode andFrame:self.timeLineBaseView.bounds];
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
    takeoutMoney.font = CS_UIFontSize(13.);
    takeoutMoney.textAlignment = NSTextAlignmentCenter;
    self.takeoutMoney = takeoutMoney;
    
    [takeoutMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView).offset(20);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [headerView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    self.moneyLabel.font = CS_UIFontSize(40.);
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(takeoutMoney.mas_centerX);
        make.top.equalTo(takeoutMoney.mas_bottom).offset(10);
    }];
    
    UIView *timeLineBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 120)];
    [headerView addSubview:timeLineBaseView];
    self.timeLineBaseView = timeLineBaseView;
    
    if (flag == 1) {
        if (self.isActiveValue) {
            [self fetchData:self.mamaWithDrawHistoryDict ActiveValye:YES];
        }else {
            [self fetchData:self.drawDict ActiveValye:NO];
        }
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
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[TixianViewController class]] || [temp isKindOfClass:[JMWithdrawCashController class]] || [temp isKindOfClass:[Account1ViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end




/**
 *  
 
 小鹿妈妈
 PENDING = 'pending'
 APPROVED = 'approved'
 REJECTED = 'rejected'
 COMPLETED = 'completed'
 CANCEL = 'cancel'
 SENDFAIL = 'fail'
 
 STATUS_CHOICES = (
 (PENDING, u'待审核'),
 (APPROVED, u'审核通过'),
 (REJECTED, u'已拒绝'),
 (CANCEL, u'取消'),
 (COMPLETED, u'完成'),
 (SENDFAIL, u'发送失败')
 )
 
 个人
 CONFIRMED = 0
 CANCELED = 1
 PENDING = 2
 
 STATUS_CHOICES = (
 (PENDING, u'待确定'),
 (CONFIRMED, u'已确定'),
 (CANCELED, u'已取消'),
 )
 
 
 
 
 
 */












































































































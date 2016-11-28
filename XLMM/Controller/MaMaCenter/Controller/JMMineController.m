//
//  JMMineController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMineController.h"
#import "JMMaMaCenterModel.h"
#import "JMMaMaExtraModel.h"
#import "TixianViewController.h"
#import "JMWithdrawShortController.h"
#import "MaClassifyCarryLogViewController.h"
#import "TodayVisitorViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaMaHuoyueduViewController.h"
#import "JMMaMaCenterFansController.h"
#import "JMMaMaEarningsRankController.h"
#import "JMMaMaTeamController.h"
#import "WebViewController.h"
#import "JMVipRenewController.h"
#import "HCScanQRViewController.h"
#import "SystemFunctions.h"
#import "JMRichTextTool.h"
#import "JMChoiseWithDrawController.h"

@interface JMMineController ()<UITableViewDataSource,UITableViewDelegate> {
    CGFloat _carryValue;              // 账户金额
    NSNumber *_activeValueNum;        // 活跃值
    NSNumber *_fansNum;               // 我的粉丝
    NSNumber *_visitorDate;           // 今日访客
    NSString *_orderRecord;           // 订单记录
    NSString *_earningsRecord;        // 收益记录
    NSString *_historyEarningsRecord; // 2016.3.24号系统升级之前的收益
    NSString *_eventLink;             // 精选活动链接
    NSString *_examWebUrl;            // 等级考试入口
    NSString *_fansWebUrl;            // 关于粉丝入口
    NSString *_boutiqueActiveWebUrl;  // 精品活动入口
    NSString *_renewWebUrl;           // 续费
    NSString *_messageUrl;            // 消息滚动视图
    NSString *_bbsUrl;                // 论坛
    NSString *_teamExplainUrl;        // 团队排行说明
}

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) JMAutoLoopScrollView *scrollView;

@property (nonatomic, strong) UILabel *idLabel;                // 妈妈ID
@property (nonatomic, strong) UILabel *memberLabel;            // 会员剩余期限
@property (nonatomic, strong) UILabel *isMaMaVipLabel;         // 妈妈的VIP状态
@property (nonatomic, strong) UILabel *mamaLeveLabel;          // 妈妈的VIP等级
@property (nonatomic, strong) UIImageView *iconImage;          // 妈妈头像
@property (nonatomic, strong) UILabel *label1;                 // 我的提现
@property (nonatomic, strong) UILabel *label2;                 // 累计收益
@property (nonatomic, strong) UILabel *label3;                 // 访客记录
@property (nonatomic, strong) UILabel *label4;                 // 订单记录
@property (nonatomic, strong) UILabel *label5;                 // 活跃度
@property (nonatomic, strong) UILabel *label6;                 // 我的粉丝
@property (nonatomic, strong) UILabel *label7;                 // 个人排名
@property (nonatomic, strong) UILabel *label8;                 // 我的团队
@property (nonatomic, strong) UIButton *renewButton;           // 续费按钮

@property (nonatomic, strong) NSMutableDictionary *mamaWebDict;
/**
 *  字典中存储在webView中使用的值
 */
@property (nonatomic,strong) NSMutableDictionary *diction;
/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;


@end

@implementation JMMineController {
    NSString *_mamaID;
}
- (NSMutableDictionary *)mamaWebDict {
    if (_mamaWebDict == nil) {
        _mamaWebDict = [NSMutableDictionary dictionary];
    }
    return _mamaWebDict;
}
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"个人中心" selecotr:nil];
    [self createTableView];
    [self createHeaderView];
    
    [self loadMaMaWeb];
    [self createPullHeaderRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            [self endRefresh];
            return ;
        }else {
            [self updateMaMaHome:responseObject];
            [self endRefresh];
        }
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortuneDic = dic[@"mama_fortune"];
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    self.extraFiguresDic = fortuneDic[@"extra_figures"];
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:self.mamaCenterModel.extra_info];
    
    _mamaID = self.mamaCenterModel.mama_id;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[self.extraModel.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];  // 妈妈头像
    self.idLabel.text = [NSString stringWithFormat:@"ID: %@",self.mamaCenterModel.mama_id];                        // 妈妈ID
    self.isMaMaVipLabel.text = self.mamaCenterModel.mama_level_display;                                       // 妈妈的VIP状态
    self.mamaLeveLabel.text = self.extraModel.agencylevel_display;                                            // 妈妈的VIP等级
    
    NSString *carryValueStr = [NSString stringWithFormat:@"%.2f",[self.mamaCenterModel.cash_value floatValue]];
    _carryValue = [carryValueStr floatValue];                                                                           // 账户金额
    _historyEarningsRecord = [NSString stringWithFormat:@"%.2f", [self.extraModel.his_confirmed_cash_out floatValue]];  // 累计收益金额
    _activeValueNum = [NSNumber numberWithInteger:[self.mamaCenterModel.active_value_num integerValue]];                     // 活跃值
    _fansNum = [NSNumber numberWithInteger:[self.mamaCenterModel.fans_num integerValue]];                                    // 粉丝数量
    _orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];                                        // 订单记录数量
    _earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];                    // 累计收益
    _eventLink = self.mamaCenterModel.mama_event_link;                                                                  // 精选活动链接
    self.label1.text = [NSString stringWithFormat:@"%.2f元",[self.mamaCenterModel.cash_value floatValue]];                   // 我的提现
    self.label2.text = [NSString stringWithFormat:@"%.2f元",[self.mamaCenterModel.carry_value floatValue]];                  // 累计收益
    self.label3.text = @"查看访客记录";                                                                                   // 访客记录
    self.label4.text = [NSString stringWithFormat:@"%@个",self.mamaCenterModel.order_num];                                   // 订单记录
    self.label5.text = [NSString stringWithFormat:@"%@点",self.mamaCenterModel.active_value_num];                            // 活跃度
    self.label6.text = [NSString stringWithFormat:@"%@人",self.mamaCenterModel.fans_num];                                    // 我的粉丝
//    self.label7.text = @"个人排名Top10";                                                                                 // 个人收益排名
//    self.label8.text = @"我的团队排名";
//    self.label7.text = CS_DSTRING(@"我的排名:",self.extraFiguresDic[@"personal_total_rank"]);
//    self.label8.text = CS_DSTRING(@"团队排名:",self.extraFiguresDic[@"team_total_rank"]);
    
    [self.tableView reloadData];
}
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self mamaWebViewData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
// MaMaWebView跳转链接
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    resultsDict = resultsArr[0];
    NSDictionary *extraDict = resultsDict[@"extra"];
    _fansWebUrl = extraDict[@"fans_explain"];         // --> 粉丝二维码
    _teamExplainUrl = extraDict[@"team_explain"];     // --> 团队说明
    
    
}

- (void)createHeaderView {
    NSArray *imageArr = @[@"wodetixian",@"leijishouyi",@"fangkejilu",@"dingdanjilu",@"huoyuedu",@"wodefensi"]; // ,@"gerenpaiming",@"tuanduipaiming"
    NSArray *titleArr = @[@"我的提现",@"累计收益",@"访客记录",@"订单记录",@"活跃度",@"我的粉丝"]; // ,@"个人排名",@"团队排名" --> 暂时注释掉
//    NSArray *descTitleArr = @[@"888.88元",@"888.88元",@"88人访问",@"88个",@"888点",@"888人",@"第1名",@"第1名"];
    NSArray *titleDescArr = @[@"88.88元",@"88.88元",@"查看访客记录",@"88个",@"88点",@"88人"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 420)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *mineInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    mineInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:mineInfoView];
    UIImageView *iconImage = [UIImageView new];
    [mineInfoView addSubview:iconImage];
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.cornerRadius = 30.;
    self.iconImage = iconImage;
    self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    
    UILabel *idLabel = [UILabel new];
    [mineInfoView addSubview:idLabel];
    idLabel.textColor = [UIColor blackColor];
    idLabel.font = [UIFont systemFontOfSize:18.];
    idLabel.text = @"ID:666";
    self.idLabel = idLabel;
    
    UIImageView *isMaMaVipImage = [UIImageView new];
    [mineInfoView addSubview:isMaMaVipImage];
    isMaMaVipImage.backgroundColor = [UIColor clearColor];
    isMaMaVipImage.image = [UIImage imageNamed:@"mamaUser_DiamondsIcon"];
    
    UILabel *isMaMaVipLabel = [UILabel new];
    [mineInfoView addSubview:isMaMaVipLabel];
    self.isMaMaVipLabel = isMaMaVipLabel;
    isMaMaVipLabel.font = [UIFont systemFontOfSize:14.];
    isMaMaVipLabel.text = @"普通妈妈";
    
    
    UIImageView *levelImage = [UIImageView new];
    [mineInfoView addSubview:levelImage];
    levelImage.image = [UIImage imageNamed:@"mamaCrown_orangeColor"];
    
    UILabel *mamaLeveLabel = [UILabel new];
    [mineInfoView addSubview:mamaLeveLabel];
    self.mamaLeveLabel = mamaLeveLabel;
    mamaLeveLabel.font = [UIFont boldSystemFontOfSize:12.];
    mamaLeveLabel.text = @"VIP1";
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mineInfoView).offset(15);
        make.centerY.equalTo(mineInfoView.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(15);
        make.top.equalTo(iconImage).offset(5);
//        make.centerY.equalTo(iconImage.mas_centerY);
    }];
    
    [isMaMaVipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(idLabel);
//        make.centerY.equalTo(idLabel.mas_centerY);
        make.top.equalTo(idLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@12);
    }];
    [isMaMaVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isMaMaVipImage.mas_right).offset(2);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
    }];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isMaMaVipLabel.mas_right).offset(15);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@12);
    }];
    [mamaLeveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelImage.mas_right).offset(2);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
    }];
    
    UIView *selectBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREENWIDTH, 210)];
//    selectBoxView.backgroundColor = [UIColor countLabelColor];
    [headerView addSubview:selectBoxView];
    
    CGFloat buttonW = SCREENWIDTH / 2;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        button.backgroundColor = [UIColor whiteColor];
        [selectBoxView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBoxView).offset(65 * (i / 2) + (i / 4) * 15);
            make.left.equalTo(selectBoxView).offset((i % 2) * buttonW);
            make.width.mas_equalTo(@(buttonW));
            make.height.mas_equalTo(@65);
        }];
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr[i]];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(15);
//            make.width.height.mas_equalTo(@25);
            make.centerY.equalTo(button.mas_centerY);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(10);
            make.left.equalTo(iconImage.mas_right).offset(15);
        }];
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.tag = 200 + i;
        [button addSubview:detailLabel];
        detailLabel.text = titleDescArr[i];
        detailLabel.font = [UIFont systemFontOfSize:12.];
        detailLabel.textColor = [UIColor dingfanxiangqingColor];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-10);
            make.left.equalTo(titleLabel);
        }];
        
    }
    
    self.label1 = (UILabel *)[self.view viewWithTag:200];
    self.label2 = (UILabel *)[self.view viewWithTag:201];
    self.label3 = (UILabel *)[self.view viewWithTag:202];
    self.label4 = (UILabel *)[self.view viewWithTag:203];
    self.label5 = (UILabel *)[self.view viewWithTag:204];
    self.label6 = (UILabel *)[self.view viewWithTag:205];
//    self.label7 = (UILabel *)[self.view viewWithTag:206];
//    self.label8 = (UILabel *)[self.view viewWithTag:207];

    
}
/**
 *  100 --> 我的提现
 *  101 --> 累计收益
 *  102 --> 访客记录
 *  103 --> 订单记录
 *  104 --> 活跃度
 *  105 --> 我的粉丝
 *  106 --> 个人排名
 *  107 --> 团队排名
 */
- (void)mamaButtonClick:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
    NSInteger index = button.tag;
    if (index == 100) {
        JMChoiseWithDrawController *choiseVC = [[JMChoiseWithDrawController alloc] init];
        choiseVC.myBlance = _carryValue;
        [self.navigationController pushViewController:choiseVC animated:YES];
    }else if (index == 101) {
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = _earningsRecord;
        carry.historyEarningsRecord = _historyEarningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else if (index == 102) {
        TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
        today.visitorDate = kVisitorDay;
        [self.navigationController pushViewController:today animated:YES];
    }else if (index == 103) {
        MaMaOrderListViewController *orderList = [[MaMaOrderListViewController alloc] init];
        orderList.orderRecord = _orderRecord;
        [self.navigationController pushViewController:orderList animated:YES];
    }else if (index == 104) {
        MaMaHuoyueduViewController *VC = [[MaMaHuoyueduViewController alloc] init];
        VC.activeValueNum = _activeValueNum;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 105) {
        JMMaMaCenterFansController *mamaCenterFansVC = [[JMMaMaCenterFansController alloc] init];
        mamaCenterFansVC.fansNum = _fansNum;
        mamaCenterFansVC.fansUrlStr = _fansWebUrl;
        mamaCenterFansVC.index = 100;
        [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
    }
//    else if (index == 106) {
//        JMMaMaEarningsRankController *earningsRankVC = [[JMMaMaEarningsRankController alloc] init];
//        earningsRankVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/self_rank",Root_URL];
//        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank", nil];
//        earningsRankVC.urlArray = array;
//        earningsRankVC.isTeamEarningsRank = NO;
//        earningsRankVC.selectIndex = 1;
//        [self.navigationController pushViewController:earningsRankVC animated:YES];
//    }else if (index == 107) {
//        JMMaMaTeamController *teamVC = [[JMMaMaTeamController alloc] init];
//        teamVC.mamaID = _mamaID;
//        teamVC.explainUrl = _teamExplainUrl;
//        [self.navigationController pushViewController:teamVC animated:YES];
//    }else if (index == 108) {
//        JMVipRenewController *renewVC = [[JMVipRenewController alloc] init];
//        renewVC.cashValue = _carryValue;
//        [self.navigationController pushViewController:renewVC animated:YES];
//    }
    else { }
  
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end























































































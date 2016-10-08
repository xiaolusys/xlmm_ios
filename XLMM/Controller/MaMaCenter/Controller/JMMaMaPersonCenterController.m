//
//  JMMaMaPersonCenterController.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaPersonCenterController.h"
#import "MMClass.h"
#import "JMMaMaCenterHeaderView.h"
#import "JMMaMaCenterModel.h"
#import "JMMaMaExtraModel.h"
#import "JMMaMaCenterFooterView.h"
#import "ProductSelectionListViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaClassifyCarryLogViewController.h"
#import "ShopPreviousViewController.h"
#import "PublishNewPdtViewController.h"
#import "WebViewController.h"
#import "JMMaMaCenterFansController.h"
#import "TodayVisitorViewController.h"
#import "JMMaMaTeamController.h"
#import "JMVipRenewController.h"
#import "TixianViewController.h"
#import "MaMaHuoyueduViewController.h"
#import "JMMaMaEarningsRankController.h"
#import "JMWithdrawShortController.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "JMNewcomerTaskController.h"
#import "JMPopViewAnimationSpring.h"
#import "Udesk.h"
#import "JMServiceEnterController.h"
#import "JMRewardsController.h"


static NSUInteger popNum = 0;


@interface JMMaMaPersonCenterController ()<JMNewcomerTaskControllerDelegate,JMShareViewDelegate,UITableViewDelegate,UITableViewDataSource,JMMaMaCenterFooterViewDelegate,JMMaMaCenterHeaderViewDelegate> {
    NSInteger _indexCode;
}



@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMMaMaCenterHeaderView *mamaCenterHeaderView;
@property (nonatomic, strong) JMMaMaCenterFooterView *mamaCenterFooterView;
/**
 *  字典中存储在webView中使用的值
 */
@property (nonatomic,strong) NSMutableDictionary *diction;
/**
 *  妈妈中心数据源
 */
@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
/**
 *  妈妈中心额外数据源
 */
@property (nonatomic, strong) JMMaMaExtraModel *extraModel;


@property (nonatomic, assign) CGFloat carryValue;
@property (nonatomic, strong)NSNumber *activeValueNum;
@property (nonatomic, strong)NSNumber *fansNum;             // 我的粉丝
@property (nonatomic, strong)NSNumber *visitorDate;         // 今日访客
//下拉的标志
@property (nonatomic) BOOL isPullDown;
/**
 *  订单记录,收益记录,2016.3.24号系统升级之前的收益,我的邀请,MaMa等级考试入口,关于粉丝入口,精品活动入口,续费入口,妈妈消息滚动视图,论坛,团队说明
 */
@property (nonatomic, copy) NSString *orderRecord;
@property (nonatomic, copy) NSString *earningsRecord;
@property (nonatomic, copy) NSString *historyEarningsRecord;
@property (nonatomic, copy) NSString *myInvitation;
@property (nonatomic, copy) NSString *examWebUrl;
@property (nonatomic, copy) NSString *fansWebUrl;
@property (nonatomic, copy) NSString *boutiqueActiveWebUrl;
@property (nonatomic, copy) NSString *renewWebUrl;
@property (nonatomic, copy) NSString *eventLink;
@property (nonatomic, copy) NSString *messageUrl;
@property (nonatomic, copy) NSString *bbsUrl;
@property (nonatomic, copy) NSString *teamExplainUrl;

@property (nonatomic, strong) JMNewcomerTaskController *newcomerTask;

@property (nonatomic, strong) JMShareView *cover;
@property (nonatomic, strong) JMPopView *menu;
/**
 *  MaMa客服入口
 */
@property (nonatomic, strong) UIButton *serViceButton;
/**
 *  最近订单收益的20条信息
 */
@property (nonatomic, strong) NSMutableArray *earningArray;
@property (nonatomic, strong) NSMutableArray *earningImageArray;
@end


@implementation JMMaMaPersonCenterController {
    NSString *_mamaID;
    
    
}
- (NSMutableArray *)earningArray {
    if (_earningArray == nil) {
        _earningArray = [NSMutableArray array];
    }
    return _earningArray;
}
- (NSMutableArray *)earningImageArray {
    if (_earningImageArray == nil) {
        _earningImageArray = [NSMutableArray array];
    }
    return _earningImageArray;
}
- (JMNewcomerTaskController *)newcomerTask {
    if (_newcomerTask == nil) {
        _newcomerTask = [[JMNewcomerTaskController alloc] init];
        _newcomerTask.delegate = self;
    }
    return _newcomerTask;
}
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _indexCode = 0;
    [MobClick beginLogPageView:@"JMMaMaPersonCenterController"];
    [self loadDataSource];
    [self loadMaMaMessage];
    [self loadEarningMessage];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMMaMaPersonCenterController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:@selector(backClick:)];
    _indexCode = 0;
    [self createTableView];
    [self createHeaderView];
    [self createFooterView];
    [self craeteNavRightButton];
    [self loadfoldLineData];
    [self loadMaMaWeb];
    [self customUserInfo];
}
- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            [self updateMaMaHome:responseObject];
            [self.tableView reloadData];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
//新接口数据
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortuneDic = dic[@"mama_fortune"];
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    NSDictionary *extraDic = self.mamaCenterModel.extra_info;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:extraDic];
    
    _mamaID = self.mamaCenterModel.mama_id;
    
    self.mamaCenterHeaderView.mamaCenterModel = self.mamaCenterModel;
    self.mamaCenterFooterView.mamaCenterModel = self.mamaCenterModel;
    
    // 账户金额
    NSString *carryValueStr = [NSString stringWithFormat:@"%.2f",[self.mamaCenterModel.cash_value floatValue]];
    self.carryValue = [carryValueStr floatValue];
    self.activeValueNum = [NSNumber numberWithInteger:[self.mamaCenterModel.active_value_num integerValue]];
    self.fansNum = [NSNumber numberWithInteger:[self.mamaCenterModel.fans_num integerValue]];
    self.orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];
    self.earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];
    self.historyEarningsRecord = [NSString stringWithFormat:@"%.2f", [self.extraModel.his_confirmed_cash_out floatValue]];
    //精选活动链接
    self.eventLink = self.mamaCenterModel.mama_event_link;
    
    if (popNum < 1) {
        [self newcomerTaskData:_mamaID];
    }
    popNum ++;
    
}
- (void)newcomerTaskData:(NSString *)mamaID {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/%@/new_mama_task_info",Root_URL,mamaID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self newcomerData:responseObject];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
    } Progress:^(float progress) {
        
    }];
    
}
- (void)newcomerData:(NSDictionary *)newcomerDic {
    NSDictionary *configDic = newcomerDic[@"config"];
    BOOL isPOP = [configDic[@"page_pop"] boolValue];
    if (isPOP) {
        JMShareView *cover = [JMShareView show];
        self.cover = cover;
        cover.delegate = self;
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, 0, SCREENWIDTH * 0.9, SCREENWIDTH * 1.35)];
        self.menu = menu;
        menu.contentView = self.newcomerTask.view;
        self.newcomerTask.newsTaskArr = newcomerDic[@"data"];
        [JMPopViewAnimationSpring showView:menu overlayView:cover];
    }else {
    }
}
- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:chartUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.mamaCenterHeaderView.mamaResults = arr;
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            [self mamaWebViewData:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMaMaMessage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mama/message/self_list",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self mamaMesageData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)loadEarningMessage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/ordercarry/get_latest_order_carry",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self.earningArray removeAllObjects];
        [self.earningImageArray removeAllObjects];
        [self fetchEarning:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchEarning:(NSArray *)array {
    if (array.count == 0) {
        return ;
    }
    for (NSDictionary *dic in array) {
        [self.earningArray addObject:dic[@"content"]];
        [self.earningImageArray addObject:dic[@"avatar"]];
    }
    [self earningPrompt];
}
// MaMaWebView跳转链接
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    for (NSDictionary *dic in resultsArr) {
        resultsDict = dic;
    }
    NSDictionary *extraDict = resultsDict[@"extra"];
    
    self.myInvitation = extraDict[@"invite"];             // --> 我的邀请
    self.examWebUrl = extraDict[@"exam"];                 // --> 等级考试
    self.fansWebUrl = extraDict[@"fans_explain"];         // --> 粉丝二维码
    self.boutiqueActiveWebUrl = extraDict[@"act_info"];   // --> 精品活动
    self.renewWebUrl = extraDict[@"renew"];               // --> 续费
    self.messageUrl = extraDict[@"notice"];               // --> 小鹿妈妈消息
    self.bbsUrl = extraDict[@"forum"];                    // --> 论坛入口
    self.teamExplainUrl = extraDict[@"team_explain"];     // --> 团队说明
    
    NSDictionary *picturesDic = extraDict[@"pictures"];
    self.mamaCenterHeaderView.imageString = picturesDic[@"exam_pic"];
    
}
- (void)mamaMesageData:(NSDictionary *)messageDic {
    self.mamaCenterFooterView.messageDic = messageDic;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor countLabelColor];
}
- (void)createHeaderView {
    JMMaMaCenterHeaderView *mamaCenterHeaderView = [JMMaMaCenterHeaderView enterHeaderView];;
    self.mamaCenterHeaderView = mamaCenterHeaderView;
    self.tableView.tableHeaderView = self.mamaCenterHeaderView;
    self.mamaCenterHeaderView.delegate = self;
    
}
- (void)createFooterView {
    JMMaMaCenterFooterView *mamaCenterFooterView = [JMMaMaCenterFooterView enterFooterView];
    self.mamaCenterFooterView = mamaCenterFooterView;
    self.tableView.tableFooterView = self.mamaCenterFooterView;
    self.mamaCenterFooterView.delegate = self;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"mamaCenter";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/*
 100 == > 账户余额(点击后进入提现界面)
 101 == > 累计收益
 102 == > 活跃度
 103 == > 访客
 104 == > 订单
 105 == > 收益
 106 == > 考试
 107 == > 续费
 */
- (void)composeMaMaCenterHeaderView:(JMMaMaCenterHeaderView *)headerView Index:(NSInteger)index VisitorDay:(NSNumber *)visitorNum {
    if (index == 100) {
        NSLog(@"100 == > 账户余额");
        NSInteger code = [self.extraModel.could_cash_out integerValue]; // 1.提现 0.兑换优惠券
        if (code == 1) {
            TixianViewController *vc = [[TixianViewController alloc] init];
            vc.cantixianjine = self.carryValue;
            vc.activeValue = [self.activeValueNum integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            JMWithdrawShortController *shortVC = [[JMWithdrawShortController alloc] init];
            shortVC.myBalance = self.carryValue;
            shortVC.descStr = self.extraModel.cashout_reason;
            [self.navigationController pushViewController:shortVC animated:YES];
        }
    }else if (index == 101) {
        NSLog(@"101 == > 累计收益");
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = self.earningsRecord;
        carry.historyEarningsRecord = self.historyEarningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else if (index == 102) {
        NSLog(@"102 == > 活跃度");
        MaMaHuoyueduViewController *VC = [[MaMaHuoyueduViewController alloc] init];
        VC.activeValueNum = self.activeValueNum;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 103) {
        NSLog(@"103 == > 访客");
        TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
        today.visitorDate = visitorNum;
        [self.navigationController pushViewController:today animated:YES];
    }else if (index == 104) {
        NSLog(@"104 == > 订单");
        MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
        order.orderRecord = self.orderRecord;
        [self.navigationController pushViewController:order animated:YES];
    }else if (index == 105) {
        NSLog(@"105 == > 收益");
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = self.earningsRecord;
        carry.historyEarningsRecord = self.historyEarningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else if (index == 106) {
        NSLog(@"106 == > 考试");
        WebViewController *webVC = [[WebViewController alloc] init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.examWebUrl forKey:@"web_url"];
        webVC.webDiction = dict;
        webVC.isShowNavBar = true;
        webVC.isShowRightShareBtn = false;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (index == 107) {
        JMVipRenewController *renewVC = [[JMVipRenewController alloc] init];
        renewVC.cashValue = self.carryValue;
        [self.navigationController pushViewController:renewVC animated:YES];
    }else { }
}
/*
 100 === > 小鹿大学(精品活动)
 101 === > 订单记录
 102 === > 收益记录
 103 === > 我的店铺
 104 === > 每日推送
 105 === > 邀请一元开店
 106 === > 选品上架
 107 === > 小鹿大学(精品活动)
 108 === > 我的粉丝
 109 === > 我的团队
 110 === > 收益排行
 111 === > 论坛
 112 === > 任务奖励
 */
- (void)composeMaMaCenterFooterView:(JMMaMaCenterFooterView *)footerView Index:(NSInteger)index {
    // index == 100 || 
    if (index == 107) {
        [self xiaoluUniversity];
    }else if (index == 101) {
        MaMaOrderListViewController *orderList = [[MaMaOrderListViewController alloc] init];
        orderList.orderRecord = self.orderRecord;
        [self.navigationController pushViewController:orderList animated:YES];
    }else if (index == 102) {
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = self.earningsRecord;
        carry.historyEarningsRecord = self.historyEarningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else if (index == 103) {
        ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
        [self.navigationController pushViewController:previous animated:YES];
    }else if (index == 104) {
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [self.navigationController pushViewController:publish animated:YES];
    }else if (index == 105) {
        if ([NSString isStringEmpty:self.myInvitation]) return;
        WebViewController *activity = [[WebViewController alloc] init];
        NSString *active = @"myInvite";
        NSString *titleName = @"我的邀请";
        [self.diction setValue:@38 forKey:@"activity_id"];
        [self.diction setValue:self.myInvitation forKey:@"web_url"];
        [self.diction setValue:active forKey:@"type_title"];
        [self.diction setValue:titleName forKey:@"name_title"];
        activity.webDiction = _diction;
        activity.isShowNavBar = true;
        activity.isShowRightShareBtn = true;
        [self.navigationController pushViewController:activity animated:YES];
    }else if (index == 106) {
        ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
        [self.navigationController pushViewController:product animated:YES];
    }else if (index == 108) {
        JMMaMaCenterFansController *mamaCenterFansVC = [[JMMaMaCenterFansController alloc] init];
        mamaCenterFansVC.fansNum = self.fansNum;
        mamaCenterFansVC.fansUrlStr = self.fansWebUrl;
        [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
    }else if (index == 109) {
        JMMaMaTeamController *teamVC = [[JMMaMaTeamController alloc] init];
        teamVC.mamaID = _mamaID;
        teamVC.explainUrl = self.teamExplainUrl;
        [self.navigationController pushViewController:teamVC animated:YES];
    }else if (index == 110) {
        JMMaMaEarningsRankController *earningsRankVC = [[JMMaMaEarningsRankController alloc] init];
        earningsRankVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/self_rank",Root_URL];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank", nil];
        earningsRankVC.urlArray = array;
        earningsRankVC.isTeamEarningsRank = NO;
        [self.navigationController pushViewController:earningsRankVC animated:YES];
    }else if (index == 111) {
        [MobClick event:@"BBS"];
//        NSString *urlString = @"http://192.168.1.8:8888/accounts/xlmm/login/";
        WebViewController *webVC = [[WebViewController alloc] init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.bbsUrl forKey:@"web_url"];
        webVC.webDiction = dict;
        webVC.isShowNavBar = true;
        webVC.isShowRightShareBtn = false;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (index == 112) {
        JMRewardsController *rewardsVC = [[JMRewardsController alloc] init];
        [self.navigationController pushViewController:rewardsVC animated:YES];
    }else { }
}
- (void)coverDidClickCover:(JMShareView *)cover {
    [JMPopViewAnimationSpring dismissView:self.menu overlayView:self.cover];
    [JMPopView hide];
}
#pragma mark MaMa新手任务弹出框
- (void)composeNewcomerTask:(JMNewcomerTaskController *)taskVC Index:(NSInteger)index {
    if (index == 100) {
        [JMPopViewAnimationSpring dismissView:self.menu overlayView:self.cover];
        [JMPopView hide];
    }else if (index == 101) {
        [JMPopViewAnimationSpring dismissView:self.menu overlayView:self.cover];
        [JMPopView hide];
        [self xiaoluUniversity];
    }else { }
}
#pragma mark 妈妈消息列表点击事件
- (void)composeFooterViewScrollView:(JMMaMaCenterFooterView *)footerView Index:(NSInteger)index {
    WebViewController *message = [[WebViewController alloc] init];
    [self.diction setValue:self.messageUrl forKey:@"web_url"];
    [self.diction setValue:@"MaMaMessage" forKey:@"type_title"];
    message.webDiction = _diction;//[NSMutableDictionary dictionaryWithDictionary:_diction];
    message.isShowNavBar = true;
    message.isShowRightShareBtn = false;
    [self.navigationController pushViewController:message animated:YES];
}
- (void)xiaoluUniversity {
    if (self.boutiqueActiveWebUrl == nil || self.boutiqueActiveWebUrl.length == 0) {
        [MBProgressHUD showMessage:@"活动还未开始"];
        return;
    }
    WebViewController *activity = [[WebViewController alloc] init];
    //    _diction = nil;
    NSString *active = @"myInvite";
    NSString *titleName = @"精品活动";
    [self.diction setValue:self.boutiqueActiveWebUrl forKey:@"web_url"];
    [self.diction setValue:active forKey:@"type_title"];
    [self.diction setValue:titleName forKey:@"name_title"];
    activity.webDiction = _diction;//[NSMutableDictionary dictionaryWithDictionary:_diction];
    activity.isShowNavBar = true;
    activity.isShowRightShareBtn = true;
    activity.share_model.share_link = self.boutiqueActiveWebUrl;
    activity.share_model.title = @"精品活动";
    activity.share_model.desc = @"更多精选活动,尽在小鹿美美~~";
    activity.share_model.share_img = @"http://7xogkj.com2.z0.glb.qiniucdn.com/1181123466.jpg";
    activity.share_model.share_type = @"link";
    [self.navigationController pushViewController:activity animated:YES];
}
- (void)craeteNavRightButton {
    UIButton *serViceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [serViceButton addTarget:self action:@selector(serViceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *serviceImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    [serViceButton addSubview:serviceImage];
    serviceImage.image = [UIImage imageNamed:@"serviceEnter"];
    self.serViceButton = serViceButton;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:serViceButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)serViceButtonClick:(UIButton *)button {
    [MobClick event:@"MaMa_service"];
//    JMServiceEnterController *enterVC = [[JMServiceEnterController alloc] init];
//    [self.navigationController pushViewController:enterVC animated:YES];
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
    
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
    
//    UdeskRobotIMViewController *robot = [[UdeskRobotIMViewController alloc] init];
//    [self.navigationController pushViewController:robot animated:YES];
    
//    UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
//    [self.navigationController pushViewController:chat animated:YES];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
- (void)customUserInfo {
    if (self.userInfoDic.count == 0) {
        return ;
    }
    NSString *nick_name = self.userInfoDic[@"nick"];
    NSString *sdk_token = self.userInfoDic[@"user_id"];
//    NSString *cellphone = self.userInfoDic[@"mobile"];
    NSDictionary *parameters = @{
                                 @"user": @{
                                         @"sdk_token":sdk_token,
                                         @"nick_name":nick_name,
                                         }
                                 };
    [UdeskManager createCustomerWithCustomerInfo:parameters];
    if (nick_name.length == 0 || sdk_token.length == 0) {
        self.serViceButton.hidden = YES;
    }else {
        self.serViceButton.hidden = NO;
    }
}
- (void)showNewStatusCount:(NSArray *)message Image:(NSArray *)imageArr Index:(NSInteger)index {
    if (message.count == 0) {
        return ;
    }
    CGFloat h = 40.;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 20;
    CGFloat x = 10;
    CGFloat w = SCREENWIDTH;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w - 50, h)];
    view.layer.cornerRadius = 20;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
//    [self.navigationController.view insertSubview:view belowSubview:self.navigationController.navigationBar];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.70f;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, 30, 30)];
    image.layer.cornerRadius = 15;
    image.layer.masksToBounds = YES;
    [view addSubview:image];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, w - 105, h)];
    [view addSubview:label6];
    label6.font = [UIFont systemFontOfSize:13.];
    label6.textColor = [UIColor whiteColor];
    label6.text = message[index];

    [image sd_setImageWithURL:[NSURL URLWithString:[[imageArr[index] JMUrlEncodedString] imageMoreCompression]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [UIView animateWithDuration:1.0 animations:^{
//        view.transform = CGAffineTransformMakeTranslation(0, h * 2);
        view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
//            view.transform = CGAffineTransformIdentity;
            view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            _indexCode ++;
            int x = arc4random() % 5 + 5;
            [self performSelector:@selector(waitTimer) withObject:nil afterDelay:x];
            
        }];
    }];
}
//- (void)SubscribeMes:(NSNotification *)sender {
//    [self showNewStatusCount:sender.object];
//}
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
/**
 *  收益信息提示
 }
 */
- (void)earningPrompt {
    [self performSelector:@selector(waitTimer) withObject:nil afterDelay:3.0];
}
- (void)waitTimer {
    UIViewController *controller = [self.navigationController.viewControllers lastObject];
    NSLog(@"controller ==== %@",self.navigationController.viewControllers);
    if ([controller isKindOfClass:[JMMaMaPersonCenterController class]]) {
        NSLog(@"controller ==== %@",controller);
        NSLog(@"_indexCode ==== %ld",_indexCode);
        if (_indexCode >= (self.earningArray.count - 1)) {
            _indexCode = 0;
        }
        [self showNewStatusCount:self.earningArray Image:self.earningImageArray Index:_indexCode];
        
    }
    
}
- (void)backClick:(UIButton *)btn {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitTimer) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.navigationController popViewControllerAnimated:YES];
}



@end



























































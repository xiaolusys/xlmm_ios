//
//  JMMaMaHomeController.m
//  XLMM
//
//  Created by zhang on 16/11/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaHomeController.h"
#import "JMHomeActiveCell.h"
#import "JMHomeActiveModel.h"
#import "WebViewController.h"
#import "JumpUtils.h"
#import "JMMaMaHomeHeaderView.h"
#import "JMMaMaCenterModel.h"
#import "Udesk.h"
#import "JMStoreManager.h"
#import "JMRewardsController.h"
#import "ProductSelectionListViewController.h"
#import "JMVipRenewController.h"
#import "TodayVisitorViewController.h"
#import "MaMaOrderListViewController.h"
#import "JMRootTabBarController.h"
#import "JMWithdrawShortController.h"
#import "TodayVisitorViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaMaHuoyueduViewController.h"
#import "JMChoiseWithDrawController.h"
#import "JMLogInViewController.h"
#import "JMSettingController.h"
#import "Account1ViewController.h"
#import "WebViewController.h"
#import "JMMineIntegralController.h"
#import "JMCouponController.h"
#import "JMRefundBaseController.h"
#import "JMMaMaFansController.h"
#import "JMOrderListController.h"
#import "JMEarningListController.h"
#import "JMPushingDaysController.h"
#import "JMTotalEarningController.h"


@interface JMMaMaHomeController () <UITableViewDataSource,UITableViewDelegate,JMMaMaHomeHeaderViewDelegte> {
    NSString *_orderRecord;             // 订单记录
    NSString *_earningsRecord;          // 收益记录
    NSString *_historyEarningsRecord;   // 历史收益记录
    NSString *_myInvitation;            // 邀请开店
    NSString *_boutiqueString;          // 精品汇
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
//    NSString *_mamaNotReadNotice;       // 未读消息
    CGFloat _carryValue;              // 账户金额
    NSNumber *_activeValueNum;        // 活跃值
    NSNumber *_fansNum;               // 我的粉丝
    NSNumber *_visitorDate;           // 今日访客
    NSString *_eventLink;             // 精选活动链接
    NSString *_examWebUrl;            // 等级考试入口
    NSString *_fansWebUrl;            // 关于粉丝入口
    NSString *_boutiqueActiveWebUrl;  // 精品活动入口
    NSString *_renewWebUrl;           // 续费
    NSString *_messageUrl;            // 消息滚动视图
    NSString *_bbsUrl;                // 论坛
    NSString *_teamExplainUrl;        // 团队排行说明
    NSDictionary *_persinCenterDict;
    NSNumber *_accountMoney;
    
    BOOL isShowRefresh;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *activeArray;
@property (nonatomic, strong) JMMaMaHomeHeaderView *homeHeaderView;
@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
/**
 *  MaMa客服入口
 */
@property (nonatomic, strong) UIButton *serViceButton;

/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
@property (nonatomic, strong) NSTimer *messageTimer;

@end

@implementation JMMaMaHomeController

#pragma mark  -- 懒加载
- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}

#pragma mark -- 视图生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMMaMaHomeController"];
    if (isShowRefresh) {
        isShowRefresh = NO;
        [self refresh];
    }else {
        [self setUserInfo];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMMaMaHomeController"];
    if (self.homeHeaderView.pageView) {
        [self.homeHeaderView.pageView endAutoScroll];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel:) name:@"drawCashMoeny" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitLogin) name:@"logout" object:nil];
    
    _qrCodeRequestDataIndex = 0;
    isShowRefresh = YES;
    [self createTableView];
    [self createPullHeaderRefresh];
    [self loaderweimaData];
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf setUserInfo];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark -- 通知事件处理
- (void)updataAfterLogin:(NSNotification *)notification{
    [self refresh];
}
- (void)updateMoneyLabel:(NSNotification *)center {
    [self refresh];
}
- (void)phoneNumberLogin:(NSNotification *)notification{
    [self refresh];
}
- (void)quitLogin {
    self.navigationItem.rightBarButtonItem = nil;
    self.homeHeaderView.userInfoDic = nil;
}

#pragma mark 对外提供的接口
- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 网络请求,数据处理
// ========== 妈妈页面通知滚动请求 ==========
- (void)loadMaMaMessage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mama/message/self_list",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.homeHeaderView.messageDic = responseObject;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
// ========== 妈妈页面web链接请求 ==========
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self mamaWebViewData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    resultsDict = resultsArr[0];
    NSDictionary *dict = resultsDict[@"extra"];
    _myInvitation = dict[@"invite"];
    _boutiqueString = dict[@"boutique"];
    _fansWebUrl = dict[@"fans_explain"];
    self.homeHeaderView.mamaNotReadNotice = dict[@"notice"];
}
// ========== 妈妈页面主数据请求 ==========
- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) return;
        [self updateMaMaHome:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortuneDic = dic[@"mama_fortune"];
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    self.homeHeaderView.centerModel = self.mamaCenterModel;
    NSDictionary *exDic = self.mamaCenterModel.extra_info;
    NSString *carryValueStr = [NSString stringWithFormat:@"%.2f",[self.mamaCenterModel.cash_value floatValue]];
    _carryValue = [carryValueStr floatValue];
    _orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];
    _earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];
    _historyEarningsRecord = [NSString stringWithFormat:@"%.2f", [exDic[@"his_confirmed_cash_out"] floatValue]];
    _activeValueNum = [NSNumber numberWithInteger:[self.mamaCenterModel.active_value_num integerValue]];                     // 活跃值
    _fansNum = [NSNumber numberWithInteger:[self.mamaCenterModel.fans_num integerValue]];                                    // 粉丝数量
    _orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];                                        // 订单记录数量
    _earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];                    // 累计收益
    _eventLink = self.mamaCenterModel.mama_event_link;                                                                  // 精选活动链接
}
// 折线图数据请求
- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:chartUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.homeHeaderView.mamaResults = arr;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
// 二维码数据请求
- (void)loaderweimaData {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/qrcode/get_wxpub_qrcode");
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (![responseObject[@"qrcode_link"] isKindOfClass:[NSString class]]) {
            return ;
        }
        if (code == 0) {
            [JMStoreManager removeFileByFileName:@"qrCodeUrlString.txt"];
            [JMStoreManager saveDataFromString:@"qrCodeUrlString.txt" WithString:responseObject[@"qrcode_link"]];
        }else {
        }
    } WithFail:^(NSError *error) {
        _qrCodeRequestDataIndex ++;
        if (_qrCodeRequestDataIndex <= 3) {
            [self performSelector:@selector(loaderweimaData) withObject:nil afterDelay:1.0];
        }
    } Progress:^(float progress) {
    }];
}
// 个人信息请求
- (void)setUserInfo{
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        if ([self isLogin]) {
            [self updateUserInfo:responseObject];
        }else {
            [self quitLogin];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        [self quitLogin];
        [self endRefresh];
        
    }];
}
- (void)updateUserInfo:(NSDictionary *)dic {
    if ([self isXiaolumama]) {
        [self loadMaMaWeb];
        [self loadDataSource];
        [self loadMaMaMessage];
        [self loadfoldLineData];
        [self craeteNavRightButton];
        [self customUserInfo];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
        [self endRefresh];
    }
    _persinCenterDict = dic;
    //判断是否为0
    if ([[dic objectForKey:@"user_budget"] isKindOfClass:[NSNull class]]) {
        _accountMoney = [NSNumber numberWithFloat:0.00];
    }else {
        NSDictionary *xiaolumeimei = [dic objectForKey:@"user_budget"];
        NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
        _accountMoney = num;
    }
    self.homeHeaderView.userInfoDic = dic;
}
- (BOOL)isXiaolumama{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isXLMM = [users boolForKey:kISXLMM];
    return isXLMM;
}
- (BOOL)isLogin {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isLog = [users boolForKey:kIsLogin];
    return isLog;
}


#pragma ========== UI处理 ==========
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - ktabBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 在这里创建headerView
    self.homeHeaderView = [[JMMaMaHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 600 + SCREENWIDTH / 4)];
    self.homeHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.homeHeaderView;
    [self headerClick];
}
- (void)craeteNavRightButton {
    UIButton *serViceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    [serViceButton addTarget:self action:@selector(serViceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [serViceButton setTitle:@"小鹿客服" forState:UIControlStateNormal];
    [serViceButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    serViceButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    //    UIImageView *serviceImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    //    [serViceButton addSubview:serviceImage];
    //    serviceImage.image = [UIImage imageNamed:@"serviceEnter"];
    self.serViceButton = serViceButton;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:serViceButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 点击事件处理 --
- (void)serViceButtonClick:(UIButton *)button {
    [MobClick event:@"MaMa_service"];
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:1.0f];
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}

#pragma mark == UITableView 代理实现 ==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.activeArray.count;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
    if (!cell) {
        cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.activeArray[indexPath.row];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    JMHomeActiveModel *model = self.activeArray[indexPath.row];
//    [self skipWebView:model.act_applink activeDic:model];
//}

#pragma mark 点击事件处理(跳转webView)  // https://m.xiaolumeimei.com/mall/activity/exam
- (void)skipWebView:(NSString *)appLink activeDic:(JMHomeActiveModel *)model {
    if(appLink.length == 0){
        WebViewController *huodongVC = [[WebViewController alloc] init];
        NSMutableDictionary *webDic = [NSMutableDictionary dictionary];
        NSString *active = @"active";
        [webDic setValue:active forKey:@"type_title"];
        [webDic setValue:model.activeID forKey:@"activity_id"];
        [webDic setValue:model.act_link forKey:@"web_url"];
        huodongVC.webDiction = webDic;
        huodongVC.isShowNavBar = true;
        huodongVC.isShowRightShareBtn = true;
        huodongVC.titleName = model.title;
        [self.navigationController pushViewController:huodongVC animated:YES];
    }else{
        [JumpUtils jumpToLocation:appLink viewController:self];
    }
}
/**
 *  100 --> 登录
 *  101 --> 零钱
 *  102 --> 小鹿币
 *  103 --> 优惠券
 *  104 --> 待支付
 *  105 --> 待收货
 *  106 --> 退换货
 *  107 --> 全部订单
 *  108 --> 折线图 -- > 访客
 *  109 --> 折线图 -- > 订单
 *  110 --> 折线图 -- > 收益
 *  111 --> 分享店铺
 *  112 --> 每日推送
 *  113 --> 选品佣金
 *  114 --> 邀请开店
 *  115 --> 累计收益
 *  116 --> 访客记录
 *  117 --> 订单记录
 *  118 --> 我的粉丝
 */
- (void)composeHomeHeader:(JMMaMaHomeHeaderView *)headerView ButtonActionClick:(UIButton *)button {
    NSInteger index = button.tag;
    BOOL isLogin = [self isLogin];
    switch (index) {
        case 100:
            if (isLogin) {
                JMSettingController *addressVC = [[JMSettingController alloc] init];
                addressVC.userInfoDict = _persinCenterDict;
                [self.navigationController pushViewController:addressVC animated:YES];
            }else{
                [self displayLoginView];
            }
            break;
        case 101:
            if (isLogin) {
                Account1ViewController *account = [[Account1ViewController alloc] init];
                account.accountMoney = _accountMoney;
                account.personCenterDict = _persinCenterDict;
                [self.navigationController pushViewController:account animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 102:
            if (isLogin) {
                JMMineIntegralController *jifenVC = [[JMMineIntegralController alloc] init];
                jifenVC.xiaoluCoin = _persinCenterDict[@"xiaolu_coin"];
                [self.navigationController pushViewController:jifenVC animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            
            break;
        case 103:
            if (isLogin) {
                JMCouponController *couponVC = [[JMCouponController alloc] init];
                [self.navigationController pushViewController:couponVC animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 104:
            if (isLogin) {
                JMOrderListController *order = [[JMOrderListController alloc] init];
                order.currentIndex = 1;
                order.ispopToView = YES;
                [self.navigationController pushViewController:order animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 105:
            if (isLogin) {
                JMOrderListController *order = [[JMOrderListController alloc] init];
                order.currentIndex = 2;
                order.ispopToView = YES;
                [self.navigationController pushViewController:order animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 106:
            if (isLogin) {
                JMRefundBaseController *refundVC = [[JMRefundBaseController alloc] init];
                [self.navigationController pushViewController:refundVC animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 107:
            if (isLogin) {
                JMOrderListController *order = [[JMOrderListController alloc] init];
                order.currentIndex = 0;
                order.ispopToView = YES;
                [self.navigationController pushViewController:order animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        case 108:
        {
            TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
            today.visitorDate = kVisitorDay;
            [self.navigationController pushViewController:today animated:YES];
        }
            break;
        case 109:
        {
            MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
            order.orderRecord = _orderRecord;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case 110:
        {
            JMEarningListController *carry = [[JMEarningListController alloc] init];
//            carry.earningsRecord = _earningsRecord;
//            carry.historyEarningsRecord = _historyEarningsRecord;
            [self.navigationController pushViewController:carry animated:YES];
        }
            break;
        case 111:
        {
            NSString *urlString = [NSString stringWithFormat:@"%@/mall/?mm_linkid=%@",Root_URL,self.mamaCenterModel.mama_id];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:urlString forKey:@"web_url"];
            [dict setValue:@"mamaShop" forKey:@"type_title"];
            [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:YES Title:nil];
        }
            break;
        case 112:
        {
            JMPushingDaysController *pushingVC = [[JMPushingDaysController alloc] init];
            [self.navigationController pushViewController:pushingVC animated:YES];
        }
            break;
        case 113:
        {
            ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
            break;
        case 114:
        {
            if ([NSString isStringEmpty:_myInvitation]) return;
            NSString *active = @"myInvite";
            NSString *titleName = @"我的邀请";
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:@38 forKey:@"activity_id"];
            [dict setValue:_myInvitation forKey:@"web_url"];
            [dict setValue:active forKey:@"type_title"];
            [dict setValue:titleName forKey:@"name_title"];
            [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:YES Title:nil];
        }
            break;
        case 115:
        {
            JMTotalEarningController *carry = [[JMTotalEarningController alloc] init];
            carry.earningsRecord = _earningsRecord;
            carry.historyEarningsRecord = _historyEarningsRecord;
            [self.navigationController pushViewController:carry animated:YES];
        }
            break;
        case 116:
        {
            TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
            today.visitorDate = kVisitorDay;
            [self.navigationController pushViewController:today animated:YES];
        }
            break;
        case 117:
        {
            MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
            order.orderRecord = _orderRecord;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case 118:
        {
            JMMaMaFansController *mamaCenterFansVC = [[JMMaMaFansController alloc] init];
            mamaCenterFansVC.aboutFansUrl = _fansWebUrl;
            [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)displayLoginView{
    JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}


- (void)headerClick {
    kWeakSelf
    self.homeHeaderView.loopPageBlock = ^(JMAutoLoopPageView *loopPageView, NSMutableDictionary *dic) {
        [weakSelf pushWebView:dic ShowNavBar:YES ShowRightShareBar:NO Title:@"消息通知"];
    };
}
- (void)pushWebView:(NSMutableDictionary *)dict ShowNavBar:(BOOL)isShowNavBar ShowRightShareBar:(BOOL)isShowRightShareBar Title:(NSString *)title {
    WebViewController *activity = [[WebViewController alloc] init];
    if (title != nil) {
        activity.titleName = title;
    }
    activity.webDiction = dict;
    activity.isShowNavBar = isShowNavBar;
    activity.isShowRightShareBtn = isShowRightShareBar;
    [self.navigationController pushViewController:activity animated:YES];
}
#pragma mark - 小鹿客服注册个人信息
- (void)customUserInfo {
    NSDictionary *userInfo = [JMStoreManager getDataDictionary:@"usersInfo.plist"];
    if (userInfo == nil) {
        return ;
    }
    NSString *nick_name = userInfo[@"nick"];
    NSString *sdk_token = [NSString stringWithFormat:@"%@",userInfo[@"id"]];
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
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"JMMaMaHomeController  --> dealloc被调用");
    if (self.homeHeaderView) {
        if (self.homeHeaderView.pageView) {
            [self.homeHeaderView.pageView removeFromSuperview];
            self.homeHeaderView.pageView = nil;
        }
    }
    
    
}


@end


/*

//@property (nonatomic, strong) NSMutableArray *earningArray;
//@property (nonatomic, strong) NSMutableArray *earningImageArray;
//@property (nonatomic, strong) UIView *msgBottomView;
//@property (nonatomic, strong) UIImageView *msgImage;
//@property (nonatomic, strong) UILabel *msgLabel;
//- (NSMutableArray *)earningArray {
//    if (_earningArray == nil) {
//        _earningArray = [NSMutableArray array];
//    }
//    return _earningArray;
//}
//- (NSMutableArray *)earningImageArray {
//    if (_earningImageArray == nil) {
//        _earningImageArray = [NSMutableArray array];
//    }
//    return _earningImageArray;
//}
 
 #pragma mark ========== 妈妈收益消息请求 ==========
 - (void)loadEarningMessage {
 NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/ordercarry/get_latest_order_carry",Root_URL];
 [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
 if (!responseObject) return ;
 [self.earningArray removeAllObjects];
 [self.earningImageArray removeAllObjects];
 [self fetchEarning:responseObject];
 } WithFail:^(NSError *error) {
 } Progress:^(float progress) {
 }];
 }
 - (void)fetchEarning:(NSArray *)array {
 if (array.count == 0) return ;
 for (NSDictionary *dic in array) {
 [self.earningArray addObject:dic[@"content"]];
 [self.earningImageArray addObject:dic[@"avatar"]];
 }
 [self earningPrompt];
 }
 
 #pragma mark - 妈妈页面消息弹出展示
 // ============================================================================= //
 //                      妈妈页面消息弹出展示
 // ============================================================================= //
 - (NSTimer *)messageTimer {
 if (!_messageTimer) {
 _messageTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(waitTimer) userInfo:nil repeats:NO];
 }
 return _messageTimer;
 }
 - (void)earningPrompt {
 //    [self performSelector:@selector(waitTimer) withObject:nil afterDelay:3.0];
 if (!_messageTimer) {
 [[NSRunLoop currentRunLoop] addTimer:self.messageTimer forMode:NSRunLoopCommonModes];
 }
 }
 - (void)waitTimer {
 UIViewController *controller = [self.navigationController.viewControllers lastObject];
 if ([controller isKindOfClass:[JMMaMaHomeController class]]) {
 if (_indexCode >= (self.earningArray.count - 1)) {
 _indexCode = 0;
 }
 [self showNewStatusCount:self.earningArray Image:self.earningImageArray Index:_indexCode];
 }
 }
 - (void)showNewStatusCount:(NSArray *)message Image:(NSArray *)imageArr Index:(NSInteger)index {
 if (message.count == 0) return ;
 [self.view addSubview:self.msgBottomView];
 //    [self.navigationController.view insertSubview:self.msgBottomView belowSubview:self.navigationController.navigationBar];
 [self.msgBottomView addSubview:self.msgImage];
 [self.msgBottomView addSubview:self.msgLabel];
 self.msgLabel.text = message[index];
 [self.msgImage sd_setImageWithURL:[NSURL URLWithString:[[imageArr[index] JMUrlEncodedString] imageMoreCompression]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
 [UIView animateWithDuration:1.0 animations:^{
 //        view.transform = CGAffineTransformMakeTranslation(0, h * 2);
 self.msgBottomView.alpha = 1.0f;
 } completion:^(BOOL finished) {
 [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
 //            view.transform = CGAffineTransformIdentity;
 self.msgBottomView.alpha = 0.0f;
 } completion:^(BOOL finished) {
 [self.msgBottomView removeFromSuperview];
 _indexCode ++;
 //            int x = arc4random() % 5 + 6;
 //            [self performSelector:@selector(waitTimer) withObject:nil afterDelay:x];
 if (_messageTimer) {
 [self.messageTimer invalidate];
 self.messageTimer = nil;
 }
 [self earningPrompt];
 }];
 }];
 }
 - (UIView *)msgBottomView {
 if (_msgBottomView == nil) {
 CGFloat h = 40.;
 CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 20;
 CGFloat x = 10;
 CGFloat w = SCREENWIDTH;
 _msgBottomView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w - 50, h)];
 _msgBottomView.userInteractionEnabled = NO;
 _msgBottomView.layer.cornerRadius = 20;
 _msgBottomView.layer.masksToBounds = YES;
 //    [self.navigationController.view insertSubview:view belowSubview:self.navigationController.navigationBar];
 _msgBottomView.backgroundColor = [UIColor blackColor];
 _msgBottomView.alpha = 0.70f;
 }
 return _msgBottomView;
 }
 - (UIImageView *)msgImage {
 if (_msgImage == nil) {
 CGFloat x = 10;
 _msgImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, 30, 30)];
 _msgImage.layer.cornerRadius = 15;
 _msgImage.layer.masksToBounds = YES;
 }
 return _msgImage;
 }
 - (UILabel *)msgLabel {
 if (_msgLabel == nil) {
 CGFloat h = 40.;
 CGFloat w = SCREENWIDTH;
 _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, w - 105, h)];
 _msgLabel.font = [UIFont systemFontOfSize:13.];
 _msgLabel.textColor = [UIColor whiteColor];
 }
 return _msgLabel;
 }
 
 
 - (void)endEarningMessage {
 [self.earningArray removeAllObjects];
 [self.earningImageArray removeAllObjects];
 self.msgBottomView = nil;
 self.msgImage = nil;
 self.msgLabel = nil;
 }
 
 
 */








































































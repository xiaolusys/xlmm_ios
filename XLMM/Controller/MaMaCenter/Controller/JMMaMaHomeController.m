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
#import "JMHomeRootController.h"
#import "NewLeftViewController.h"
#import "RESideMenu.h"
#import "JMRewardsController.h"
#import "JMPushingDaysController.h"
#import "ProductSelectionListViewController.h"
#import "JMVipRenewController.h"
#import "TodayVisitorViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaClassifyCarryLogViewController.h"
#import "JMRootTabBarController.h"


@interface JMMaMaHomeController () <UITableViewDataSource,UITableViewDelegate,RESideMenuDelegate,JMMaMaHomeHeaderViewDelegte> {
    NSInteger _indexCode;
    NSString *_orderRecord;             // 订单记录
    NSString *_earningsRecord;          // 收益记录
    NSString *_historyEarningsRecord;   // 历史收益记录
    NSString *_myInvitation;            // 邀请开店
    NSString *_boutiqueString;          // 精品汇
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
    CGFloat _carryValue;
//    NSString *_mamaNotReadNotice;       // 未读消息
    
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
 *  最近订单收益的20条信息
 */
@property (nonatomic, strong) NSMutableArray *earningArray;
@property (nonatomic, strong) NSMutableArray *earningImageArray;
@property (nonatomic, strong) UIView *msgBottomView;
@property (nonatomic, strong) UIImageView *msgImage;
@property (nonatomic, strong) UILabel *msgLabel;

/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;


@end

@implementation JMMaMaHomeController
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
- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}
- (JMMaMaHomeHeaderView *)homeHeaderView {
    if (!_homeHeaderView) {
        _homeHeaderView = [[JMMaMaHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 590)];
        _homeHeaderView.delegate = self;
    }
    return _homeHeaderView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _indexCode = 0;
    [self loadMaMaMessage];
    [self loadEarningMessage];
    [MobClick beginLogPageView:@"JMMaMaHomeController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMMaMaHomeController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    self.homeHeaderView.lineChart = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:@selector(backClick:)];
    _qrCodeRequestDataIndex = 0;
    _indexCode = 0;
    [self createTableView];
    [self craeteNavRightButton];
    [self customUserInfo];
    [self createPullHeaderRefresh];
    [self loadDataSource];
    [self loadfoldLineData];
    
    [self loaderweimaData];
    [self.tableView.mj_header beginRefreshing];
}
- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}
- (void)endEarningMessage {
    [self.earningArray removeAllObjects];
    [self.earningImageArray removeAllObjects];
    self.msgBottomView = nil;
    self.msgImage = nil;
    self.msgLabel = nil;
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadMaMaWeb];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)loadMaMaMessage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mama/message/self_list",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.homeHeaderView.messageDic = responseObject;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
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
#pragma mark ========== 妈妈页面web链接请求 ==========
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject){
            [self endRefresh];
            return ;
        }
        [self.activeArray removeAllObjects];
        [self mamaWebViewData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    resultsDict = resultsArr[0];
    NSDictionary *dict = resultsDict[@"extra"];
    
//    self.makeMoneyDic = resultsDict[@"extra"];
    NSArray *activeArr = resultsDict[@"mama_activities"];
    if (activeArr.count == 0) return ;
    for (NSDictionary *dict in activeArr) {
        JMHomeActiveModel *model = [JMHomeActiveModel mj_objectWithKeyValues:dict];
        [self.activeArray addObject:model];
    }
    _myInvitation = dict[@"invite"];
    _boutiqueString = dict[@"boutique"];
//    _mamaNotReadNotice = dict[@"notice"];
    self.homeHeaderView.mamaNotReadNotice = dict[@"notice"];
    [self.tableView reloadData];
}
#pragma mark ========== 妈妈页面主数据请求 ==========
- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            [self updateMaMaHome:responseObject];
        }
    } WithFail:^(NSError *error) {
        
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
- (void)loaderweimaData {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/qrcode/get_wxpub_qrcode");
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSInteger code = [responseObject[@"code"] integerValue];
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









#pragma ========== UI处理 ==========
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 在这里创建headerView
    self.tableView.tableHeaderView = self.homeHeaderView;
    [self headerClick];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH * 0.5 + 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
    if (!cell) {
        cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.activeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeActiveModel *model = self.activeArray[indexPath.row];
    [self skipWebView:model.act_applink activeDic:model];
    
}
#pragma mark 创建小鹿客服入口
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
- (void)serViceButtonClick:(UIButton *)button {
    [MobClick event:@"MaMa_service"];
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
    //    UdeskRobotIMViewController *robot = [[UdeskRobotIMViewController alloc] init];
    //    [self.navigationController pushViewController:robot animated:YES];
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}

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
 *  100 --> 本周我的排名
 *  101 --> 世界排名TOP10
 *  102 --> 马上执行
 *  103 --> 分享店铺
 *  104 --> 每日推送
 *  105 --> 精品汇
 *  106 --> 邀请开店
 *  107 --> 续费按钮
 *  108 --> 折线图 -- > 访客
 *  109 --> 折线图 -- > 订单
 *  110 --> 折线图 -- > 收益
 */
- (void)composeHomeHeader:(JMMaMaHomeHeaderView *)headerView ButtonActionClick:(UIButton *)button {
    NSInteger index = button.tag;
    switch (index) {
        case 100: {
        }
            break;
        case 101: {
        }
            break;
        case 102: {
            JMRewardsController *rewardsVC = [[JMRewardsController alloc] init];
            [self.navigationController pushViewController:rewardsVC animated:YES];
        }
            break;
        case 103: {
            NSString *urlString = [NSString stringWithFormat:@"%@/mall/?mm_linkid=%@",Root_URL,self.mamaCenterModel.mama_id];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:urlString forKey:@"web_url"];
            [dict setValue:@"mamaShop" forKey:@"type_title"];
            [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:YES Title:nil];
        }
            break;
        case 104: {
            JMPushingDaysController *pushingVC = [[JMPushingDaysController alloc] init];
            [self.navigationController pushViewController:pushingVC animated:YES];
        }
            break;
        case 105: {
            ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
            break;
        case 106: {
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
        case 107: {
            JMVipRenewController *renewVC = [[JMVipRenewController alloc] init];
            renewVC.cashValue = _carryValue;
            [self.navigationController pushViewController:renewVC animated:YES];
        }
            break;
        case 108: {
            TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
            today.visitorDate = kVisitorDay;
            [self.navigationController pushViewController:today animated:YES];
        }
            break;
        case 109: {
            MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
            order.orderRecord = _orderRecord;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case 110: {
            MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
            carry.earningsRecord = _earningsRecord;
            carry.historyEarningsRecord = _historyEarningsRecord;
            [self.navigationController pushViewController:carry animated:YES];
        }
            break;
        default:
            break;
    }

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

#pragma mark - 妈妈页面消息弹出展示
// ============================================================================= //
//                      妈妈页面消息弹出展示
// ============================================================================= //
- (void)earningPrompt {
    [self performSelector:@selector(waitTimer) withObject:nil afterDelay:3.0];
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
            int x = arc4random() % 5 + 6;
            [self performSelector:@selector(waitTimer) withObject:nil afterDelay:x];
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
#pragma mark - 小鹿客服注册个人信息
- (void)customUserInfo {
    NSDictionary *userInfo = [JMStoreManager getDataDictionary:@"usersInfo.plist"];
    if (userInfo == nil) {
        return ;
    }
    NSString *nick_name = userInfo[@"nick"];
    NSString *sdk_token = userInfo[@"user_id"];
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
    JMRootTabBarController *tabBarVC = [[JMRootTabBarController alloc] init];
    NewLeftViewController *leftMenu = [[NewLeftViewController alloc] initWithNibName:@"NewLeftViewController" bundle:nil];
    leftMenu.pushVCDelegate = tabBarVC;
    RESideMenu *menuVC = [[RESideMenu alloc] initWithContentViewController:tabBarVC leftMenuViewController:leftMenu rightMenuViewController:nil];
    menuVC.view.backgroundColor = [UIColor settingBackgroundColor];
    menuVC.menuPreferredStatusBarStyle = 1;
    menuVC.delegate = self;
    menuVC.contentViewShadowColor = [UIColor blackColor];
    menuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    menuVC.contentViewShadowOpacity = 0.6;
    menuVC.contentViewShadowRadius = 12;
    menuVC.contentViewShadowEnabled = YES;
    JMKeyWindow.rootViewController = menuVC;
    
}
#pragma mark ======== RESideMenu Delegate ========
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLeftMenuVC" object:nil];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    // NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}






@end





































































































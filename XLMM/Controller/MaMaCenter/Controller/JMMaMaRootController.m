//
//  JMMaMaRootController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaRootController.h"
#import "HMSegmentedControl.h"
#import "JMMakeMoneyController.h"
#import "JMSocialActivityController.h"
#import "JMMineController.h"
#import "UdeskManager.h"
#import "JMMaMaCenterModel.h"
#import "JMMaMaExtraModel.h"
#import "JMHomeActiveModel.h"
#import "Udesk.h"
#import "JMStoreManager.h"

static NSString *currentTurnsNumberString;

@interface JMMaMaRootController () {
    NSInteger _indexCode;
    BOOL _isActiveClick;
    NSArray *_titleArr;
    NSString *qrCodeUrlString;          // 二维码图片
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
    NSString *_currentTurnsNum;         // 当天阅读每日推送轮数
    
}

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) JMMakeMoneyController *makeMoneyVC;
@property (nonatomic, strong) JMSocialActivityController *activityVC;
@property (nonatomic, strong) JMMineController *mineVC;
/**
 *  MaMa客服入口
 */
@property (nonatomic, strong) UIButton *serViceButton;
/**
 *  妈妈中心数据源
 */
@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
/**
 *  妈妈中心额外数据源
 */
@property (nonatomic, strong) JMMaMaExtraModel *extraModel;

@property (nonatomic, strong) NSMutableDictionary *mamaWebDict;
/**
 *  最近订单收益的20条信息
 */
@property (nonatomic, strong) NSMutableArray *earningArray;
@property (nonatomic, strong) NSMutableArray *earningImageArray;
//@property (nonatomic, strong) NSMutableDictionary *currentTurnsData; // 保存每日推送轮数
@property (nonatomic, strong) NSMutableArray *activeArray;

@property (nonatomic, strong) UIView *msgBottomView;
@property (nonatomic, strong) UIImageView *msgImage;
@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation JMMaMaRootController

- (NSMutableArray *)activeArray {
    if (_activeArray == nil) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
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
- (NSMutableDictionary *)mamaWebDict {
    if (_mamaWebDict == nil) {
        _mamaWebDict = [NSMutableDictionary dictionary];
    }
    return _mamaWebDict;
}
//- (NSMutableDictionary *)currentTurnsData {
//    if (_currentTurnsData == nil) {
//        _currentTurnsData = [NSMutableDictionary dictionary];
//    }
//    return _currentTurnsData;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _indexCode = 0;
    [self loadEarningMessage];
    [self loadMaMaMessage];
    [MobClick beginLogPageView:@"JMMaMaRootController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMMaMaRootController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:@selector(backClick:)];
    _indexCode = 0;
    _qrCodeRequestDataIndex = 0;
    qrCodeUrlString = @"";
    _isActiveClick = NO;
    [self createSegmentView];
    [self craeteNavRightButton];
    [self customUserInfo];
    
    [self loadMaMaWeb];
    [self loadDataSource];
    [self loadfoldLineData];
    [self loaderweimaData];
    
}

- (void)loadMaMaMessage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mama/message/self_list",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.makeMoneyVC.messageDic = responseObject;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
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
//新接口数据
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortuneDic = dic[@"mama_fortune"];
    _currentTurnsNum = fortuneDic[@"current_dp_turns_num"];
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    NSDictionary *extraDic = self.mamaCenterModel.extra_info;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:extraDic];
//    _mamaID = self.mamaCenterModel.mama_id;
//    self.mineVC.extraModel = self.extraModel;
    self.mineVC.mamaCenterModel = self.mamaCenterModel;
    self.makeMoneyVC.centerModel = self.mamaCenterModel;
//    self.makeMoneyVC.extraFiguresDic = fortuneDic[@"extra_figures"];
    self.mineVC.extraFiguresDic = fortuneDic[@"extra_figures"];
    
    NSString *currentTime = [NSString getCurrentYMD];
    if ([JMStoreManager isFileExist:@"currentTurnsData.plist"]) { // 存在这个字典
        NSDictionary *dict = [JMStoreManager getDataDictionary:@"currentTurnsData.plist"];
        NSString *saveTime = dict[@"currentTime"];
        NSString *saveNum = dict[@"currentNum"];
        [JMStoreManager removeFileByFileName:@"currentTurnsData.plist"];
        NSDictionary *currentDict = [NSDictionary dictionaryWithObjectsAndKeys:currentTime,@"currentTime",_currentTurnsNum,@"currentNum", nil];
        [JMStoreManager saveDataFromDictionary:@"currentTurnsData.plist" WithData:currentDict];
        if ([currentTime isEqualToString:saveTime]) { // 判断是否为当天
            NSInteger turnsNum = labs([_currentTurnsNum integerValue] - [saveNum integerValue] + [currentTurnsNumberString integerValue]);
            _currentTurnsNum = [NSString stringWithFormat:@"%ld",turnsNum];
        }else {
        }
    }else {  // 不存在这个字典
        NSDictionary *currentDict = [NSDictionary dictionaryWithObjectsAndKeys:currentTime,@"currentTime",_currentTurnsNum,@"currentNum", nil];
        [JMStoreManager saveDataFromDictionary:@"currentTurnsData.plist" WithData:currentDict];
    }
    currentTurnsNumberString = _currentTurnsNum;
    self.makeMoneyVC.currentTurnsNum = [NSString stringWithFormat:@"%@",currentTurnsNumberString];
    
    
}
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.activeArray removeAllObjects];
        [self mamaWebViewData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
// MaMaWebView跳转链接
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
//    for (NSDictionary *dic in resultsArr) {
//        resultsDict = dic;
//    }
    resultsDict = resultsArr[0];
    NSDictionary *extraDict = resultsDict[@"extra"];
    self.mamaWebDict[@"invite"] = extraDict[@"invite"];                 // --> 我的邀请
    self.mamaWebDict[@"exam"] = extraDict[@"exam"];                     // --> 等级考试
    self.mamaWebDict[@"fans_explain"] = extraDict[@"fans_explain"];     // --> 粉丝二维码
    self.mamaWebDict[@"act_info"] = extraDict[@"act_info"];             // --> 精品活动
    self.mamaWebDict[@"renew"] = extraDict[@"renew"];                   // --> 续费
    self.mamaWebDict[@"notice"] = extraDict[@"notice"];                 // --> 小鹿妈妈消息
    self.mamaWebDict[@"forum"] = extraDict[@"forum"];                   // --> 论坛入口
    self.mamaWebDict[@"team_explain"] = extraDict[@"team_explain"];     // --> 团队说明
    _isActiveClick = YES;                                               // --> 如果想要点击论坛才开始加载需要设置这个属性,否则就不用设置
    self.makeMoneyVC.makeMoneyDic = self.mamaWebDict;
    self.mineVC.webDict = self.mamaWebDict;
//    self.activityVC.urlString = extraDict[@"forum"];
    NSArray *activeArr = resultsDict[@"mama_activities"];
    if (activeArr.count == 0) return ;
    for (NSDictionary *dict in activeArr) {
        JMHomeActiveModel *model = [JMHomeActiveModel mj_objectWithKeyValues:dict];
        [self.activeArray addObject:model];
    }
    self.makeMoneyVC.activeArray = self.activeArray;
}
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
// 折线图数据请求
- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:chartUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.makeMoneyVC.mamaResults = arr;
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
            qrCodeUrlString = responseObject[@"qrcode_link"];
            [JMStoreManager saveDataFromArray:@"qrCodeUrlString.txt" WithString:qrCodeUrlString];
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
#pragma mark 创建segment(tabBar)
- (void)createSegmentView {
    _titleArr = @[@"我要赚钱",@"社交活动",@"我的"];
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50)];
    self.segmentedControl.backgroundColor = [UIColor sectionViewColor];
    self.segmentedControl.sectionTitles = _titleArr;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonTitleColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont systemFontOfSize:18.]};
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 114)];
    self.scrollView.backgroundColor = [UIColor lineGrayColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
    self.scrollView.delegate = self;
//    [self.scrollView scrollRectToVisible:CGRectMake(0, 64, SCREENWIDTH, 0) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.makeMoneyVC = [[JMMakeMoneyController alloc] init];
    self.makeMoneyVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.makeMoneyVC];
    [self.scrollView addSubview:self.makeMoneyVC.view];
    
    self.makeMoneyVC.block = ^(UILabel *currentLabel) {
        currentTurnsNumberString = @"0";
        currentLabel.hidden = YES;
    };
    
    self.activityVC = [[JMSocialActivityController alloc] init];
    self.activityVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.activityVC];
    [self.scrollView addSubview:self.activityVC.view];
    
    self.mineVC = [[JMMineController alloc] init];
    self.mineVC.view.frame = CGRectMake(SCREENWIDTH * 2, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.mineVC];
    [self.scrollView addSubview:self.mineVC.view];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger page = segmentedControl.selectedSegmentIndex;
    // --> 如果想要点击论坛才开始加载需要打开这个注释
    if (page == 1 && _isActiveClick) {
//        NSString *urlString = @"http://192.168.1.8:8888/accounts/xlmm/login/";
        self.activityVC.urlString = self.mamaWebDict[@"forum"];
        _isActiveClick = NO;
    }else { }
    self.scrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    [MobClick event:_titleArr[page]];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    if (page == 1 && _isActiveClick) {
        self.activityVC.urlString = self.mamaWebDict[@"forum"];
        _isActiveClick = NO;
    }else { }
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
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
    if ([controller isKindOfClass:[JMMaMaRootController class]]) {
        if (_indexCode >= (self.earningArray.count - 1)) {
            _indexCode = 0;
        }
        [self showNewStatusCount:self.earningArray Image:self.earningImageArray Index:_indexCode];
    }
}
- (void)showNewStatusCount:(NSArray *)message Image:(NSArray *)imageArr Index:(NSInteger)index {
    if (message.count == 0) return ;
    [self.view addSubview:self.msgBottomView];
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
            int x = arc4random() % 5 + 5;
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
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}




@end

















































































































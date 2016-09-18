//
//  JMMaMaRootController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaRootController.h"
#import "MMClass.h"
#import "HMSegmentedControl.h"
#import "JMMakeMoneyController.h"
#import "JMSocialActivityController.h"
#import "JMMineController.h"
#import "UdeskRobotIMViewController.h"
#import "UdeskManager.h"
#import "JMMaMaCenterModel.h"
#import "JMMaMaExtraModel.h"



@interface JMMaMaRootController ()

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

@end

@implementation JMMaMaRootController {
    NSMutableArray *_titleArr;
}

- (NSMutableDictionary *)mamaWebDict {
    if (_mamaWebDict == nil) {
        _mamaWebDict = [NSMutableDictionary dictionary];
    }
    return _mamaWebDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:@selector(backClick:)];
    _titleArr = [NSMutableArray arrayWithObjects:@"我要赚钱",@"社交活动",@"我的", nil];
    [self createSegmentView];
    [self craeteNavRightButton];
    [self customUserInfo];
    
    [self loadMaMaWeb];
    [self loadDataSource];
    [self loadMaMaMessage];
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
- (void)mamaMesageData:(NSDictionary *)messageDic {
    self.mineVC.messageDic = messageDic;
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
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    NSDictionary *extraDic = self.mamaCenterModel.extra_info;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:extraDic];
//    _mamaID = self.mamaCenterModel.mama_id;
    self.mineVC.mamaCenterModel = self.mamaCenterModel;
    self.mineVC.extraModel = self.extraModel;
    
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
// MaMaWebView跳转链接
- (void)mamaWebViewData:(NSDictionary *)mamaDic {
    NSArray *resultsArr = mamaDic[@"results"];
    NSDictionary *resultsDict = [NSDictionary dictionary];
    for (NSDictionary *dic in resultsArr) {
        resultsDict = dic;
    }
    NSDictionary *extraDict = resultsDict[@"extra"];
    self.mamaWebDict[@"invite"] = extraDict[@"invite"];                 // --> 我的邀请
    self.mamaWebDict[@"exam"] = extraDict[@"exam"];                     // --> 等级考试
    self.mamaWebDict[@"fans_explain"] = extraDict[@"fans_explain"];     // --> 粉丝二维码
    self.mamaWebDict[@"act_info"] = extraDict[@"act_info"];             // --> 精品活动
    self.mamaWebDict[@"renew"] = extraDict[@"renew"];                   // --> 续费
    self.mamaWebDict[@"notice"] = extraDict[@"notice"];                 // --> 小鹿妈妈消息
    self.mamaWebDict[@"forum"] = extraDict[@"forum"];                   // --> 论坛入口
    self.mamaWebDict[@"team_explain"] = extraDict[@"team_explain"];     // --> 团队说明
    
    self.makeMoneyVC.makeMoneyDic = self.mamaWebDict;
    self.mineVC.webDict = self.mamaWebDict;
    self.activityVC.urlString = extraDict[@"forum"];
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
- (void)serViceButtonClick:(UIButton *)button {
    [MobClick event:@"MaMa_service"];
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
    UdeskRobotIMViewController *robot = [[UdeskRobotIMViewController alloc] init];
    [self.navigationController pushViewController:robot animated:YES];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
#pragma mark 创建segment(tabBar)
- (void)createSegmentView {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 44, SCREENWIDTH, 44)];
    self.segmentedControl.backgroundColor = [UIColor sectionViewColor];
    self.segmentedControl.sectionTitles = _titleArr;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonTitleColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 108)];
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
    self.scrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    [MobClick event:_titleArr[page]];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
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
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMMaMaRootController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMMaMaRootController"];
}




@end

















































































































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



@interface JMMaMaPersonCenterController ()<UITableViewDelegate,UITableViewDataSource,JMMaMaCenterFooterViewDelegate,JMMaMaCenterHeaderViewDelegate>

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
 *  订单记录,收益记录,我的邀请,MaMa等级考试入口,关于粉丝入口,精品活动入口,续费入口
 */
@property (nonatomic, strong)NSString *orderRecord;
@property (nonatomic, strong)NSString *earningsRecord;
@property (nonatomic, copy)NSString *myInvitation;
@property (nonatomic, copy) NSString *examWebUrl;
@property (nonatomic, copy) NSString *fansWebUrl;
@property (nonatomic, copy) NSString *boutiqueActiveWebUrl;
@property (nonatomic, copy) NSString *renewWebUrl;
@property (nonatomic, strong)NSString *eventLink;

@end

@implementation JMMaMaPersonCenterController {
    NSString *_mamaID;
}
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"妈妈中心" selecotr:@selector(backClick:)];
    [self createTableView];
    [self createHeaderView];
    [self createFooterView];
    [self loadfoldLineData];
    [self loadDataSource];
    [self loadMaMaWeb];
}

- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            [self updateMaMaHome:responseObject];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    self.carryValue = [self.mamaCenterModel.cash_value floatValue];
    self.activeValueNum = [NSNumber numberWithInteger:[self.mamaCenterModel.active_value_num integerValue]];
    self.fansNum = [NSNumber numberWithInteger:[self.mamaCenterModel.fans_num integerValue]];
    self.orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];
    self.earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];
    
    //精选活动链接
    self.eventLink = self.mamaCenterModel.mama_event_link;
    
}

- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chartUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.mamaCenterHeaderView.mamaResults = arr;
//        [self endRefresh];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)loadMaMaWeb {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/mmwebviewconfig?version=1.0", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            [self mamaWebViewData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    
    self.myInvitation = extraDict[@"invite"];             // --> 我的邀请
    self.examWebUrl = extraDict[@"exam"];                 // --> 等级考试
    self.fansWebUrl = extraDict[@"fans_explain"];         // --> 粉丝二维码
    self.boutiqueActiveWebUrl = extraDict[@"act_info"];   // --> 精品活动
    self.renewWebUrl = extraDict[@"renew"];               // --> 续费
    
    
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


- (void)backClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 100 == > 账户余额
 101 == > 累计收益
 102 == > 活跃度
 103 == > 访客
 104 == > 订单
 105 == > 收益
 106 == > 考试
 107 == > 续费
 */
- (void)composeMaMaCenterHeaderView:(JMMaMaCenterHeaderView *)headerView Index:(NSInteger)index {
    if (index == 100) {
        NSLog(@"100 == > 账户余额");
        TixianViewController *vc = [[TixianViewController alloc] init];
        vc.cantixianjine = self.carryValue;
        vc.activeValue = [self.activeValueNum integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 101) {
        NSLog(@"101 == > 累计收益");
    }else if (index == 102) {
        NSLog(@"102 == > 活跃度");
        MaMaHuoyueduViewController *VC = [[MaMaHuoyueduViewController alloc] init];
        VC.activeValueNum = self.activeValueNum;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 103) {
        NSLog(@"103 == > 访客");
        TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
        today.visitorDate = self.visitorDate;
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
        [self.navigationController pushViewController:renewVC animated:YES];
    }else {
    
    }
}
/*
 100 === > 小鹿大学(精品活动)
 101 === > 订单记录
 102 === > 收益记录
 103 === > 我的精选
 104 === > 每日推送
 105 === > 邀请一元开店
 106 === > 选品上架
 107 === > 小鹿大学(精品活动)
 108 === > 我的粉丝
 109 === > 我的团队
 110 === > 访客记录
 */
- (void)composeMaMaCenterFooterView:(JMMaMaCenterFooterView *)footerView Index:(NSInteger)index {

    if (index == 100 || index == 107) {
        if (self.eventLink == nil || self.eventLink.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"活动还未开始"];
            return;
        }
        WebViewController *activity = [[WebViewController alloc] init];
        //    _diction = nil;
        NSString *active = @"myInvite";
        NSString *titleName = @"精品活动";
        [self.diction setValue:self.eventLink forKey:@"web_url"];
        [self.diction setValue:active forKey:@"type_title"];
        [self.diction setValue:titleName forKey:@"name_title"];
        activity.webDiction = _diction;//[NSMutableDictionary dictionaryWithDictionary:_diction];
        activity.isShowNavBar = true;
        activity.isShowRightShareBtn = true;
        activity.share_model.share_link = self.eventLink;
        activity.share_model.title = @"精品活动";
        activity.share_model.desc = @"更多精选活动,尽在小鹿美美~~";
        activity.share_model.share_img = @"http://7xogkj.com2.z0.glb.qiniucdn.com/1181123466.jpg";
        activity.share_model.share_type = @"link";
        [self.navigationController pushViewController:activity animated:YES];
    }else if (index == 101) {
        MaMaOrderListViewController *orderList = [[MaMaOrderListViewController alloc] init];
        orderList.orderRecord = self.orderRecord;
        [self.navigationController pushViewController:orderList animated:YES];
    }else if (index == 102) {
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = self.earningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else if (index == 103) {
        ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
        [self.navigationController pushViewController:previous animated:YES];
    }else if (index == 104) {
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [self.navigationController pushViewController:publish animated:YES];
    }else if (index == 105) {
        if ([self.myInvitation class] == [NSNull class])return;
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
        [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
    }else if (index == 109) {
        JMMaMaTeamController *teamVC = [[JMMaMaTeamController alloc] init];
        teamVC.mamaID = _mamaID;
        [self.navigationController pushViewController:teamVC animated:YES];
    }else if (index == 110) {
        JMMaMaEarningsRankController *earningsRankVC = [[JMMaMaEarningsRankController alloc] init];
        earningsRankVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/self_rank",Root_URL];
        earningsRankVC.rankInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/carry_total_rank",Root_URL];
        earningsRankVC.isTeamEarningsRank = NO;
        [self.navigationController pushViewController:earningsRankVC animated:YES];
    }else {
    
    }
}
@end












































































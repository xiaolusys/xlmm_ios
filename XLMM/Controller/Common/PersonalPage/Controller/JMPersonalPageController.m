//
//  JMPersonalPageController.m
//  XLMM
//
//  Created by zhang on 16/11/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPersonalPageController.h"
#import "JMPersonalPageCell.h"
#import "JMLogInViewController.h"
#import "JMMineIntegralController.h"
#import "JMCouponController.h"
#import "JMComplaintSuggestController.h"
#import "PersonOrderViewController.h"
#import "JMRefundBaseController.h"
#import "JMSettingController.h"
#import "Account1ViewController.h"
#import "WebViewController.h"
#import "CSTabBarController.h"
#import "JMStoreManager.h"
#import "JMPersonalPageLayoutCell.h"
#import "JMPersonalHeaderReusableView.h"
#import "JMPersonalPageHeaderCell.h"
#import "JMApplyForRefundController.h"


@interface JMPersonalPageController () <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,JMPersonalPageHeaderCellDelegate> {
    NSDictionary *_persinCenterDict;
    NSNumber *_accountMoney;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIImageView *userIconImage;
@property (nonatomic, strong) UILabel *redCircle;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *smallChangeLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@property (nonatomic, strong) UILabel *couponLabel;

/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;


@end

@implementation JMPersonalPageController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitLogin) name:@"quit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel:) name:@"drawCashMoeny" object:nil];
    [self setUserInfo];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isHideNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }else {
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    self.dataSource = [NSMutableArray arrayWithObjects:
                       @[@{@"iconImage":@"waitpay",@"title":@"待支付",@"orderNum":@"0"},
                         @{@"iconImage":@"waitsend",@"title":@"待收货",@"orderNum":@"0"},
                         @{@"iconImage":@"refund",@"title":@"退换货",@"orderNum":@"0"},
                         @{@"iconImage":@"alltrades",@"title":@"我的订单",@"orderNum":@"0"}],
                       @[@{@"iconImage":@"wodeweidian",@"title":@"我的微店",@"orderNum":@"0"},
                         @{@"iconImage":@"suggestions",@"title":@"投诉建议",@"orderNum":@"0"},
                         @{@"iconImage":@"questions",@"title":@"常见问题",@"orderNum":@"0"}],
                       nil];
    
//    [self createTableView];
//    [self createHeaderView];

    [self createCollectionView];
//    [self createPullHeaderRefresh];
//    [self.collectionView.mj_header beginRefreshing];
    
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.collectionView.mj_footer resetNoMoreData];
        [weakSelf setUserInfo];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
}

- (void)refreshUserInfo {
    [self setUserInfo];
//    [self.tableView.mj_header beginRefreshing];
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
- (void)setUserInfo{
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        if ([self isLogin]) {
            self.isHideNavigationBar = NO;
            [self updateUserInfo:responseObject];
            [self.collectionView reloadData];
        }else {
            self.isHideNavigationBar = YES;
            [self quitLogin];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        self.isHideNavigationBar = YES;
        [self quitLogin];
        [self endRefresh];
        
    }];
}
- (void)updateUserInfo:(NSDictionary *)dic {
    _persinCenterDict = dic;
    //判断是否为0
    if ([[dic objectForKey:@"user_budget"] isKindOfClass:[NSNull class]]) {
        _accountMoney = [NSNumber numberWithFloat:0.00];
    }else {
        NSDictionary *xiaolumeimei = [dic objectForKey:@"user_budget"];
        NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
        _accountMoney = num;
    }
    
    self.dataSource = [NSMutableArray arrayWithObjects:
                       @[@{@"iconImage":@"waitpay",@"title":@"待支付",@"orderNum":dic[@"waitpay_num"]},
                         @{@"iconImage":@"waitsend",@"title":@"待收货",@"orderNum":dic[@"waitgoods_num"]},
                         @{@"iconImage":@"refund",@"title":@"退换货",@"orderNum":dic[@"refunds_num"]},
                         @{@"iconImage":@"alltrades",@"title":@"我的订单",@"orderNum":@"0"}],
                       @[@{@"iconImage":@"wodeweidian",@"title":@"我的微店",@"orderNum":@"0"},
                         @{@"iconImage":@"suggestions",@"title":@"投诉建议",@"orderNum":@"0"},
                         @{@"iconImage":@"questions",@"title":@"常见问题",@"orderNum":@"0"}],
                       nil];

}

- (void)quitLogin {
    _persinCenterDict = nil;
    self.dataSource = [NSMutableArray arrayWithObjects:
                       @[@{@"iconImage":@"waitpay",@"title":@"待支付",@"orderNum":@"0"},
                         @{@"iconImage":@"waitsend",@"title":@"待收货",@"orderNum":@"0"},
                         @{@"iconImage":@"refund",@"title":@"退换货",@"orderNum":@"0"},
                         @{@"iconImage":@"alltrades",@"title":@"我的订单",@"orderNum":@"0"}],
                       @[@{@"iconImage":@"wodeweidian",@"title":@"我的微店",@"orderNum":@"0"},
                         @{@"iconImage":@"suggestions",@"title":@"投诉建议",@"orderNum":@"0"},
                         @{@"iconImage":@"questions",@"title":@"常见问题",@"orderNum":@"0"}],
                       nil];
    [self.collectionView reloadData];
}
- (void)updataAfterLogin:(NSNotification *)notification{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo =  [userDefaults objectForKey:@"userInfo"];
    
    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.userNameLabel.text = [userInfo objectForKey:@"nickname"];
//    [self setUserInfo];
}
- (void)phoneNumberLogin:(NSNotification *)notification{
    self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    //    [self setJifenInfo];
    //    [self setYHQInfo];
//    [self setUserInfo];
}

- (void)displayLoginView{
    JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)updateMoneyLabel:(NSNotification *)center {
    self.smallChangeLabel.text = center.object;
}



- (void)createCollectionView {
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JMPersonalPageLayoutCell class] forCellWithReuseIdentifier:@"JMPersonalPageLayoutCellIdentifier"];
    [self.collectionView registerClass:[JMPersonalPageHeaderCell class] forCellWithReuseIdentifier:@"JMPersonalPageHeaderCellIdentifier"];
    [self.collectionView registerClass:[JMPersonalHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JMPersonalHeaderReusableViewIdentifier"];
  
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        NSArray *arr = self.dataSource[section - 1];
        return arr.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMPersonalPageHeaderCell *layoutCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JMPersonalPageHeaderCellIdentifier" forIndexPath:indexPath];
        layoutCell.delegate = self;
        layoutCell.dict = _persinCenterDict;
        return layoutCell;
    }else {
        JMPersonalPageLayoutCell *layoutCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JMPersonalPageLayoutCellIdentifier" forIndexPath:indexPath];
        NSDictionary *dict = self.dataSource[indexPath.section - 1][indexPath.row];
        [layoutCell config:dict];
        return layoutCell;
    }

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, 180);
    }else {
        CGFloat itemSizeWidth = (SCREENWIDTH - 40) / 4;
        return CGSizeMake(itemSizeWidth, itemSizeWidth);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.section ==> %ld ,     indexPath.row ==> %ld ",indexPath.section,indexPath.row);
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
                    order.index = 101;
                    [self.navigationController pushViewController:order animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
            case 1:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
                    order.index = 102;
                    [self.navigationController pushViewController:order animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
            case 2:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    JMRefundBaseController *refundVC = [[JMRefundBaseController alloc] init];
                    [self.navigationController pushViewController:refundVC animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
            case 3:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
                    order.index = 100;
                    [self.navigationController pushViewController:order animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:kISXLMM]) {
                        CSTabBarController *tabBarVC = [[CSTabBarController alloc] init];
                        JMKeyWindow.rootViewController = tabBarVC;
                    }else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还不是小鹿妈妈,请关注小鹿美美公众号,获取更多信息哦~" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
            case 1:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    JMComplaintSuggestController *yijianVC = [[JMComplaintSuggestController alloc] init];
                    [self.navigationController pushViewController:yijianVC animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
            case 2:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                    NSMutableDictionary *dictionDic = [NSMutableDictionary dictionary];
                    dictionDic[@"titleName"] = @"常见问题";
                    dictionDic[@"web_url"] = COMMONPROBLEM_URL;
                    WebViewController *webView = [[WebViewController alloc] init];
                    webView.webDiction = dictionDic;
                    webView.isShowNavBar = false;
                    webView.isShowRightShareBtn = false;
                    [self.navigationController pushViewController:webView animated:YES];
                }else{
                    [self displayLoginView];
                    return;
                }
                break;
                
            default:
                break;
        }
    }else {
        
    }

    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JMPersonalHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JMPersonalHeaderReusableViewIdentifier" forIndexPath:indexPath];
        return header;
    }else {
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENWIDTH, 0);
    }else {
        return CGSizeMake(SCREENWIDTH, 30);
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
}
- (void)composeActionView:(JMPersonalPageHeaderCell *)cell Button:(UIButton *)button {
    switch (button.tag) {
        case 100:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                JMSettingController *addressVC = [[JMSettingController alloc] init];
                addressVC.userInfoDict = _persinCenterDict;
                [self.navigationController pushViewController:addressVC animated:YES];
            }else{
                [self displayLoginView];
            }
            break;
        case 101:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
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
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                JMMineIntegralController *jifenVC = [[JMMineIntegralController alloc] init];
                jifenVC.xiaoluCoin = _persinCenterDict[@"xiaolu_coin"];
                [self.navigationController pushViewController:jifenVC animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            
            break;
        case 103:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
                JMCouponController *couponVC = [[JMCouponController alloc] init];
                [self.navigationController pushViewController:couponVC animated:YES];
            }else{
                [self displayLoginView];
                return;
            }
            break;
        default:
            break;
    }
    
    
    
}






























@end































/*
 100: 头像
 101: 零钱
 102: 积分
 103: 优惠券
 104: 待支付
 105: 待收货
 106: 退换货
 107: 我的订单
 108: 我的微店
 109: 投诉建议
 110: 常见问题
 */





/*
 
 - (void)buttonClick:(UIButton *)button {
 switch (button.tag) {
 case 100:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 JMSettingController *addressVC = [[JMSettingController alloc] init];
 addressVC.userInfoDict = _persinCenterDict;
 [self.navigationController pushViewController:addressVC animated:YES];
 }else{
 [self displayLoginView];
 }
 break;
 case 101:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
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
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 JMMineIntegralController *jifenVC = [[JMMineIntegralController alloc] init];
 [self.navigationController pushViewController:jifenVC animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 
 break;
 case 103:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 JMCouponController *couponVC = [[JMCouponController alloc] init];
 [self.navigationController pushViewController:couponVC animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 default:
 break;
 }
 
 }
 
 

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 if (indexPath.section == 0) {
 switch (indexPath.row) {
 case 0:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
 order.index = 101;
 [self.navigationController pushViewController:order animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 case 1:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
 order.index = 102;
 [self.navigationController pushViewController:order animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 case 2:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 JMRefundBaseController *refundVC = [[JMRefundBaseController alloc] init];
 [self.navigationController pushViewController:refundVC animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 case 3:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
 order.index = 100;
 [self.navigationController pushViewController:order animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 
 default:
 break;
 }
 }else {
 switch (indexPath.row) {
 case 0:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kISXLMM]) {
 CSTabBarController *tabBarVC = [[CSTabBarController alloc] init];
 JMKeyWindow.rootViewController = tabBarVC;
 }else {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还不是小鹿妈妈,请关注小鹿美美公众号,获取更多信息哦~" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
 [alertView show];
 }
 }else{
 [self displayLoginView];
 return;
 }
 break;
 case 1:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 JMComplaintSuggestController *yijianVC = [[JMComplaintSuggestController alloc] init];
 [self.navigationController pushViewController:yijianVC animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 case 2:
 if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
 NSMutableDictionary *dictionDic = [NSMutableDictionary dictionary];
 dictionDic[@"titleName"] = @"常见问题";
 dictionDic[@"web_url"] = COMMONPROBLEM_URL;
 WebViewController *webView = [[WebViewController alloc] init];
 webView.webDiction = dictionDic;
 webView.isShowNavBar = true;
 webView.isShowRightShareBtn = false;
 [self.navigationController pushViewController:webView animated:YES];
 }else{
 [self displayLoginView];
 return;
 }
 break;
 
 default:
 break;
 }
 }
 
 }

 */



/*
 
 #pragma mark 创建tableView
 - (void)createTableView {
 self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49) style:UITableViewStyleGrouped];
 self.tableView.delegate = self;
 self.tableView.dataSource = self;
 self.tableView.rowHeight = 60.;
 self.tableView.backgroundColor = [UIColor countLabelColor];
 self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
 self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 [self.view addSubview:self.tableView];
 }
 // =======================================================================================================================
 //                              UITableViewDelegate,UITableViewDataSource
 // =======================================================================================================================
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return self.dataSource.count;
 }
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 NSArray *arr = self.dataSource[section];
 return arr.count;
 }
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *cellID = @"JMPersonalPageCellIdentifier";
 JMPersonalPageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
 if (!cell) {
 cell = [[JMPersonalPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
 }
 NSDictionary *dict = self.dataSource[indexPath.section][indexPath.row];
 [cell config:dict Section:indexPath.section Index:indexPath.row];
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 return cell;
 }
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 20;
 }
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 UIView *sectionView = [UIView new];
 sectionView.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
 sectionView.backgroundColor = [UIColor lineGrayColor];
 return sectionView;
 }
 -(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
 return 0.01;
 }
 - (void)createHeaderView {
 //    kWeakSelf
 CGFloat headerW = SCREENWIDTH;
 CGFloat headerH = 0.;
 CGFloat imageSpace = 40.;
 CGRect mainSize = [UIScreen mainScreen].bounds;
 if (mainSize.size.height > 600) {
 headerH = mainSize.size.height * 0.29f;
 } else if (mainSize.size.height > 550){
 headerH = mainSize.size.height * 0.33f;
 } else {
 headerH = mainSize.size.height * 0.35f;
 imageSpace = 24.;
 }
 //    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, headerH)];
 //    self.tableView.tableHeaderView = headerView;
 //    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerW, headerH)];
 //    [headerView addSubview:headView];
 
 UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, headerH)];
 topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
 topImageView.userInteractionEnabled = YES;
 self.tableView.tableHeaderView = topImageView;
 
 
 UIButton *headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
 [topImageView addSubview:headImageButton];
 headImageButton.tag = 100;
 [headImageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 self.userIconImage = [UIImageView new];
 self.userIconImage.backgroundColor = [UIColor whiteColor];
 self.userIconImage.layer.cornerRadius = 30;
 self.userIconImage.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
 self.userIconImage.layer.masksToBounds = YES;
 self.userIconImage.layer.borderWidth = 1;
 [headImageButton addSubview:self.userIconImage];
 
 self.redCircle = [UILabel new];
 [headImageButton addSubview:self.redCircle];
 self.redCircle.hidden = YES;
 
 self.userNameLabel = [UILabel new];
 self.userNameLabel.font = CS_SYSTEMFONT(12.);
 self.userNameLabel.textColor = [UIColor whiteColor];
 self.userNameLabel.text = @"未登录";
 [topImageView addSubview:self.userNameLabel];
 
 [headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.equalTo(topImageView).offset(imageSpace);
 make.centerX.equalTo(topImageView.mas_centerX);
 make.width.height.mas_equalTo(@60);
 }];
 [self.userIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
 make.center.equalTo(headImageButton);
 make.width.height.mas_equalTo(@60);
 }];
 [self.redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(headImageButton.mas_centerX).offset(20);
 make.centerY.equalTo(headImageButton.mas_centerY).offset(-20);
 make.width.height.mas_equalTo(@10);
 }];
 [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(topImageView.mas_centerX);
 make.top.equalTo(self.userIconImage.mas_bottom).offset(10);
 }];
 //    UILabel *currentLabel = [UILabel new];
 //    [headView addSubview:currentLabel];
 //    currentLabel.backgroundColor = [UIColor blackColor];
 //    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 //        make.left.bottom.equalTo(headView);
 //        make.width.mas_equalTo(@(SCREENWIDTH));
 //        make.height.mas_equalTo(@1);
 //    }];
 
 CGFloat headButtonSpace = 20 * HomeCategoryRatio;
 CGFloat buttonW = (headerW - headButtonSpace * 2) / 3;
 NSArray *imageArr = @[@"accounticon",@"pointicon",@"coupon"];
 NSArray *titleArr = @[@"零钱",@"积分",@"优惠券"];
 for (int i = 0; i < 3; i++) {
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 [topImageView addSubview:button];
 button.frame = CGRectMake(headButtonSpace + buttonW * i, headerH - 60, buttonW, 60);
 button.tag = 101 + i;
 [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 UILabel *valueLabel = [UILabel new];
 [button addSubview:valueLabel];
 valueLabel.font = CS_SYSTEMFONT(16.);
 valueLabel.textColor = [UIColor whiteColor];
 valueLabel.tag = 10 + i;
 UIImageView *imageV = [UIImageView new];
 [button addSubview:imageV];
 imageV.image = [UIImage imageNamed:imageArr[i]];
 UILabel *titleLabel = [UILabel new];
 [button addSubview:titleLabel];
 titleLabel.font = CS_SYSTEMFONT(9.);
 titleLabel.textColor = [UIColor whiteColor];
 titleLabel.alpha = 0.75;
 titleLabel.text = titleArr[i];
 NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:9.] forKey:NSFontAttributeName];
 CGSize size = [titleArr[i] sizeWithAttributes:dic];
 
 CGFloat imageW = 0.;
 CGFloat imageH = 0.;
 if (i == 0) {
 imageW = 13.;
 imageH = 10;
 }else if(i == 1) {
 imageW = 11.;
 imageH = 11;
 }else {
 imageW = 11.;
 imageH = 13;
 }
 NSInteger spaceTitle = (buttonW - size.width - imageW) / 2;
 [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(button.mas_centerX);
 make.top.equalTo(button).offset(4);
 }];
 [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(button).offset(spaceTitle);
 make.top.equalTo(valueLabel.mas_bottom).offset(1);
 make.width.mas_equalTo(@(imageW));
 make.height.mas_equalTo(@(imageH));
 }];
 [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(imageV.mas_right).offset(2);
 make.centerY.equalTo(imageV.mas_centerY);
 }];
 
 }
 
 self.smallChangeLabel = (UILabel *)[self.view viewWithTag:10];
 self.integralLabel = (UILabel *)[self.view viewWithTag:11];
 self.couponLabel = (UILabel *)[self.view viewWithTag:12];
 self.smallChangeLabel.text = @"0.00";
 self.integralLabel.text = @"0";
 self.couponLabel.text = @"0";
 
 }

 */































//
//  MMRootViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMRootViewController.h"
#import <RESideMenu.h>
#import "ChildViewController.h"
#import "MMClass.h"
#import "JMLogInViewController.h"
#import "UIImage+ColorImage.h"
#import "CartViewController.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "MMCartsView.h"
#import "MMNavigationDelegate.h"
#import "JMLogInViewController.h"
#import "WXApi.h"
#import "MaMaViewController.h"
#import "MMLoginStatus.h"
#import "NSString+Encrypto.h"
#import "PublishNewPdtViewController.h"
#import "ActivityView.h"
#import "MMAdvertiseView.h"
#import "MMAdvertiseView.h"
#import "WebViewController.h"
#import "ActivityModel.h"
#import "JMRootgoodsCell.h"
#import "MJPullGifHeader.h"
#import "JumpUtils.h"
#import "ImageUtils.h"
#import "JMRootScrolCell.h"
#import "BrandGoodsModel.h"
#import "XlmmMall.h"
#import "MMDetailsViewController.h"
#import "JMFirstOpen.h"
#import "AppDelegate.h"
#import "UIView+RGSize.h"
#import "JMRepopView.h"
#import "JMPopViewAnimationDrop.h"
#import "JMPopViewAnimationSpring.h"
#import "JMHelper.h"
#import "JMDBManager.h"
#import "JMUpdataAppPopView.h"
#import "JMMaMaPersonCenterController.h"
#import "JMStoreupController.h"
#import "JMGoodsDetailController.h"
#import "PosterModel.h"
#import "JMRootGoodsModel.h"

#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"
#define ABOVEHIGHT 300
#define ACTIVITYHEIGHT 120
#define BRAND_HEIGHT 200

#define YESTDAY @"yestday"
#define TODAY @"today"
#define TOMORROW @"tomorrow"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height


#define CELLWIDTH ([UIScreen mainScreen].bounds.size.width * 0.5)

#define TAG_ACTIVITY_BASE 120
#define TAG_ROOT_VIEW_BASE 1000
#define TAG_BACK_SCROLLVIEW  (TAG_ROOT_VIEW_BASE)
#define TAG_GOODS_YESTODAY_SCROLLVIEW (TAG_ROOT_VIEW_BASE+1)
#define TAG_GOODS_TODAY_SCROLLVIEW (TAG_ROOT_VIEW_BASE+2)
#define TAG_GOODS_TOMORROW_SCROLLVIEW (TAG_ROOT_VIEW_BASE+3)
#define TAG_COLLECTION_SCROLLVIEW (TAG_ROOT_VIEW_BASE+4)
#define TAG_BTN_YESTODAY (TAG_ROOT_VIEW_BASE+5)
#define TAG_BTN_TODAY (TAG_ROOT_VIEW_BASE+6)
#define TAG_BTN_TOMORROW (TAG_ROOT_VIEW_BASE+7)
#define TAG_IMG_YESTODAY (TAG_ROOT_VIEW_BASE+8)
#define TAG_IMG_TODAY (TAG_ROOT_VIEW_BASE+9)
#define TAG_IMG_TOMORROW (TAG_ROOT_VIEW_BASE+10)
//因为可能有多个品牌,那么先预留500个
#define TAG_COLLECTION_BRAND (TAG_ROOT_VIEW_BASE+11)
#define TAG_COLLECTION_BRAND_END (TAG_ROOT_VIEW_BASE+11+500)

@interface MMRootViewController ()<JMRepopViewDelegate,MMNavigationDelegate, WXApiDelegate,JMUpdataAppPopViewDelegate>{
    UIView *_view;
    UIPageViewController *_pageVC;
    NSArray *_pageContentVC;
    NSInteger _pageCurrentIndex;
    UIButton *leftButton;
    BOOL _isFirst;
    NSInteger goodsCount;
    UILabel *label;
    CGRect frame;
    NSInteger _currentIndex;
    NSInteger _currentPage;
    UIBarButtonItem *rightItem;
    UIView *dotView;
    UILabel *countLabel;
    NSNumber *last_created;
    NSTimer *theTimer;
    NSTimer *saleTimer;
    
    BOOL login_required;
    UIView *backView;
    NSDictionary *huodongJson;
    float allActivityHeight;
    float allBrandHeight;
    
    NSMutableDictionary *_diction;
    
    NSString *_releaseNotes;
}

@property (nonatomic, strong)ActivityView *startV;
@property (nonatomic, strong)NSTimer *sttime;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)NSString *imageUrl;

//新页面属性
//@property (nonatomic, strong)UIScrollView *backScrollview;
//@property (nonatomic, strong)UIView *aboveView;
//@property (nonatomic, strong)UIView *bannerView;
//@property (nonatomic, strong)UIView *childAndWomanView;
//@property (nonatomic, strong)UIView *goodsView;

@property (nonatomic, strong)UICollectionView *homeCollectionView;

@property (nonatomic, strong) NSMutableArray *posterImages;
@property (nonatomic, strong) NSMutableArray *posterDataArray;

@property (nonatomic, strong)NSArray *activityArr;
@property (nonatomic, strong)NSMutableArray *activityDataArr;

@property (nonatomic, strong)NSMutableArray *brandArr;
@property (nonatomic, strong)NSMutableArray *brandDataArr;
//商品
@property (nonatomic, strong)NSMutableArray *collectionArr;
@property (nonatomic, strong)NSMutableArray *collectionDataArr;
@property (nonatomic, strong)NSMutableDictionary *categoryDic;
@property (nonatomic, strong)NSMutableArray *urlArr;
@property (nonatomic, strong)NSArray *dickey;
//@property (nonatomic, strong)NSMutableArray *btnArr;

@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)NSMutableDictionary *nextdic;
@property (nonatomic, strong)NSMutableArray *endTime;

@property (nonatomic, copy) NSString *latestVersion;
@property (nonatomic, copy) NSString *trackViewUrl1;
@property (nonatomic, copy) NSString *trackName;


@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) JMRepopView *popView;

@property (nonatomic, strong) UIButton *topButton;
/**
 *  版本更新弹出视图
 */
@property (nonatomic, strong) JMUpdataAppPopView *updataPopView;
/**
 *  是否弹出更新视图
 */
@property (nonatomic, assign) BOOL isPopUpdataView;
@end


static NSString *ksimpleCell = @"JMRootgoodsCell";
static NSString *kbrandCell = @"JMRootScrolCell";

@implementation MMRootViewController {
    BOOL _isFirstOpenApp;
    
    BOOL _isStartDownload;
    
    NSString *_hash;
    NSString *_downloadURLString;
}

//- (UIScrollView *)backScrollview {
//    if (!_backScrollview) {
//        self.backScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT)];
//    }
//    return _backScrollview;
//}
//
//- (UIView *)aboveView {
//    if (!_aboveView) {
//        self.aboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, ABOVEHIGHT)];
//    }
//    return _aboveView;
//}
//
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
    }
    return _maskView;
}


- (NSMutableArray *)activityDataArr {
    if (!_activityDataArr) {
        self.activityDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _activityDataArr;
}

- (NSMutableArray *)brandArr {
    if (!_brandArr) {
        self.brandArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _brandArr;
}

- (NSMutableArray *)brandDataArr {
    if (!_brandDataArr) {
        self.brandDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _brandDataArr;
}

- (NSMutableArray *)collectionArr {
    if (!_collectionArr) {
        self.collectionArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionArr;
}

- (NSMutableArray *)collectionDataArr {
    if (!_collectionDataArr) {
        self.collectionDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionDataArr;
}

- (NSMutableDictionary *)categoryDic {
    if (!_categoryDic) {
        self.categoryDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [self.categoryDic setObject:arr forKey:self.dickey[i]];
        }
    }
    return _categoryDic;
}

- (NSMutableDictionary *)nextdic {
    if (!_nextdic) {
        self.nextdic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            NSString *arr = [NSString stringWithFormat:@""];
            [self.nextdic setObject:arr forKey:self.dickey[i]];
        }
    }
    return _nextdic;
}

- (NSMutableArray *)urlArr {
    if (!_urlArr) {
        self.urlArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _urlArr;
}

- (NSMutableArray *)endTime {
    if (!_endTime) {
        self.endTime = [NSMutableArray arrayWithCapacity:0];
    }
    return _endTime;
}
#pragma 领取优惠券
- (void)updataAfterLogin:(NSNotification *)notification{
    // 微信登录
    [self loginUpdateIsXiaoluMaMa];
    
}

- (void)phoneNumberLogin:(NSNotification *)notification{
    //  NSLog(@"手机登录");
    [self loginUpdateIsXiaoluMaMa];
    
    
}

- (BOOL)isXiaolumama{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isXLMM = [users boolForKey:@"isXLMM"];
    return isXLMM;
}

- (void)loginUpdateIsXiaoluMaMa {
    NSLog(@"loginUpdateIsXiaoluMaMa ");
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:self WithSuccess:^(id responseObject) {
        NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = responseObject;
        if (!responseObject){
            self.navigationItem.rightBarButtonItem = nil;
            [users setBool:NO forKey:@"isXLMM"];
            return;
        }
        
        NSLog(@"loginUpdateIsXiaoluMaMa %d", [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]);
        
        if([[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]){
            [self createRightItem];
            [users setBool:YES forKey:@"isXLMM"];
            
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
            [users setBool:NO forKey:@"isXLMM"];
        }
    } WithFail:^(NSError *error) {
        NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
        NSLog(@"get user profile failed.");
        self.navigationItem.rightBarButtonItem = nil;
        [users setBool:NO forKey:@"isXLMM"];
    } Progress:^(float progress) {
        
    }];
    [self isGetCoupon];
    
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    //    if (data == nil) {
    //        return NO;
    //    }
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //    NSLog(@"loginUpdateIsXiaoluMaMa dic = %@", dic);
    //    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
}

- (void)createRightItem{
    NSLog(@"createRightItem %@ %@", self.navigationItem.rightBarButtonItem , rightItem);
    if(self.navigationItem.rightBarButtonItem == nil){
        NSLog(@"createRightItem ");
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
        rightImageView.frame = CGRectMake(18, 11, 26, 26);
        [rightBtn addSubview:rightImageView];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else {
        
    }
}


#pragma mark 解析targeturl 跳转到不同的界面
- (void)presentView:(NSNotification *)notification{
    //跳转到新的页面
    [JumpUtils jumpToLocation:[notification.userInfo objectForKey:@"target_url"] viewController:self];
}

- (void)showNotification:(NSNotification *)notification{
    NSLog(@"弹出提示框");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 主界面初始化
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"MMRoot viewWillAppear");
    [super viewWillAppear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rootViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 64;
    cartView.frame = rect;
    //    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156 , 44, 44);
    [self setLabelNumber];
    
    if ([saleTimer isValid]) {
        [saleTimer invalidate];
    }
    saleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(saleTimerCallback:) userInfo:nil repeats:YES];
    [MobClick beginLogPageView:@"main"];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"MMRoot viewDidAppear");
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.backScrollview.delegate = self;
    self.categoryViewHeight.constant = SCREENHEIGHT + 64;
    
    if(!_isFirst){
        if([self checkNeedRefresh]){
            [self refreshView];
        }
    }
    _isFirst = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self autologin];
    } else {
        NSLog(@"no login");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"MMRoot viewWillDisappear");
    _isFirst = NO;
    [super viewWillDisappear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:app];
    
    self.navigationController.navigationBarHidden = YES;
    frame = self.view.frame;
    [MobClick endLogPageView:@"main"];
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"MMRoot viewDidDisappear");
    [super viewDidDisappear:animated];
    frame = self.view.frame;
}

- (void)viewDidLoad
{
    NSLog(@"MMRoot viewDidLoad");
    [super viewDidLoad];
    
    self.timeCount = 0;
    [self.endTime addObject:@""];
    [self.endTime addObject:@""];
    [self.endTime addObject:@""];
    
    //订阅展示视图消息，将直接打开某个分支视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
    //弹出消息框提示用户有订阅通知消息。主要用于用户在使用应用时，弹出提示框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification:) name:@"Notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(setLabelNumber) name:@"logout" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpHome:) name:@"fromActivityToToday" object:nil];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isFirst = YES;
    _view = self.view;
    
    _pageCurrentIndex = 0;
    self.currentIndex = 1;
    
    //设置导航栏样式
    [self createInfo];
    
    //    [self creatPageData];
    
//    [self islogin];
    NSLog(@"backScrollview %f", self.backScrollview.contentOffset.x);
    self.backScrollview.delegate = self;
    self.backScrollview.tag = TAG_BACK_SCROLLVIEW;
    
    self.posterImages = [[NSMutableArray alloc] init];
    self.posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //海报和活动展示
    [self showPromotion];
    
    
    //商品请求链接
    [self createRequestURL];
    //获取商品分类
    [self loadItemizeData];
    //推荐商品展示
    [self createCollectionView];
    //设置商品scrollview的偏转
    self.collectionViewScrollview.contentOffset = CGPointMake(SCREENWIDTH, 0);
    self.collectionViewScrollview.scrollsToTop = NO;
    [self changeBtnImg];
    
    [self createCartsView];
    
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.backScrollview.mj_header = header;
    
    
    [self autoUpdateVersion];
    
    _isFirstOpenApp = [JMFirstOpen isFirstLoadApp];
    if (_isFirstOpenApp) {
       [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(returnPopView) userInfo:nil repeats:NO];
    }else {
    }
    [self createTopButton];
    
    
    [self loadAddressInfo];

    self.session = [self backgroundSession];
}
#pragma mark --- 第一次打开程序
- (void)returnPopView {
    /**
     判断是否为第一次打开 -- 选择弹出优惠券弹窗
     */
//    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.maskView.backgroundColor = [UIColor blackColor];
//    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidepopView)]];
    JMRepopView *popView = [JMRepopView defaultPopView];
    self.popView = popView;
    self.popView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
}
- (void)composePayButton:(JMRepopView *)payButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hidepopView];
        BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (islogin) {
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/is_picked_register_gift_coupon", Root_URL];
            [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
                if (responseObject == nil) {
                    return ;
                }else {
                    NSInteger code = [responseObject[@"code"] integerValue];
                    NSInteger isPicked = [responseObject[@"is_picked"] integerValue];
                    if (code == 0) {
                        if (isPicked == 1) {
                            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                        }else {
                            [self pickCoupon];
                        }
                    }else {
                        [SVProgressHUD showErrorWithStatus:@"请登录"];
                    }
                }
            } WithFail:^(NSError *error) {
                
            } Progress:^(float progress) {
                
            }];
        }else {
            JMLogInViewController *logVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:logVC animated:YES];
        }
        
    }else {
        //取消按钮
        [self hidepopView];
    }
}
#pragma mark -- 判断用户是否领取优惠券
- (void)isGetCoupon {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/is_picked_register_gift_coupon", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            NSInteger isPicked = [responseObject[@"is_picked"] integerValue];
            if (code == 0) {
                if (isPicked == 0) {
                    [self returnPopView];
                }else {
                    //                    [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                }
            }else {
                [SVProgressHUD showErrorWithStatus:@"请登录"];
            }
            
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)pickCoupon {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_register_gift_coupon", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            }else {
                [SVProgressHUD showErrorWithStatus:@"领取失败"];
            }
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
/**
 *  隐藏
 */
- (void)hidepopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
}
- (void)rootViewWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    NSLog(@"Rootview enter foreground");
    [self autoUpdateVersion];
    
    if([self checkNeedRefresh]){
        [self refreshView];
    }
    if (self.isPopUpdataView == YES) {
        [self performSelector:@selector(updataAppPopView) withObject:nil afterDelay:10.0f];
    }else {
        
    }
    
}
#pragma mark 商品查询接口 --> (昨,今,明)
- (void)createRequestURL {
    [self.urlArr removeAllObjects];
    NSArray *urlBefroe = @[@"/rest/v2/modelproducts/yesterday?page=1&page_size=10",
                           @"/rest/v2/modelproducts/today?page=1&page_size=10",
                           @"/rest/v2/modelproducts/tomorrow?page=1&page_size=10"];
    for (int i = 0; i < 3; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [self.urlArr addObject:url];
    }
    
    self.dickey = @[YESTDAY, TODAY, TOMORROW];
}

- (void)showPromotion{
    //网络请求海报
    NSString *requestURL = [NSString stringWithFormat:@"%@/rest/v1/portal", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:requestURL WithParaments:self WithSuccess:^(id responseObject) {
        [self.backScrollview.mj_header endRefreshing];
        if (!responseObject) return;
        [self fetchedPromotionData:responseObject];
    } WithFail:^(NSError *error) {
        [self.backScrollview.mj_header endRefreshing];
    } Progress:^(float progress) {
        
    }];
    //活动
    /*NSString *activityUrl = [NSString stringWithFormat:@"%@/rest/v1/activitys", Root_URL];
     [manage GET:activityUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     self.activityArr = responseObject;
     if (self.activityArr.count == 0) return;
     [self activityDeal:self.activityArr];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     }];*/
}

- (void)createCollectionView {
    //设置collectionViewScrollview属性
    self.collectionViewScrollview.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
    self.collectionViewScrollview.pagingEnabled = YES;
    self.collectionViewScrollview.tag = TAG_COLLECTION_SCROLLVIEW;
    self.collectionViewScrollview.delegate = self;
    
    //创建3个collection
    for (int i = 0; i < 3; i++) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // CGFloat rightSize = ([UIScreen mainScreen].bounds.size.width - 78)/3;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        
        //高度需要去掉导航bar高度64+昨今明和倒计时时间80=144
        UICollectionView *homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT-144) collectionViewLayout:flowLayout];
        
        homeCollectionView.backgroundColor = [UIColor whiteColor];
        homeCollectionView.tag = TAG_GOODS_YESTODAY_SCROLLVIEW + i;
        homeCollectionView.scrollEnabled = NO;
        
        //添加上拉加载
        homeCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            NSString *nextStr = [self.nextdic objectForKey:self.dickey[self.currentIndex]];
            NSLog(@"MJFresh nextstr= %@ currentindex=%ld",nextStr, (long)self.currentIndex);
            if([nextStr class] == [NSNull class]) {
                [homeCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self loadMore];
        }];
        
        
        [self.collectionViewScrollview addSubview:homeCollectionView];
        
        homeCollectionView.delegate = self;
        homeCollectionView.dataSource = self;
        homeCollectionView.showsVerticalScrollIndicator = FALSE;
        
        //        [homeCollectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"picCollectionCell"];
        [homeCollectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:ksimpleCell];
        
        [self.collectionArr addObject:homeCollectionView];
    }
    
    //今日商品
    [self goodsRequest];
}

- (void)fetchedPromotionData:(NSDictionary *)jsonDic{
    if (jsonDic.count == 0) return;
    
    NSArray *childArray = [jsonDic objectForKey:@"posters"];
    
    
    [self.posterImages removeAllObjects];
    [self.posterDataArray removeAllObjects];
    
    if (childArray.count == 0)return;
    for (NSDictionary *childDic in childArray) {
        PosterModel *childModel = [PosterModel new];
        
        childModel.target_link = [childDic objectForKey:@"app_link"];
        childModel.imageURL = [childDic objectForKey:@"pic_link"];
        childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
        childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
        
        NSLog(@"posterImages url = %@", [childModel.imageURL JMUrlEncodedString]);
        //        UIImage *image0 = [UIImage imagewithURLString:[[childModel.imageURL URLEncodedString] imageNormalCompression]];
        //        if (image0 == nil) {
        //            image0 = [UIImage imageNamed:@"placeHolderPosterImage.png"];
        //        }
        
        [self.posterImages addObject:childModel.imageURL];
        [self.posterDataArray addObject:childModel];
        
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, 150)];
    NSLog(@"poster url %@", [NSURL URLWithString:[[[childArray[0] objectForKey:@"pic_link"] JMUrlEncodedString] imageNormalCompression]]);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[[[childArray[0] objectForKey:@"pic_link"] JMUrlEncodedString] imageNormalCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //通过加载图片得到其高度wa
        float h;
        if((image == nil) || (image.size.width == 0)){
            h = 150;
        }
        else{
            h = image.size.height * (WIDTH /image.size.width);
        }
        NSLog(@"poster height %f %f", image.size.height, h);
        self.bannerHeight.constant = h;
        self.aboveHeight.constant = h+120;
        [imgView removeFromSuperview];
        MMAdvertiseView *adView = [[MMAdvertiseView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, h) andImages:self.posterImages];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
        [adView.scrollView addGestureRecognizer:tap];
        
        [self.bannerView addSubview:adView];
    }];
    [self.bannerView addSubview:imgView];
    [imgView removeFromSuperview];
    
    //    MMAdvertiseView *adView = [[MMAdvertiseView alloc] initWithFrame:self.bannerView.bounds andImages:self.posterImages];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
    //    [adView.scrollView addGestureRecognizer:tap];
    //
    //    [self.bannerView addSubview:adView];
    
    [self initCategoryLvl1Img:jsonDic];
    
    //活动
    [self initActivity:jsonDic];
    //品牌
    [self initBrand:jsonDic];
}

- (void)initCategoryLvl1Img:(NSDictionary *)jsonDic{
    NSArray *categorys = [jsonDic objectForKey:@"categorys"];
    
    if (categorys.count < 2)return;
    
    self.childImgView.contentMode=UIViewContentModeScaleAspectFit;
    self.womenImgView.contentMode=UIViewContentModeScaleAspectFit;
    [ImageUtils loadImage:self.childImgView url:[categorys[0] objectForKey:@"cat_img"]];
    [ImageUtils loadImage:self.womenImgView url:[categorys[1] objectForKey:@"cat_img"]];
    
    [self.womenImgView setUserInteractionEnabled:YES];
    [self.childImgView setUserInteractionEnabled:YES];
    [self.womenImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategoryLvl1:)]];
    [self.childImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategoryLvl1:)]];
    
}

- (void)initActivity:(NSDictionary *)jsonDic{
    NSArray *activitys = [jsonDic objectForKey:@"activitys"];
    NSLog(@"initActivity count=%lu",(unsigned long)activitys.count );
    
    self.activityArr = activitys;
    [self.activityDataArr removeAllObjects];
    
    if (activitys.count ==0){
        self.activityHeight.constant = 0;
        [self.view layoutIfNeeded];
        return;
    }
    
    //[self.view layoutIfNeeded];
    
    
    [self activityDeal:self.activityArr];
    
}

- (void)initBrand:(NSDictionary *)jsonDic{
    NSArray *brands = [jsonDic objectForKey:@"promotion_brands"];
    NSLog(@"initBrand count=%lu",(unsigned long)brands.count );
    
    self.brandArr = brands;
    [self.brandDataArr removeAllObjects];
    
    if (brands.count ==0){
        self.brandViewHeight.constant = 0;
        [self.view layoutIfNeeded];
        return;
    }
    
    for (NSDictionary *brandDic in brands) {
        ActivityModel *brandM = [[ActivityModel alloc] init];
        [brandM setValuesForKeysWithDictionary:brandDic];
        [self.brandDataArr addObject:brandM];
    }
    
    self.brandViewHeight.constant = BRAND_HEIGHT * brands.count;
    
    [self.view layoutIfNeeded];
    
    allBrandHeight = 0;
    NSInteger index = 0;
    for(NSDictionary *brand in brands){
        NSLog(@"x=%f y=%f url=%@, allBrandHeight=%f",self.brandView.frame.origin.x,
              self.brandView.frame.origin.y,
              [brand objectForKey:@"act_logo"], allBrandHeight);
        
        UIView *oneBrandView = [[UIView alloc] initWithFrame:CGRectMake(0, allBrandHeight, WIDTH, BRAND_HEIGHT)];
        [self.brandView addSubview:oneBrandView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, allBrandHeight, WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        [oneBrandView addSubview:lineView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 20)];
        [ImageUtils loadImage:imageView url:[brand objectForKey:@"act_logo"]];
        [oneBrandView addSubview:imageView];
        
        NSString *tail_title;
        if([brand objectForKey:@"extras"] != NULL){
            if([[brand objectForKey:@"extras"] objectForKey:@"brandinfo"] != NULL){
                tail_title= [[[brand objectForKey:@"extras"] objectForKey:@"brandinfo"] objectForKey:@"tail_title"];
            }
        }
        UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH -60, 10 , 50, 20)];
        NSLog(@"tail_title=%@", tail_title);
        if(tail_title != NULL){
            textView.text = tail_title;
        }
        textView.font = [UIFont fontWithName:@"Arial" size:14.0];
        textView.textColor = [UIColor blackColor];
//        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [oneBrandView addSubview:textView];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 20, 15, 10, 10)];
        UIImage *image = [UIImage imageNamed:@"icon-jiantouyou"];
        arrowView.image = image;
        [oneBrandView addSubview:arrowView];
        
//        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 1)];
//        lineView1.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
//        [oneBrandView addSubview:lineView1];
        
        //展示品牌入口
        UIImageView *topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, SCREENWIDTH, 145)];
        
        topicImageView.tag = TAG_COLLECTION_BRAND + index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandTapAction:)];
        topicImageView.userInteractionEnabled = YES;
        [topicImageView addGestureRecognizer:tap];
        
        ActivityModel *acM = self.brandDataArr[index];
        [topicImageView sd_setImageWithURL:[NSURL URLWithString:acM.act_img] placeholderImage:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //通过加载图片得到其高度
                                float h;
                                if((image == nil) || (image.size.width == 0)){
                                    h = BRAND_HEIGHT;
                                }
                                else{
                                    h = image.size.height * (WIDTH /image.size.width);
                                }
                                NSLog(@"topic height %f %f allBrandHeight=%f", image.size.height, h, allBrandHeight);
                                topicImageView.frame = CGRectMake(0, 45, SCREENWIDTH, h);
                                oneBrandView.frame = CGRectMake(0, allBrandHeight, SCREENWIDTH, h+55);
                                allBrandHeight += h + 55;
                                
                                NSLog(@"all topicHeight %f", allBrandHeight);
                                
                                self.brandViewHeight.constant = allBrandHeight;
                            }];
        [oneBrandView addSubview:topicImageView];
        
//        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, BRAND_HEIGHT - 1 + BRAND_HEIGHT * index, WIDTH, 1)];
//        lineView2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
//        [self.brandView addSubview:lineView2];
        
        index++;
    }
}

- (BOOL)checkNeedRefresh{
    //判断上架deadline时间不一致那么就刷新，考虑场景是10点上新时自动刷新
    
    if(self.endTime.count==0 ||
       [self.endTime[1] isEqualToString:@""])
        return TRUE;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // NSDateComponents *comps =
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    
    NSDate *todate;
    
    NSMutableString *string = [NSMutableString stringWithString:self.endTime[1]];
    NSRange range = [self.endTime[1] rangeOfString:@"T"];
    [string replaceCharactersInRange:range withString:@" "];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    todate = [dateformatter dateFromString:string];
    
    NSDate *date = [NSDate date];
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ([d hour] < 0 || [d minute] < 0) {
        NSLog(@"need refresh");
        return TRUE;
    }
    
    NSLog(@"not need refresh");
    return FALSE;
}

- (void )refreshView{
    [self removeAllSubviews:self.bannerView];
    [self removeAllSubviews:self.activityView];
    [self removeAllSubviews:self.brandView];
    [self showPromotion];
    
    [self.nextdic setObject:@"" forKey:self.dickey[self.currentIndex]];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:self.dickey[self.currentIndex]];
    [currentArr removeAllObjects];
    
    UICollectionView *collection = self.collectionArr[self.currentIndex];
    [collection.mj_footer resetNoMoreData];
    [collection reloadData];
    
    [self createRequestURL];
    [self goodsRequest];
}

- (void)removeAllSubviews:(UIView *)v{
    while (v.subviews.count) {
        UIView* child = v.subviews.lastObject;
        [child removeFromSuperview];
    }
}
#pragma mark --定时器callback

- (void)saleTimerCallback:(NSTimer*)theTimer
{
    if(self.endTime.count==0 ||
       [self.endTime[self.currentIndex] isEqualToString:@""])
        return;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // NSDateComponents *comps =
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    
    NSDate *todate;
    
    NSMutableString *string = [NSMutableString stringWithString:self.endTime[self.currentIndex]];
    NSRange range = [self.endTime[self.currentIndex] rangeOfString:@"T"];
    [string replaceCharactersInRange:range withString:@" "];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    todate = [dateformatter dateFromString:string];
    
    NSDate *date = [NSDate date];
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ([d hour] < 0 || [d minute] < 0) {
        self.labelTime.text = @"00时00分00秒";
        //   NSLog(@"已下架");
    } else{
        NSString *string;
        if ((long)[d day] == 0) {
            string = [NSString stringWithFormat:@"%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
        }
        else{
            string = [NSString stringWithFormat:@"%02ld时%02ld分%02ld秒", (long)[d day]*24+(long)[d hour], (long)[d minute], (long)[d second]];
            
        }
        
        self.labelTime.text = string;
        
    }
    
    
}

#pragma mark --商品列表

- (void)goodsRequest{
    NSString *currentUrl = self.urlArr[self.currentIndex];
    NSInteger requestIndex = self.currentIndex;
    NSLog(@"goodsRequest currentUrl=%@ index=%ld",currentUrl ,(long)self.currentIndex);
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:currentUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        if(requestIndex != self.currentIndex){
            NSLog(@"user change currentindex %ld %ld", requestIndex, self.currentIndex);
            return;
        }
        [self goodsResult:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)goodsResult:(NSDictionary *)dic {
    if ([[dic objectForKey:@"next"] class] == [NSNull class]) {
        [self.nextdic setObject:@"" forKey:self.dickey[self.currentIndex]];
        NSLog(@"goodsResult NEXT=null");
    }else {
        [self.nextdic setObject:[dic objectForKey:@"next"] forKey:self.dickey[self.currentIndex]];
        NSLog(@"goodsResult NEXT=%@ index=%ld",[dic objectForKey:@"next"], (long)self.currentIndex);
    }
    
    NSLog(@"Deadline=%@",[dic objectForKey:@"downshelf_deadline"]);
    NSString *deadline = [dic objectForKey:@"downshelf_deadline"];
    NSString *starttime = [dic objectForKey:@"upshelf_starttime"];
    if(self.currentIndex != 2){
        if(deadline != nil){
            [self.endTime replaceObjectAtIndex: self.currentIndex  withObject: deadline];
        }
    }
    else{
        if(starttime != nil){
            [self.endTime replaceObjectAtIndex: self.currentIndex  withObject: starttime];
        }
    }
    
    NSArray *results = [dic objectForKey:@"results"];
    if ((results == nil) || (results.count == 0)) {
        return;
    }
    NSLog(@"result count=%ld", (unsigned long)results.count );
    
    //判断在数据源字典中是否有对应的数组
    NSMutableArray *numArray = [[NSMutableArray alloc] init];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:self.dickey[self.currentIndex]];
    for (NSDictionary *goods in results) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:goods];
        
        NSIndexPath *index ;
        
        index = [NSIndexPath indexPathForRow:currentArr.count inSection:0];
        [currentArr addObject:model];
        [numArray addObject:index];
    }
    
    UICollectionView *collection = self.collectionArr[self.currentIndex];
    
    if((numArray != nil) && (numArray.count > 0)){
        @try{
            [collection insertItemsAtIndexPaths:numArray];
            [numArray removeAllObjects];
            numArray = nil;
        }
        @catch(NSException *except)
        {
            NSLog(@"DEBUG: failure to batch update.  %@", except.description);
        }
    }
    
    [collection reloadData];
    
}

- (void)loadMore {
    //NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
    NSString *url = [self.nextdic objectForKey:self.dickey[self.currentIndex]];
    
    NSLog(@"loadmore index=%@ url=%@",self.dickey[self.currentIndex], url);
    if((nil == url) || ([url isEqualToString:@""])){
        UICollectionView *collection = self.collectionArr[self.currentIndex];
        [collection.mj_footer endRefreshing];
        [collection.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    self.collectionViewScrollview.scrollEnabled = NO;
    
    NSInteger requestIndex = self.currentIndex;
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        //在这个地方会有个异步场景，可能我在currentindex＝0时正在loadmore，此处应答还未回来时用户又做了横向滑动，currentindex改变了；
        //然后再回到这个回调，获得的currentidnex已经不是0了，导致刷新的是其它的collection。这里有2个修改方法：1是刷新时禁止横向滑动；
        //2是刷新时可以横向滑动，但是记录是刷新的哪个currentindex，如果当前的index和记录的不一致的话，此次刷新不做;使用方法1 2结合
        UICollectionView *collection = self.collectionArr[requestIndex];
        [collection.mj_footer endRefreshing];
        
        if (!responseObject){
            self.collectionViewScrollview.scrollEnabled = YES;
            return;
        }
        if(requestIndex != self.currentIndex){
            NSLog(@"user change index %ld %ld", requestIndex, self.currentIndex);
            self.collectionViewScrollview.scrollEnabled = YES;
            return;
        }
        
        [self goodsResult:responseObject];
        self.collectionViewScrollview.scrollEnabled = YES;
    } WithFail:^(NSError *error) {
        UICollectionView *collection = self.collectionArr[self.currentIndex];
        [collection.mj_footer endRefreshing];
        self.collectionViewScrollview.scrollEnabled = YES;
    } Progress:^(float progress) {
        
    }];
}


#pragma mark --活动和活动弹窗处理
- (void)activityDeal:(NSArray *)activityArr {
    for (NSDictionary *actityDic in activityArr) {
        ActivityModel *activityM = [[ActivityModel alloc] init];
        [activityM setValuesForKeysWithDictionary:actityDic];
        [self.activityDataArr addObject:activityM];
    }
    
    allActivityHeight = 0;
    //创建活动展示图
    for (int i = 0; i < self.activityDataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+ACTIVITYHEIGHT * i, SCREENWIDTH, ACTIVITYHEIGHT)];
        
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.autoresizesSubviews = YES;
        //        imageView.autoresizingMask =
        //        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.tag = TAG_ACTIVITY_BASE + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTapAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [self.activityView addSubview:imageView];
        
        ActivityModel *acM = self.activityDataArr[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:acM.act_img] placeholderImage:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //通过加载图片得到其高度
                                float h;
                                if((image == nil) || (image.size.width == 0)){
                                    h = ACTIVITYHEIGHT;
                                }
                                else{
                                    h = image.size.height * (WIDTH /image.size.width);
                                }
                                NSLog(@"activity height %f %f", image.size.height, h);
                                imageView.frame = CGRectMake(0, 10+allActivityHeight, SCREENWIDTH, h);
                                allActivityHeight += h + 10;
                                
                                NSLog(@"allActivityHeight %f", allActivityHeight);
                                
                                self.activityHeight.constant = allActivityHeight;
                            }];
        
        
    }
    
    
    
    huodongJson = [activityArr firstObject];
    if ([huodongJson isKindOfClass:[NSDictionary class]]) {
        login_required = [[huodongJson objectForKey:@"login_required"] boolValue];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *activityID = [huodongJson objectForKey:@"id"];
        NSNumber *userNumber = [defaults objectForKey:@"activityid"];
        
        if ([userNumber integerValue] == [activityID integerValue]) return;
        //活动弹框
        if (!([[huodongJson objectForKey:@"mask_link"] class] == [NSNull class])
            && (![[huodongJson objectForKey:@"mask_link"]  isEqual: @""])) {
            NSString *imageUrl = [huodongJson objectForKey:@"mask_link"];
            
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:imageData];
                    [defaults setObject:activityID forKey:@"activityid"];
                    [self createActivityView:image];
                });
            });
        }
    }
}

//活动展示点击
- (void)activityTapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了 activityTapAction。。。。。");
    //判断点击的活动
    UIImageView *imageV = (UIImageView *)tap.view;
    NSInteger imageTag = imageV.tag - TAG_ACTIVITY_BASE;
    
    [self activityClick:self.activityArr[imageTag]];
}


- (void)createActivityView:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    [backView removeFromSuperview];
    
    //活动弹窗
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - imageWidth) * 0.5 , (SCREENHEIGHT - imageHeight) * 0.5, imageWidth, imageHeight)];
    imageView.image = image;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huodongrukou)];
    [imageView addGestureRecognizer:tap];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    [backView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageMaxX = CGRectGetMaxX(imageView.frame);
    CGFloat imageMinY = CGRectGetMinY(imageView.frame);
    button.frame = CGRectMake(imageMaxX - 40, imageMinY, 40, 40);
    [button setImage:[UIImage imageNamed:@"icon-guanbi.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(guanbiClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}

- (void)guanbiClicked:(UIButton *)button{
    [backView removeFromSuperview];
}

- (void)huodongrukou{
    [backView removeFromSuperview];
    [self activityClick:self.activityArr[0]];
}

#pragma mark ---- 点击活动事件处理
- (void)activityClick:(NSDictionary *)dic {
    [MobClick event:@"activity_click"];
    
    login_required = [[dic objectForKey:@"login_required"] boolValue];
    NSLog(@"Activity login required %d", login_required);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        WebViewController *huodongVC = [[WebViewController alloc] init];
        
        _diction = nil;
        NSString *active = @"active";
        _diction = [NSMutableDictionary dictionaryWithDictionary:dic];
        [_diction setValue:active forKey:@"type_title"];
        [_diction setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
        [_diction setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
        huodongVC.webDiction = _diction;
        huodongVC.isShowNavBar = true;
        huodongVC.isShowRightShareBtn = true;
        huodongVC.titleName = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:huodongVC animated:YES];
    } else{
        if (login_required) {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else{
            WebViewController *huodongVC = [[WebViewController alloc] init];
            
            _diction = nil;
            NSString *active = @"active";
            _diction = [NSMutableDictionary dictionaryWithDictionary:dic];
            [_diction setValue:active forKey:@"type_title"];
            [_diction setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
            [_diction setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
            
            huodongVC.webDiction = _diction;
            huodongVC.isShowNavBar = true;
            huodongVC.isShowRightShareBtn = true;
            huodongVC.titleName = [dic objectForKey:@"title"];
            [self.navigationController pushViewController:huodongVC animated:YES];
        }
    }
}

#pragma mark --品牌信息处理
//-(void)getBrandGoods:(NSString*)brandId index:(NSInteger)index{
//    NSLog(@"getBrandGoods %@", brandId);
//    //网络请求
//    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
//    NSString *requestURL = [NSString stringWithFormat:@"%@/rest/v1/brands/%@/products", Root_URL, brandId];
//    [manage GET:requestURL parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (!responseObject) return;
//        [self fetchedBrandData:responseObject index:index];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //未登录处理
//        //        [self showDefaultView];
//        NSLog(@"get brand goods failed.");
//    }];
//}
//
//- (void)fetchedBrandData:(NSDictionary *)jsonDic index:(NSInteger)index{
//    if (jsonDic.count == 0) return;
//    
//    NSArray *goodsArray = [jsonDic objectForKey:@"results"];
//    NSMutableArray *goods = [[NSMutableArray alloc] init];
//    
//    if (goodsArray.count == 0)return;
//    for (NSDictionary *product in goodsArray) {
//        BrandGoodsModel *goodsModel = [BrandGoodsModel new];
//        
//        goodsModel.brandID = [product objectForKey:@"id"];
//        goodsModel.product_id = [product objectForKey:@"product_id"];
//        goodsModel.product_name = [product objectForKey:@"product_name"] ;
//        goodsModel.product_img = [product objectForKey:@"product_img"];
//        goodsModel.product_lowest_price = [product objectForKey:@"product_lowest_price"];
//        goodsModel.product_std_sale_price = [product objectForKey:@"product_std_sale_price"];
//        
//        [goods addObject:goodsModel];
//        
//        
//        
//    }
//    [self.brandDataArr addObject:goods];
//    
//    UICollectionView *collection = self.brandArr[index];
//    [collection reloadData];
//    
//    
//}

- (void)brandTapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了 brandTapAction。。。。。");
    //判断点击的活动
    UIImageView *imageV = (UIImageView *)tap.view;
    NSInteger imageTag = imageV.tag - TAG_COLLECTION_BRAND;
    
    [self brandClick:self.brandArr[imageTag]];
}

- (void)brandClick:(NSDictionary *)dic {
    [MobClick event:@"brand_click"];
    
    login_required = [[dic objectForKey:@"login_required"] boolValue];
    NSString *app_link = [dic objectForKey:@"act_applink"];
    NSLog(@"Activity login required %d", login_required);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        if(app_link == NULL){
            WebViewController *huodongVC = [[WebViewController alloc] init];
            
            _diction = nil;
            NSString *active = @"active";
            _diction = [NSMutableDictionary dictionaryWithDictionary:dic];
            [_diction setValue:active forKey:@"type_title"];
            [_diction setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
            [_diction setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
            huodongVC.webDiction = _diction;
            huodongVC.isShowNavBar = true;
            huodongVC.isShowRightShareBtn = true;
            huodongVC.titleName = [dic objectForKey:@"title"];
            [self.navigationController pushViewController:huodongVC animated:YES];
        }
        else{
            [JumpUtils jumpToLocation:app_link viewController:self];
        }
    } else{
        if (login_required) {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else{
            if(app_link == NULL){
                WebViewController *huodongVC = [[WebViewController alloc] init];
                
                _diction = nil;
                NSString *active = @"active";
                _diction = [NSMutableDictionary dictionaryWithDictionary:dic];
                [_diction setValue:active forKey:@"type_title"];
                [_diction setValue:[dic objectForKey:@"id"] forKey:@"activity_id"];
                [_diction setValue:[dic objectForKey:@"act_link"] forKey:@"web_url"];
                
                huodongVC.webDiction = _diction;
                huodongVC.isShowNavBar = true;
                huodongVC.isShowRightShareBtn = true;
                huodongVC.titleName = [dic objectForKey:@"title"];
                [self.navigationController pushViewController:huodongVC animated:YES];
            }
            else{
                [JumpUtils jumpToLocation:app_link viewController:self];
            }

        }
    }
}

#pragma mark --点击
//poster click
- (void)tapgesture:(UITapGestureRecognizer *)gesture{
    [MobClick event:@"banner_click"];
    MMAdvertiseView *view =(MMAdvertiseView *)[gesture.view superview];
    PosterModel *model = self.posterDataArray[view.currentImageIndex];
    NSString *target_url = model.target_link;
    NSLog(@"poster click %@ index=%ld", target_url, view.currentImageIndex);
    [JumpUtils jumpToLocation:target_url viewController:self];
}

//women child click
-(void)clickCategoryLvl1:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"clickCategoryLvl1 click");
    //NSLog(@"%hhd",[gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]);
    
    UIView *viewClicked=[gestureRecognizer view];
    if (viewClicked==self.womenImgView) {
        NSLog(@"womenImgView");
        [MobClick event:@"women_click"];
        //跳到时尚女装
        ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
        womanVC.urlString = kLADY_LIST_URL;
        womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
        womanVC.childClothing = NO;
        
        [self.navigationController pushViewController:womanVC animated:YES];
    }else if(viewClicked==self.childImgView) {
        
        NSLog(@"childImgView");
        [MobClick event:@"child_click"];
        //跳到潮童专区
        ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
        childVC.urlString = kCHILD_LIST_URL;
        childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
        childVC.childClothing = YES;
        
        [self.navigationController pushViewController:childVC animated:YES];
    }
    
}

//今昨明按钮点击
- (void)categoryBtnClick:(UIButton *)btn {
    NSInteger tag = btn.tag - (TAG_BTN_YESTODAY);
    self.currentIndex = tag;
    
    //循环遍历改变背景
    [self changeBtnImg];
    if(self.currentIndex == 0){
        [MobClick event:@"yestoday"];
    }else if(self.currentIndex == 1){
        [MobClick event:@"today"];
    }else if(self.currentIndex == 2){
        [MobClick event:@"tomorrow"];
    }

    //改变scrollview的偏移
    NSLog(@"-categoryBtnClick-currentIndex---%ld", (long)self.currentIndex);
    self.collectionViewScrollview.contentOffset = CGPointMake(tag *SCREENWIDTH, 0);
    
    //如果没有数据重新请求，有的话不作操作
    NSString *key = self.dickey[tag];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
    if((currentArr != nil) && (currentArr.count == 0)){
        [self goodsRequest];
    }
    
}

-(void)changeBtnImg{
    UIButton *btn;
    
    if(self.currentIndex == 0){
        btn = [self.categoryView viewWithTag:TAG_BTN_YESTODAY];
        //[uiv setImage:[UIImage imageNamed:@"yestday1.png"]];
        [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TODAY];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TOMORROW];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.labelIndicate.text = @"距本场结束";
    }
    else if(self.currentIndex == 1){
        btn = [self.categoryView viewWithTag:TAG_BTN_YESTODAY];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TODAY];
        [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TOMORROW];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.labelIndicate.text = @"距本场结束";
    }else if(self.currentIndex == 2){
        btn = [self.categoryView viewWithTag:TAG_BTN_YESTODAY];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TODAY];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn = [self.categoryView viewWithTag:TAG_BTN_TOMORROW];
        [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
        
        self.labelIndicate.text = @"距本场开始";
    }
}

#pragma mark --collection的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if((collectionView.tag >= TAG_COLLECTION_BRAND)
       && (collectionView.tag <= TAG_COLLECTION_BRAND_END)){
        NSLog(@"brand collection");
        return 0;
    }
    else{
        NSLog(@"arr collection");
        NSString *key = self.dickey[self.currentIndex];
        NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
        return currentArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if((collectionView.tag >= TAG_COLLECTION_BRAND)
       && (collectionView.tag <= TAG_COLLECTION_BRAND_END)){
        //NSLog(@"brand collection cellForItemAtIndexPath");
        JMRootScrolCell *cell = (JMRootScrolCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kbrandCell forIndexPath:indexPath];
        // == 有问题 ????? == //
        int index = 0;//JMRootgoodsCell
        for(NSMutableArray *obj in self.brandDataArr)
        {
            //NSLog(@"%@",obj);
            if(index == collectionView.tag - TAG_COLLECTION_BRAND){
                NSArray *goods = [obj copy];
                if(goods.count > indexPath.row){
                    BrandGoodsModel *model = [goods objectAtIndex:indexPath.row];
                    [cell fillDataWithModel:model];
                }
                return cell;
                
            }
            index++;
        }
        // == 有问题 ????? == //
        
        return cell;
    }
    else{
        //NSLog(@"arr collection cellForItemAtIndexPath");
        JMRootgoodsCell *cell = (JMRootgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
        //wulei 20160421 防止超过1屏后出现重复和错乱
        //for (UIView *view in cell.contentView.subviews) {
        //    [view removeFromSuperview];
        //}
        
        NSString *key = self.dickey[self.currentIndex];
        NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
        if(currentArr.count > indexPath.row){
            JMRootGoodsModel *model = [currentArr objectAtIndex:indexPath.row];
            [cell fillData:model];
        }
        return cell;
    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if((collectionView.tag >= TAG_COLLECTION_BRAND)
//       && (collectionView.tag <= TAG_COLLECTION_BRAND + 10)){
//        return CGSizeMake(10, 10);
//
//    }
//    else{
//        return CGSizeMake(SCREENWIDTH, 30);
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if((collectionView.tag >= TAG_COLLECTION_BRAND)
       && (collectionView.tag <= TAG_COLLECTION_BRAND_END)){
        //        NSLog(@"brand collection sizeForItemAtIndexPath");
        return CGSizeMake(110, 145);
    }
    else{
        return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH-15) * 0.5 * 8/6 + 60);
    }
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = self.dickey[self.currentIndex];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
    
    
    
    if((collectionView.tag >= TAG_COLLECTION_BRAND)
       && (collectionView.tag <= TAG_COLLECTION_BRAND_END)){
//        MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil ];
//        
//        int index = 0;
//        for(NSMutableArray *obj in self.brandDataArr)
//        {
//            //NSLog(@"%@",obj);
//            if(index == collectionView.tag - TAG_COLLECTION_BRAND){
//                NSArray *goods = [obj copy];
//                collectionVC.dataArray = [NSMutableArray arrayWithArray:goods];
//                
//            }
//            index++;
//        }
//        
//        
//        NSLog(@"Brand COUNT is %lu", (unsigned long)collectionVC.dataArray.count);
//        NSLog(@"Brand pic is %@", ((BrandGoodsModel *)[collectionVC.dataArray objectAtIndex:0]).product_img);
//        [self.navigationController pushViewController:collectionVC animated:YES];
        
    }
    else{
        if((currentArr == nil) || (currentArr.count == 0) || (indexPath.row >= currentArr.count))
            return;
        
        JMRootGoodsModel *model = [currentArr objectAtIndex:indexPath.row];
//        _diction = [NSMutableDictionary dictionary];
//        _diction = model.mj_keyValues;
//        [_diction setValue:model.web_url forKey:@"web_url"];
//        [_diction setValue:@"ProductDetail" forKey:@"type_title"];
//        
//        WebViewController *webView = [[WebViewController alloc] init];
//        webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:_diction];
//        webView.isShowNavBar =false;
//        webView.isShowRightShareBtn=false;
//        [self.navigationController pushViewController:webView animated:YES];
        
        JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
        
        detailVC.goodsID = model.goodsID;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//
//    self.categoryViewHeight.constant = 1000;
//}

//- (void)createBanner {
//    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
//    bannerView.backgroundColor = [UIColor redColor];
//    [self.aboveView addSubview:bannerView];
//
//    UIView *childAndWomanView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREENWIDTH, 120)];
//    childAndWomanView.backgroundColor = [UIColor greenColor];
//    [self.aboveView addSubview:childAndWomanView];
//    //创建童装和女装
//
//    //创建分类
//
//}

- (void)startDeal:(NSDictionary *)dic {
    self.imageUrl = [dic objectForKey:@"picture"];
    
    if (self.imageUrl.length == 0 || [self.imageUrl class] == [NSNull class]) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
    }
    self.startV.imageV.alpha = 1;
    
    [self.startV.imageV sd_setImageWithURL:[NSURL URLWithString:[self.imageUrl imagePostersCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.3 animations:^{
            self.startV.imageV.alpha = 1;
        }];
    }];
}

- (void)ActivityTimeUpdate {
    self.timeCount++;
    if (self.timeCount > 2) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
        
    }
}


- (void)jumpHome:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *jumpType = info[@"param"];
    
    NSLog(@"-rootview jumphome--跳转－－－－%@", jumpType);
    if ([jumpType isEqualToString:@"today"]) {
        //[self buttonClicked:101];
    }else if ([jumpType isEqualToString:@"previous"]) {
        
    }else if ([jumpType isEqualToString:@"child"]) {
        
    }else if ([jumpType isEqualToString:@"woman"]) {
        //[self buttonClicked:103];
    }
    
}

- (NSArray *)randomArray{
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:62];
    
    for (int i = 0; i<10; i++) {
        // NSLog(@"%d", i);
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [mutable addObject:string];
    }
    for (char i = 'a'; i<='z'; i++) {
        // NSLog(@"%c", i);
        NSString *string = [NSString stringWithFormat:@"%c", i];
        
        [mutable addObject:string];
    }
    NSArray *array = [NSArray arrayWithArray:mutable];
    
    // NSLog(@"array = %@", array);
    return array;
}

#pragma mark 自动登录

- (void)weixinzidongdenglu{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    //  NSLog(@"用户信息 = %@", dic);
    //微信登录 hash算法。。。。
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
    //    NSLog(@"count = %lu", count);
    int index = 0;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    //   NSLog(@"timeSp:%@",timeSp);
    
    __unused long time = [timeSp integerValue];
    //  NSLog(@"time = %ld", (long)time);
    NSMutableString * randomstring = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = 0; i<8; i++) {
        index = arc4random()%count;
        // NSLog(@"index = %d", index);
        NSString *string = [randomArray objectAtIndex:index];
        [randomstring appendString:string];
    }
    //  NSLog(@"%@%@",timeSp ,randomstring);
    //    NSString *secret = @"3c7b4e3eb5ae4c";
    NSString *noncestr = [NSString stringWithFormat:@"%@%@", timeSp, randomstring];
    //获得参数，升序排列
    NSString* sign_params = [NSString stringWithFormat:@"noncestr=%@&secret=%@&timestamp=%@",noncestr, SECRET,timeSp];
    
    NSString *sign = [sign_params sha1];
    
    //http://m.xiaolu.so/rest/v1/register/wxapp_login
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/weixinapplogin?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    //
    NSDictionary *newDic = @{@"headimgurl":[dic objectForKey:@"headimgurl"],
                             @"nickname":[dic objectForKey:@"nickname"],
                             @"openid":[dic objectForKey:@"openid"],
                             @"unionid":[dic objectForKey:@"unionid"],
                             @"devtype":LOGINDEVTYPE};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
        NSDictionary *result = responseObject;
        if (result.count == 0) return;
        if ([[result objectForKey:@"rcode"]integerValue] != 0) {
            return;
        }
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"login"];
        [userdefaults synchronize];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)shoujizidongdenglu{
    //  NSLog(@"手机自动登录");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:kUserName];
    NSString *password = [defaults objectForKey:kPassWord];
    
    //  NSLog(@"userName : %@, password : %@", username, password);
    
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password
                                 };
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:kLOGIN_URL WithParaments:parameters WithSuccess:^(id responseObject) {
          //     NSLog(@"手机自动登录成功。。。。");
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)autologin{
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *loginMethon = [defaults objectForKey:kLoginMethod];
    //    if ([loginMethon isEqualToString:kWeiXinLogin]) {
    //      //  NSLog(@"微信登录");
    //
    //        [self weixinzidongdenglu];
    //       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
    //      //  NSLog(@"userinfo = %@", userinfo);
    //        if ([self isXiaolumama]) {
    //            [self createRightItem];
    //        } else{
    //            self.navigationItem.rightBarButtonItem = nil;
    //        }
    //    } else if ([loginMethon isEqualToString:kPhoneLogin]){
    //
    //       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
    //      //  NSLog(@"userinfo = %@", userinfo);
    //        if ([self isXiaolumama]) {
    //            [self createRightItem];
    //        } else{
    //            self.navigationItem.rightBarButtonItem = nil;
    //        }
    //
    //    }
    
    NSLog(@"auto login");
    if ([self isXiaolumama]) {
        NSLog(@"isXiaolumama");
        [self createRightItem];
    } else{
        NSLog(@"not xiaolumama");
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


//- (void)islogin{
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/islogin", Root_URL];
//    NSURL *url = [NSURL URLWithString:string];
//    NSError *error = nil;
//    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
//    if (error == nil) {
//        __unused NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        if (error == nil) {
//          //  NSLog(@"dic = %@", dic);
//        } else{
//            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
//            [self.navigationController pushViewController:loginVC animated:YES];
//        }
//
//    } else{
//        JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
//
//}

#pragma mark  设置导航栏样式
- (void)createInfo{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
    imageView.frame = CGRectMake(0, 8, 83, 20);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [view addSubview:imageView];
    imageView.center = view.center;
    CGRect imageframe = imageView.frame;
    imageframe.origin.y += 2;
    imageView.frame = imageframe;
    self.navigationItem.titleView = view;
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles.png"]];
    leftImageview.frame = CGRectMake(0, 11, 26, 26);
    [leftButton addSubview:leftImageview];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    [self.view addSubview:[[UIView alloc] init]];
}

#pragma mark 小鹿妈妈入口
- (void)rightClicked:(UIButton *)button{
    //    NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaults boolForKey:kIsLogin];
    if (islogin == YES) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
        NSError *error = nil;
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:string] encoding:NSUTF8StringEncoding error:&error];
        //  NSLog(@"error = %@", error);
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        // NSLog(@"json = %@", json);
        if ([[json objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]) {
            JMMaMaPersonCenterController *mamaCenterVC = [[JMMaMaPersonCenterController alloc] init];
//            MaMaPersonCenterViewController *mamaCenterVC= [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
            [self.navigationController pushViewController:mamaCenterVC animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不是小鹿妈妈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } else {
        JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}




#pragma mark 创建购物车按钮。。
- (void)createCartsView{
    
    UIView *collectionView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT - 64, 44, 44)];
    [_view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.alpha = 0.8;
    collectionView.layer.cornerRadius = 22;

    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionView addSubview:collectionButton];
    [collectionButton setImage:[UIImage imageNamed:@"MyCollection_Nomal"] forState:UIControlStateNormal];
    [collectionButton setImage:[UIImage imageNamed:@"MyCollection_Selected"] forState:UIControlStateHighlighted];
    collectionButton.frame = CGRectMake(0, 0, 44, 44);
    collectionButton.layer.cornerRadius = 22;
    [collectionButton addTarget:self action:@selector(gotoCollection:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, SCREENHEIGHT - 64, 108, 44)];
    view.tag = 123;
    [_view addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor settingBackgroundColor].CGColor;
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    iconView.image = [UIImage imageNamed:@"gouwucheicon2.png"];
    iconView.userInteractionEnabled = NO;
    [button addSubview:iconView];
    //    button.backgroundColor = [UIColor redColor];
    
    dotView = [[UIView alloc] initWithFrame:CGRectMake(26, 4, 16, 16)];
    dotView.layer.cornerRadius = 8;
    dotView.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    [button addSubview:dotView];
    dotView.hidden = YES;
    
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 60, 24)];
    countLabel.text = @"";
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentLeft;
    [button addSubview:countLabel];
    label = [[UILabel alloc] initWithFrame:dotView.bounds];
    label.font = [UIFont systemFontOfSize:10];
    [dotView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    countLabel.userInteractionEnabled = NO;
    dotView.userInteractionEnabled = NO;
    label.userInteractionEnabled = NO;
    countLabel.hidden = YES;
    
    //[self.view addSubview:view];
}


- (void)setLabelNumber{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == NO) {
        NSLog(@"Cart,not login,return");
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        
        label.text = @"0";
        
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            label.text = @"0";
            dotView.hidden = YES;
            countLabel.hidden = YES;
            UIView *view = [_view viewWithTag:123];
            CGRect rect = view.frame;
            rect.size.width = 44;
            view.frame = rect;
            return ;
        }else {
            [self cartViewUpdate:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)cartViewUpdate:(NSDictionary *)dic {
    // NSLog(@"dic = %@", dic);
    last_created = [dic objectForKey:@"last_created"];
    goodsCount = [[dic objectForKey:@"result"]integerValue];
    if (goodsCount == 0) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        return;
    }
    label.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"result"] stringValue]];
    dotView.hidden = NO;
    countLabel.hidden = NO;
    UIView *view = [_view viewWithTag:123];
    CGRect rect = view.frame;
    rect.size.width = 108;
    view.frame = rect;
    
    [self createTimeLabel];
}


- (void)createTimeLabel{
    countLabel.hidden = NO;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)thetimer
{
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[last_created doubleValue]];
    // NSLog(@"%@", lastDate);
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:lastDate options:0];
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    //   NSLog(@"string = %@", string);
    if ([d minute] < 0 || [d second] < 0) {
        string = @"";
        
        UIView *view = [_view viewWithTag:123];
        dotView.hidden = YES;
        
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        if ([theTimer isValid]) {
            [theTimer invalidate];
            
            
            
        }
    }
    countLabel.text = string;
}


#pragma mark 点击按钮进入购物车界面
- (void)gotoCarts:(id)sender{
    [MobClick event:@"cart_click"];
    
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (login == NO) {
        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
//    JMShoppingCartController *cartVC = [[JMShoppingCartController alloc] init];
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
}
#pragma mark 点击按钮进入我的收藏界面
- (void)gotoCollection:(UIButton *)sender {
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (login == NO) {
        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    JMStoreupController *storeVC = [[JMStoreupController alloc] init];
    storeVC.index = 100;
    [self.navigationController pushViewController:storeVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIscrollViewDelegate  滚动视图代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    //NSLog(@"scrollViewWillBeginDragging");
    CGPoint offset = scrollView.contentOffset;
    //    CGRect bounds = scrollView.bounds;
    //    CGSize size = scrollView.contentSize;
    //    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y;
    //    CGFloat maximunOffset = size.height;
    
    if (currentOffset > SCREENHEIGHT) {
        self.topButton.hidden = NO;
    }else {
        self.topButton.hidden = YES;
    }

}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{
    
    return YES;
    //返回NO   关闭此功能
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    //if (scrollView.tag == kInnerScrollViewTag) {
    //    [scrollView resignFirstResponder];
    ///}
    NSLog(@"***scrollViewDidScrollToTop");
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat brandMaxY = CGRectGetMaxY(self.brandView.frame);
    CGPoint currentContentOffset = self.backScrollview.contentOffset;
    float allPostHeight = self.aboveView.frame.size.height+
    self.brandView.frame.size.height+self.activityView.frame.size.height;
    
    //    brandMaxY = brandMaxY - 1;
    //    NSLog(@"-scrollViewDidScroll-brandView %f", brandMaxY);
//    NSLog(@"=scrollViewDidScroll==tag=%ld x=%f y=%f ", scrollView.tag,scrollView.contentOffset.x,scrollView.contentOffset.y);
//    NSLog(@"backScrollview x = %f y=%f %d",currentContentOffset.x,currentContentOffset.y,self.homeCollectionView.scrollEnabled );
    if ((scrollView.tag == 110 && scrollView.contentOffset.y < brandMaxY) || scrollView.tag == 111)return;
    
//    NSLog(@"post height = %f %f %f",self.aboveView.frame.size.height,
//    self.brandView.frame.size.height,self.activityView.frame.size.height);
    
    //在最外层back scrollview上进行滑动
    if (scrollView.tag == TAG_BACK_SCROLLVIEW
        && scrollView.dragging){
        if (scrollView.contentOffset.y <= 0) {
            //下拉
            //NSLog(@"backScrollview 下拉");
        }if (scrollView.contentOffset.y > 0) {
            //上滑
            //NSLog(@"backScrollview 上滑");
            if(scrollView.contentOffset.y + 64 - allPostHeight > 5.0f){
                NSLog(@"backScrollview enter category");
                self.backScrollview.scrollEnabled = NO;
                [self.backScrollview setContentOffset:CGPointMake(currentContentOffset.x,allPostHeight-64)
                                             animated:YES];
                
                [self enableAllGoodsCollectionScroll];
            }
            else{
                self.backScrollview.scrollEnabled = YES;
                [self disableAllGoodsCollectionScroll];
            }
        }
    }
    
    //在中间层水平滑动
    if ((scrollView.tag == TAG_COLLECTION_SCROLLVIEW)
        && scrollView.dragging){
        int index = 1;
        if(scrollView.contentOffset.x <= (1e-6)){
            index = 0;
            self.labelIndicate.text = @"距本场结束";
        }else if(scrollView.contentOffset.x - WIDTH <= (1e-6)){
            index = 1;
            self.labelIndicate.text = @"距本场结束";
        }else{ //if(scrollView.contentOffset.x - 2 * WIDTH <= (1e-6)){
            index = 2;
            self.labelIndicate.text = @"距本场开始";
        }
        //NSLog(@"index %d %f %f",  index, scrollView.contentOffset.x, WIDTH );
        if(self.currentIndex != index){
            self.currentIndex = index;
            if(self.currentIndex == 0){
                [MobClick event:@"yestoday"];
            }else if(self.currentIndex == 1){
                [MobClick event:@"today"];
            }else if(self.currentIndex == 2){
                [MobClick event:@"tomorrow"];
            }
            
            NSMutableArray *currentArr = [self.categoryDic objectForKey:self.dickey[self.currentIndex]];
            if((currentArr != nil) && (currentArr.count == 0)){
                [self goodsRequest];
            }
        }
        else{
            self.currentIndex = index;
        }
        
        [self changeBtnImg];
    }
    
    //在最内层的collection上进行滑动
    if (((scrollView.tag == TAG_GOODS_YESTODAY_SCROLLVIEW)
         || (scrollView.tag == TAG_GOODS_TODAY_SCROLLVIEW)
         || (scrollView.tag == TAG_GOODS_TOMORROW_SCROLLVIEW))
        && scrollView.dragging){
        if( scrollView.contentOffset.y <= 0) {
            //            NSLog(@"today scroll down");
            self.backScrollview.scrollEnabled = YES;
            [self.backScrollview setContentOffset:CGPointMake(currentContentOffset.x,currentContentOffset.y + scrollView.contentOffset.y)
                                         animated:YES];
            
            [self disableAllGoodsCollectionScroll];
            [UIView animateWithDuration:1 animations:^{
                self.lefttimeViewHeight.constant = 45;
                
            }];
            
            
        }
        else if( scrollView.contentOffset.y > 0) {
            //            NSLog(@"today scroll up");
            [UIView animateWithDuration:1 animations:^{
                self.lefttimeViewHeight.constant = 45;
                
            }];
        }
    }
}

-(void)enableAllGoodsCollectionScroll{
    for(int i=0; i<3; i++){
        UICollectionView* cv=[self.collectionArr objectAtIndex:i];
        cv.scrollEnabled = YES;
    }
}

-(void)disableAllGoodsCollectionScroll{
    for(int i=0; i<3; i++){
        UICollectionView* cv=[self.collectionArr objectAtIndex:i];
        cv.scrollEnabled = NO;
    }
}

#pragma mark 左滑进入个人中心界面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((scrollView.contentInset.left < 0) && (_currentIndex == 0) && velocity.x < 0) {
        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil withObject:self];
    }
}



#pragma mark --mmNavigationDelegate--

- (void)hiddenNavigation{
    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, -44, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 112;
    cartView.frame = rect;
    
    
}

- (void)showNavigation{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
    //    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156, 44, 44);
}

#pragma mark RootVCPushOtherVCDelegate

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)yestdayBtnClick:(id)sender {
    [self categoryBtnClick:sender];
}

- (IBAction)tomottowBtnClick:(id)sender {
    [self categoryBtnClick:sender];
}

- (IBAction)todayBtnClick:(id)sender {
    [self categoryBtnClick:sender];
}

#pragma mark 版本 自动升级
- (void)autoUpdateVersion{
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:UPDATE_URLSTRING WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self fetchedUpdateData:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)fetchedUpdateData:(NSDictionary *)appInfoDic{
    //NSLog(@"version info %@",appInfoDic);
    NSArray *reluts = [appInfoDic objectForKey:@"results"];
    if ([reluts count] == 0) return;
    NSDictionary *infoDic = reluts[0];
    
    
    self.latestVersion = [infoDic objectForKey:@"version"];
    self.trackViewUrl1 = [infoDic objectForKey:@"trackViewUrl"];//地址trackViewUrl
    self.trackName = [infoDic objectForKey:@"trackName"];//trackName
    _releaseNotes = [infoDic objectForKey:@"releaseNotes"];

    _releaseNotes = [NSString stringWithFormat:@"新版本升级信息：\n%@",_releaseNotes];

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    double doubleCurrentVersion = [app_Version doubleValue];
    
    double doubleUpdateVersion = [self.latestVersion doubleValue];
    
    NSLog(@"Get app version store=%@ %f appversion=%@ %f ",self.latestVersion, doubleUpdateVersion,app_Version, doubleCurrentVersion);
    
    if ([self.latestVersion compare:app_Version options:NSNumericSearch] == NSOrderedDescending) {
        self.isPopUpdataView = YES;
    }else
    {
        self.isPopUpdataView = NO;
    }
}
- (void)updataAppPopView {
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideUpdataView)]];
    JMUpdataAppPopView *updataPopView = [JMUpdataAppPopView defaultUpdataPopView];
    self.updataPopView = updataPopView;
    self.updataPopView.releaseNotes = _releaseNotes;
    self.updataPopView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.updataPopView];
    [JMPopViewAnimationSpring showView:self.updataPopView overlayView:self.maskView];
}
- (void)composeUpdataAppButton:(JMUpdataAppPopView *)updataButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideUpdataView];
    }else if (index == 101) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl1]];
        [self hideUpdataView];
    }else {
    }
}
- (void)hideUpdataView {
    [JMPopViewAnimationSpring dismissView:self.updataPopView overlayView:self.maskView];
}
#pragma mark 网络请求得到地址信息
- (void)loadAddressInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/districts/latest_version",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self addressData:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)addressData:(NSDictionary *)addressDic {
    _hash = addressDic[@"hash"];
    _downloadURLString = addressDic[@"download_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [defaults stringForKey:@"hash"];
    if (oldVersion == nil) {
        [self startDownload:_downloadURLString];
    }else {
        if ([oldVersion isEqualToString:_hash]) {
        }else {
            [self startDownload:_downloadURLString];
        }
    }
    [defaults setObject:_hash forKey:@"hash"];
    [defaults synchronize];
}
#pragma mark -- 开始下载地址文件
- (void)startDownload:(id)downloadURLString {
    
    if (self.downloadTask) {
        return ;
    }
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    
}
- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"so.xiaolu.m.xiaolumeimei"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}
//这个方法用来跟踪下载数据并且根据进度刷新ProgressView
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}
//下载任务完成,这个方法在下载完成时触发，它包含了已经完成下载任务得 Session Task,Download Task和一个指向临时下载文件得文件路径
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *desPath = [path stringByAppendingPathComponent:@"addressInfo.json"];
    NSString *addressPath = [JMHelper getFullPathWithFile];
    NSURL *pathUrl = [NSURL fileURLWithPath:addressPath];
    NSError *errorCopy;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtURL:pathUrl error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:location toURL:pathUrl error:nil];
    
//    
//    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *documentsDirectory = [URLs objectAtIndex:0];
//    NSURL *originalURL = [[downloadTask originalRequest] URL];
//    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
//    NSError *errorCopy;
//
//    [fileManager removeItemAtURL:destinationURL error:NULL];
//    BOOL success = [fileManager copyItemAtURL:location toURL:destinationURL error:&errorCopy];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //播放音乐
            self.player = [AVPlayer playerWithURL:pathUrl];
            [self.player play];
        });
    } else {
        NSLog(@"复制文件发生错误: %@", [errorCopy localizedDescription]);
    }
}
#pragma mark - 获取商品分类列表
//      /rest/v2/categorys/latest_version
- (void)loadItemizeData {
    NSString *urlString = [NSString stringWithFormat:@"http://staging.xiaolumeimei.com/rest/v2/categorys/latest_version"];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self fetchItemize:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchItemize:(NSDictionary *)dic {
//    NSString *isUpData = dic[@"sha1"];
//    [[NSUserDefaults standardUserDefaults] setObject:isUpData forKey:@"itemHash"];
//    NSString *downloadUrl = dic[@"download_url"];
    
    NSString *isUpData = dic[@"sha1"];
    NSString *urlString = dic[@"download_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [defaults stringForKey:@"itemHash"];
    if (oldVersion == nil) {
        [self downLoadUrl:urlString];
    }else {
        if ([oldVersion isEqualToString:isUpData]) {
        }else {
            [self downLoadUrl:urlString];
        }
    }
    [defaults setObject:isUpData forKey:@"itemHash"];
    [defaults synchronize];
    
}
- (void)downLoadUrl:(NSString *)urlStr {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"默认下载地址%@",targetPath);
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
        return [NSURL fileURLWithPath:jsonPath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@---%@", response, filePath);
    }];
    // 5.启动下载任务
    [task resume];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        NSLog(@"任务: %@ 成功完成", task);
    } else {
        NSLog(@"任务: %@ 发生错误: %@", task, [error localizedDescription]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    self.downloadTask = nil;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    NSLog(@"所有任务已完成!");
}

#pragma mark 返回顶部  image == >backTop
- (void)createTopButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    [self disableAllGoodsCollectionScroll];
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
    self.backScrollview.scrollEnabled = YES;
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}

@end








































//
//  MMRootViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMRootViewController.h"
#import "RESideMenu.h"
#import "TodayViewController.h"
#import "PreviousViewController.h"
#import "ChildViewController.h"
#import "MMClass.h"
#import "LogInViewController.h"
#import "UIImage+ColorImage.h"
#import "CartViewController.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "MMCartsView.h"
#import "MMNavigationDelegate.h"
#import "LogInViewController.h"
#import "WXApi.h"
#import "MaMaViewController.h"
#import "YouHuiQuanViewController.h"
#import "XiangQingViewController.h"
#import "MaMaPersonCenterViewController.h"
#import "MMLoginStatus.h"
#import "AFNetworking.h"
#import "NSString+Encrypto.h"
#import "PublishNewPdtViewController.h"
#import "ActivityView.h"
#import "NSString+URL.h"
#import "TuihuoViewController.h"
#import "MMAdvertiseView.h"
#import "SVProgressHUD.h"
#import "MMAdvertiseView.h"
#import "HuodongViewController.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "PromoteModel.h"
#import "PeopleCollectionCell.h"
#import "MJRefresh.h"
#import "HomeViewController.h"

#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"
#define ABOVEHIGHT 300
#define ACTIVITYHEIGHT 120

#define YESTDAY @"yestday"
#define TODAY @"today"
#define TOMORROW @"tomorrow"


#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

#define CELLWIDTH ([UIScreen mainScreen].bounds.size.width * 0.5)

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

@interface MMRootViewController ()<MMNavigationDelegate, WXApiDelegate>{
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
    
    
    BOOL login_required;
    UIView *backView;
    NSDictionary *huodongJson;
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

//商品
@property (nonatomic, strong)NSMutableArray *collectionArr;
@property (nonatomic, strong)NSMutableArray *collectionDataArr;
@property (nonatomic, strong)NSMutableDictionary *categoryDic;
@property (nonatomic, strong)NSMutableArray *urlArr;
@property (nonatomic, strong)NSArray *dickey;
//@property (nonatomic, strong)NSMutableArray *btnArr;

@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)NSMutableDictionary *nextdic;
@end


static NSString *ksimpleCell = @"simpleCell";
@implementation MMRootViewController

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
//- (UIView *)goodsView {
//    if (!_goodsView) {
//        self.goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, ABOVEHIGHT, SCREENWIDTH, SCREENHEIGHT - ABOVEHIGHT)];
//    }
//    return _goodsView;
//}
//

- (NSMutableArray *)activityDataArr {
    if (!_activityDataArr) {
        self.activityDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _activityDataArr;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
//    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156 , 44, 44);
    [self setLabelNumber];
  
}

- (void)updataAfterLogin:(NSNotification *)notification{
  // 微信登录
    if ([self loginUpdateIsXiaoluMaMa]) {
        [self createRightItem];
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)phoneNumberLogin:(NSNotification *)notification{
  //  NSLog(@"手机登录");
    if ([self loginUpdateIsXiaoluMaMa]) {
        [self createRightItem];
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)isXiaolumama{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    BOOL isXLMM = [users boolForKey:@"isXLMM"];
    return isXLMM;
}

- (BOOL)loginUpdateIsXiaoluMaMa {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        return NO;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
}

- (void)createRightItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
    rightImageView.frame = CGRectMake(18, 11, 26, 26);
    [rightBtn addSubview:rightImageView];
    rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark 解析targeturl 跳转到不同的界面
- (void)presentView:(NSNotification *)notification{
    //跳转到新的页面
    NSString *target_url = [notification.userInfo objectForKey:@"target_url"];
    [self pushAndBannerJump:target_url];
}

- (void)pushAndBannerJump:(NSString *)target_url {
    if (target_url == nil)return;
    
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_today"]) {
        NSLog(@"跳到今日上新");
        //[self buttonClicked:100];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_previous"]){
        NSLog(@"跳到昨日推荐");
        //[self buttonClicked:101];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/childlist"]){
        NSLog(@"跳到潮童专区");
        //[self buttonClicked:102];
        
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/ladylist"]){
        NSLog(@"跳到时尚女装");
        //[self buttonClicked:103];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/usercoupons/method"]){
        NSLog(@"跳转到用户未过期优惠券列表");
        
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        [self.navigationController pushViewController:youhuiVC animated:YES];
        
    }  else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_home"]){
        //  跳转到小鹿妈妈界面。。。
        MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:ma animated:YES];
        
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_0day"]){
        
        NSLog(@"跳转到小鹿妈妈每日上新");
        
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [self.navigationController pushViewController:publish animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/refunds"]) {
        //跳转到退款退货列表
        TuihuoViewController *tuihuoVC = [[TuihuoViewController alloc] initWithNibName:@"TuihuoViewController" bundle:nil];
        [self.navigationController pushViewController:tuihuoVC animated:YES];
        
    }else {
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        
        NSString *parameter = [components lastObject];
        NSArray *params = [parameter componentsSeparatedByString:@"="];
        NSString *firstparam = [params firstObject];
        if ([firstparam isEqualToString:@"model_id"]) {
            NSLog(@"跳到集合页面");
            NSLog(@"model_id = %@", [params lastObject]);
            MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[params lastObject] isChild:NO];
            
            [self.navigationController pushViewController:collectionVC animated:YES];
            
            
            
        } else if ([firstparam isEqualToString:@"product_id"]){
            NSLog(@"跳到商品详情");
            NSLog(@"product_id = %@", [params lastObject]);
            
            MMDetailsViewController *details = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:[params lastObject] isChild:NO];
            [self.navigationController pushViewController:details animated:YES];
            
            
        } else if ([firstparam isEqualToString:@"trade_id"]){
            NSLog(@"跳到订单详情");
            NSLog(@"trade_id = %@", [params lastObject]);
            
            
            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
            //http://m.xiaolu.so/rest/v1/trades/86412/details
            
            // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
            xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, [params lastObject]];
            NSLog(@"url = %@", xiangqingVC.urlString);
            [self.navigationController pushViewController:xiangqingVC animated:YES];
        } else {
            //  跳转到H5 界面 。。。。。
        }
    }

}

- (void)showNotification:(NSNotification *)notification{
    NSLog(@"弹出提示框");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.backScrollview.delegate = self;
    self.categoryViewHeight.constant = SCREENHEIGHT + 64;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _isFirst = NO;
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
     frame = self.view.frame;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    frame = self.view.frame;
}

#pragma mark 注册观察者
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //商品请求链接
    [self createRequestURL];
    self.dickey = @[YESTDAY, TODAY, TOMORROW];
    
    self.timeCount = 0;
    
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
    
    _pageCurrentIndex = 0;
    
    self.currentIndex = 1;
    
    [self createInfo];
    
//    [self creatPageData];
    
    //[self islogin];
    NSLog(@"backScrollview %f", self.backScrollview.contentOffset.x);
    self.backScrollview.delegate = self;
    self.backScrollview.tag = TAG_BACK_SCROLLVIEW;
    
    self.posterImages = [[NSMutableArray alloc] init];
    self.posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self createCollectionView];
    //设置商品scrollview的偏转
    self.collectionViewScrollview.contentOffset = CGPointMake(SCREENWIDTH, 0);
    
    [self initCategoryLvl1Img];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self autologin];
    } else {
        NSLog(@"no login");
    }
    

//    
//    self.sttime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ActivityTimeUpdate) userInfo:nil repeats:YES];
    
    //创建新的页面
//    self.backScrollview.contentSize = CGSizeMake(0, 1000);
//    [self.view addSubview:self.backScrollview];
//    
////    [self createBanner];
//    
//    [self.backScrollview addSubview:self.aboveView];
//    [self.backScrollview addSubview:self.goodsView];
//    self.goodsView.backgroundColor = [UIColor redColor];
//    self.aboveView.backgroundColor = [UIColor yellowColor];
    
}

- (void)createRequestURL {
    NSArray *urlBefroe = @[@"/rest/v1/products/promote_previous_paging?page=1&page_size=10",
        @"/rest/v1/products/promote_today_paging?page=1&page_size=10",
        @"/rest/v1/products/promote_tomorrow_paging?page=1&page_size=10"];
    for (int i = 0; i < 3; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [self.urlArr addObject:url];
    }
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
        
        
        UICollectionView *homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT-70) collectionViewLayout:flowLayout];
        
        homeCollectionView.backgroundColor = [UIColor whiteColor];
        homeCollectionView.tag = TAG_GOODS_YESTODAY_SCROLLVIEW + i;
        homeCollectionView.scrollEnabled = NO;
        
        //添加上拉加载
        homeCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            NSString *nextStr = [self.nextdic objectForKey:self.dickey[self.currentIndex]];
            NSLog(@"MJFresh nextstr %@",nextStr);
            if([nextStr class] == [NSNull class]) {
                [homeCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self loadMore];
        }];

        
        [self.collectionViewScrollview addSubview:homeCollectionView];
        
        homeCollectionView.delegate = self;
        homeCollectionView.dataSource = self;
        
//        [homeCollectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"picCollectionCell"];
        [homeCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
        
        [self.collectionArr addObject:homeCollectionView];
    }
    
    
    //网络请求海报
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *requestURL = [NSString stringWithFormat:@"%@/rest/v1/posters/today", Root_URL];
    [manage GET:requestURL parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        [self fetchedPosterData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //未登录处理
        //        [self showDefaultView];
    }];
    
    //活动
    NSString *activityUrl = [NSString stringWithFormat:@"%@/rest/v1/activitys", Root_URL];
    [manage GET:activityUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.activityArr = responseObject;
        if (self.activityArr.count == 0) return;
        [self activityDeal:self.activityArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //今日商品
    [self goodsRequest];
}

- (void)fetchedPosterData:(NSDictionary *)jsonDic{
    if (jsonDic.count == 0) return;
    
    NSArray *childArray = [jsonDic objectForKey:@"chd_posters"];
    self.posterImages = [[NSMutableArray alloc] init];
    
    if (childArray.count == 0)return;
    for (NSDictionary *childDic in childArray) {
        PosterModel *childModel = [PosterModel new];
        
        childModel.target_link = [childDic objectForKey:@"app_link"];
        childModel.imageURL = [childDic objectForKey:@"pic_link"];
        childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
        childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
        
        UIImage *image0 = [UIImage imagewithURLString:[[childModel.imageURL URLEncodedString] imagePostersCompression]];
        
        NSLog(@"url = %@", [childModel.imageURL URLEncodedString]);
        NSLog(@"image = %@", image0);
        if (image0 == nil) {
            image0 = [UIImage imageNamed:@"placeHolderPosterImage.png"];
        }
        
        [self.posterImages addObject:image0];
        [self.posterDataArray addObject:childModel];
        
    }

    NSArray *ladyArray = [jsonDic objectForKey:@"wem_posters"];
    if (ladyArray.count == 0)return;
    for (NSDictionary *ladyDic in ladyArray) {
        
        PosterModel *ladyModel = [PosterModel new];
        ladyModel.target_link = [ladyDic objectForKey:@"app_link"];
        ladyModel.imageURL = [ladyDic objectForKey:@"pic_link"];
        ladyModel.firstName = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
        ladyModel.secondName = [[ladyDic objectForKey:@"subject"] objectAtIndex:1];
        
        UIImage *image1 = [UIImage imagewithURLString:[[ladyModel.imageURL URLEncodedString] imagePostersCompression]];
        NSLog(@"url = %@", [ladyModel.imageURL URLEncodedString]);
        NSLog(@"image = %@", image1);
        if (image1 == nil) {
            image1 = [UIImage imageNamed:@"placeHolderPosterImage.png"];
        }
        [self.posterImages addObject:image1];
        [self.posterDataArray addObject:ladyModel];
    }
    
    MMAdvertiseView *adView = [[MMAdvertiseView alloc] initWithFrame:self.bannerView.bounds andImages:self.posterImages];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
    [adView.scrollView addGestureRecognizer:tap];
//    NSLog(@"===============%@", NSStringFromCGRect(self.bannerView.frame));
//     NSLog(@"===============----%@", NSStringFromCGRect(adView.frame));
//    UIView *view = [[UIView alloc] initWithFrame:self.bannerView.bounds];
//    view.backgroundColor = [UIColor redColor];
//    [self.bannerView addSubview:view];
    [self.bannerView addSubview:adView];
    
    //品牌
    
}

- (void)initCategoryLvl1Img{
    [self.womenImgView setUserInteractionEnabled:YES];
    [self.childImgView setUserInteractionEnabled:YES];
    [self.womenImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategoryLvl1:)]];
    [self.childImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategoryLvl1:)]];
}

#pragma mark --商品列表

- (void)goodsRequest{
    NSString *currentUrl = self.urlArr[self.currentIndex];
    NSLog(@"goodsRequest currentUrl=%@ index=%ld",currentUrl ,self.currentIndex);
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:currentUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        [self goodsResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)goodsResult:(NSDictionary *)dic {
    if ([[dic objectForKey:@"next"] class] == [NSNull class]) {
        [self.nextdic setObject:@"" forKey:self.dickey[self.currentIndex]];
        NSLog(@"goodsResult NEXT=null");
    }else {
        [self.nextdic setObject:[dic objectForKey:@"next"] forKey:self.dickey[self.currentIndex]];
        NSLog(@"goodsResult NEXT=%@ index=%ld",[dic objectForKey:@"next"], self.currentIndex);
    }
    NSArray *results = [dic objectForKey:@"results"];
    if (results.count == 0) {
        return;
    }
    NSLog(@"result count=%ld", results.count );
    
    //判断在数据源字典中是否有对应的数组
    NSMutableArray *currentArr = [self.categoryDic objectForKey:self.dickey[self.currentIndex]];
    for (NSDictionary *goods in results) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:goods];
        [currentArr addObject:model];
    }
    
    UICollectionView *collection = self.collectionArr[self.currentIndex];
    [collection reloadData];
}

- (void)loadMore {
    //NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
    NSString *url = [self.nextdic objectForKey:self.dickey[self.currentIndex]];
    
    NSLog(@"loadmore index=%@ url=%@",self.dickey[self.currentIndex], url);
    if(nil == url)
        return;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UICollectionView *collection = self.collectionArr[self.currentIndex];
        [collection.mj_footer endRefreshing];
        if (!responseObject)return ;
        [self goodsResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


#pragma mark --活动处理
- (void)activityDeal:(NSArray *)activityArr {
    for (NSDictionary *actityDic in activityArr) {
        ActivityModel *activityM = [[ActivityModel alloc] init];
        [activityM setValuesForKeysWithDictionary:actityDic];
        [self.activityDataArr addObject:activityM];
    }
    
    //创建活动展示图
    for (int i = 0; i < self.activityDataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * ACTIVITYHEIGHT, SCREENWIDTH, ACTIVITYHEIGHT)];
        imageView.tag = 120 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTapAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [self.activityView addSubview:imageView];
    
        ActivityModel *acM = self.activityDataArr[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:acM.act_img] placeholderImage:nil];
    }
    
    self.activityHeight.constant = ACTIVITYHEIGHT * self.activityDataArr.count;
    
    huodongJson = [activityArr firstObject];
    if ([huodongJson isKindOfClass:[NSDictionary class]]) {
        login_required = [[huodongJson objectForKey:@"login_required"] boolValue];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *activityID = [huodongJson objectForKey:@"id"];
        NSNumber *userNumber = [defaults objectForKey:@"activityid"];
        
        if ([userNumber integerValue] == [activityID integerValue]) return;
        //活动弹框
        if (!([[huodongJson objectForKey:@"mask_link"] class] == [NSNull class])) {
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
    NSLog(@"点击了。。。。。");
    //判断点击的活动
    UIImageView *imageV = (UIImageView *)tap.view;
    NSInteger imageTag = imageV.tag - 120;
    
    [self activityClick:self.activityArr[imageTag]];
}


- (void)createActivityView:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    [backView removeFromSuperview];
    
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

- (void)activityClick:(NSDictionary *)dic {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
        huodongVC.diction = dic;
        [self.navigationController pushViewController:huodongVC animated:YES];
    } else{
        if (login_required) {
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else{
            HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
            huodongVC.diction = dic;
            [self.navigationController pushViewController:huodongVC animated:YES];
        }
    }
}

#pragma mark --点击
//poster click
- (void)tapgesture:(UITapGestureRecognizer *)gesture{
    MMAdvertiseView *view =(MMAdvertiseView *)[gesture.view superview];
    PosterModel *model = self.posterDataArray[view.currentImageIndex];
    NSString *target_url = model.target_link;
    [self pushAndBannerJump:target_url];
}

//women child click
-(void)clickCategoryLvl1:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"clickCategoryLvl1 click");
    //NSLog(@"%hhd",[gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]);
    
    UIView *viewClicked=[gestureRecognizer view];
    if (viewClicked==self.womenImgView) {
        NSLog(@"womenImgView");
        HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }else if(viewClicked==self.childImgView)
    {
        NSLog(@"childImgView");
    }
    
}

//今昨明按钮点击
- (void)categoryBtnClick:(UIButton *)btn {
    NSInteger tag = btn.tag - (TAG_BTN_YESTODAY);
    self.currentIndex = tag;
    
    //循环遍历改变背景
    [self changeBtnImg];
    
    
    //改变scrollview的偏移
    NSLog(@"---------%ld", (long)self.currentIndex);
    self.collectionViewScrollview.contentOffset = CGPointMake(tag *SCREENWIDTH, 0);
    
    //如果没有数据重新请求，有的话不作操作
    NSString *key = self.dickey[tag];
    NSLog(@"---------%ld", (long)self.currentIndex);
    NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
    
    if (!(currentArr.count > 0)) {
        [self goodsRequest];
    }
}

-(void)changeBtnImg{
    UIImageView *uiv;
    
    if(self.currentIndex == 0){
        uiv = [self.categoryView viewWithTag:TAG_IMG_YESTODAY];
        [uiv setImage:[UIImage imageNamed:@"yestday1.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TODAY];
        [uiv setImage:[UIImage imageNamed:@"today.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TOMORROW];
        [uiv setImage:[UIImage imageNamed:@"tomorrow.png"]];
    }
    else if(self.currentIndex == 1){
        uiv = [self.categoryView viewWithTag:TAG_IMG_YESTODAY];
        [uiv setImage:[UIImage imageNamed:@"yestday.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TODAY];
        [uiv setImage:[UIImage imageNamed:@"today1.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TOMORROW];
        [uiv setImage:[UIImage imageNamed:@"tomorrow.png"]];
    } if(self.currentIndex == 2){
        uiv = [self.categoryView viewWithTag:TAG_IMG_YESTODAY];
        [uiv setImage:[UIImage imageNamed:@"yestday.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TODAY];
        [uiv setImage:[UIImage imageNamed:@"today.png"]];
        
        uiv = [self.categoryView viewWithTag:TAG_IMG_TOMORROW];
        [uiv setImage:[UIImage imageNamed:@"tomorrow1.png"]];
    }
}

#pragma mark --collection的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *key = self.dickey[self.currentIndex];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
    return currentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    //wulei 20160421 防止超过1屏后出现重复和错乱
    //for (UIView *view in cell.contentView.subviews) {
    //    [view removeFromSuperview];
    //}
    
    NSString *key = self.dickey[self.currentIndex];
    NSMutableArray *currentArr = [self.categoryDic objectForKey:key];
    PromoteModel *model = [currentArr objectAtIndex:indexPath.row];
    [cell fillData:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH-15) * 0.5 * 8/6 + 60);
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
    if ([jumpType isEqualToString:@"previous"]) {
        //[self buttonClicked:101];
    }else if ([jumpType isEqualToString:@"child"]) {
        //[self buttonClicked:102];
    }else if ([jumpType isEqualToString:@"woman"]) {
        //[self buttonClicked:103];
    }
    NSLog(@"---跳转－－－－%@", jumpType);
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

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:urlString parameters:newDic success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *result = responseObject;
        if (result.count == 0) return;
        if ([[result objectForKey:@"rcode"]integerValue] != 0) {
            return;
        }
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"login"];
        [userdefaults synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)shoujizidongdenglu{
  //  NSLog(@"手机自动登录");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:kUserName];
    NSString *password = [defaults objectForKey:kPassWord];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
  //  NSLog(@"userName : %@, password : %@", username, password);
    
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password
                                 };
    
    [manager POST:kLOGIN_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
           //   NSLog(@"JSON: %@", responseObject);
         //     NSLog(@"手机自动登录成功。。。。");
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //     NSLog(@"Error: %@", error);
              
              
          }];

}

- (void)autologin{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginMethon = [defaults objectForKey:kLoginMethod];
    if ([loginMethon isEqualToString:kWeiXinLogin]) {
      //  NSLog(@"微信登录");
        
        [self weixinzidongdenglu];
       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
      //  NSLog(@"userinfo = %@", userinfo);
        if ([self isXiaolumama]) {
            [self createRightItem];
        } else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else if ([loginMethon isEqualToString:kPhoneLogin]){
      
       __unused NSDictionary *userinfo = [defaults objectForKey:kPhoneNumberUserInfo];
      //  NSLog(@"userinfo = %@", userinfo);
        if ([self isXiaolumama]) {
            [self createRightItem];
        } else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }
   
}


- (void)islogin{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/islogin", Root_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error == nil) {
        __unused NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil) {
          //  NSLog(@"dic = %@", dic);
        } else{
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    } else{
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

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
            MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
            [self.navigationController pushViewController:ma animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不是小鹿妈妈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } else {
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}




#pragma mark 创建购物车按钮。。
- (void)createCartsView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT - 156, 108, 44)];
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
    
    
    
}
#pragma mark 设置购物车数量


- (void)setLabelNumber{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == NO) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        
        label.text = @"0";
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num.json", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        LogInViewController *enterVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UIscrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
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
    NSLog(@"-scrollViewDidScroll-brandView %f", brandMaxY);
    NSLog(@"=scrollViewDidScroll==tag=%ld x=%f y=%f ", scrollView.tag,scrollView.contentOffset.x,scrollView.contentOffset.y);
    //NSLog(@"backScrollview x = %f y=%f %d",currentContentOffset.x,currentContentOffset.y,self.homeCollectionView.scrollEnabled );
    if ((scrollView.tag == 110 && scrollView.contentOffset.y < brandMaxY) || scrollView.tag == 111)return;
    
    //NSLog(@"post height = %f %f %f",self.aboveView.frame.size.height,
//self.brandView.frame.size.height,self.activityView.frame.size.height);
    
    //在最外层back scrollview上进行滑动
    if (scrollView.tag == TAG_BACK_SCROLLVIEW
        && scrollView.dragging){
        if (scrollView.contentOffset.y <= 0) {
            //下拉
            NSLog(@"backScrollview 下拉");
        }if (scrollView.contentOffset.y > 0) {
            //上滑
            NSLog(@"backScrollview 上滑");
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
        }else if(scrollView.contentOffset.x - WIDTH <= (1e-6)){
            index = 1;
        }else if(scrollView.contentOffset.x - 2 * WIDTH <= (1e-6)){
            index = 2;
        }
        NSLog(@"index %d",  index);
        if(self.currentIndex != index){
            self.currentIndex = index;
            [self goodsRequest];
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
            NSLog(@"today scroll down");
            self.backScrollview.scrollEnabled = YES;
            [self.backScrollview setContentOffset:CGPointMake(currentContentOffset.x,currentContentOffset.y + scrollView.contentOffset.y)
                                      animated:YES];
            
            [self disableAllGoodsCollectionScroll];
        }
        else if( scrollView.contentOffset.y > 0) {
            NSLog(@"today scroll up");
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
@end
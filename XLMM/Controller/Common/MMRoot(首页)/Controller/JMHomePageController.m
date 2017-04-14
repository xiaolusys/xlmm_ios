//
//  JMHomePageController.m
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomePageController.h"
#import "HMSegmentedControl.h"
#import "JMChildViewController.h"
#import "JMHomeFirstController.h"
#import "JMHomeRootCategoryController.h"
#import "JMGoodsCountTime.h"
#import "JMCartViewController.h"
#import "JMLogInViewController.h"
#import "JMFineClassController.h"
#import "JMMaMaHomeController.h"
#import "JumpUtils.h"
#import "JMAutoLoopPageView.h"
#import "JMUpdataAppPopView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMStoreManager.h"
#import "AppDelegate.h"
#import "JMFineCounpGoodsController.h"
#import "JMFineCounpContentController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JMEmptyView.h"
#import "JMPushingDaysController.h"
#import "JMRefundBaseController.h"
#import "ProductSelectionListViewController.h"
#import "JMClassifyListController.h"
#import "JMCouponController.h"


@interface JMHomePageController () <UIScrollViewDelegate, JMUpdataAppPopViewDelegate, JMHomeFirstControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *_categoryNameArray;
    NSMutableArray *_categoryCidArray;
    NSString *_currentCidString;
    NSString *_currentNameString;
    NSString *_cartTimeString;              // 购物车时间
    NSString *_releaseNotes;                // 版本升级信息
    NSString *_hash;                        // 判断是否需要重新下载的哈希值
    NSString *_downloadURLString;           // 地址下载链接
    NSString *urlCategory;                  // 下载分类json文件
    NSMutableArray *_topImageArray;         // 主页头部滚动视图数据
}

@property (nonatomic,strong) UIView *maskView;
/**
 *  版本更新弹出视图
 */
@property (nonatomic, strong) JMUpdataAppPopView *updataPopView;
/**
 *  是否弹出更新视图
 */
@property (nonatomic, assign) BOOL isPopUpdataView;
@property (nonatomic, copy) NSString *latestVersion;
@property (nonatomic, copy) NSString *trackViewUrl1;
@property (nonatomic, copy) NSString *trackName;

@property (nonatomic, strong) NSMutableArray *urlArray;


@property (nonatomic, strong) UIButton *navRightButton;

@property (nonatomic, strong) UIButton *cartButton;
@property (nonatomic, strong) UILabel *cartsLabel;

@property (nonatomic, strong) JMAutoLoopPageView *pageView;
@property (nonatomic, strong) JMEmptyView *empty;
@property (nonatomic, strong) UIView *suspensionView;
@property (nonatomic, strong) JMHomeFirstController *homeFirst;

@end

@implementation JMHomePageController
#pragma mark -- 懒加载
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
    }
    return _maskView;
}
- (JMUpdataAppPopView *)updataPopView {
    if (_updataPopView == nil) {
        _updataPopView = [JMUpdataAppPopView defaultUpdataPopView];
    }
    return _updataPopView;
}


#pragma 程序前后台切换通知处理,  通知事件
- (void)rootViewDidEnterBackground:(NSNotification *)notification {
    [self hideUpdataView];
}
- (void)rootViewWillEnterForeground:(NSNotification *)notification {
    [self autoUpdateVersion];
    if (self.isPopUpdataView == YES) {
        [self performSelector:@selector(updataAppPopView) withObject:nil afterDelay:10.0f];
    }else {
    }
    if (self.homeFirst) {
        [self.homeFirst refresh];
    }
}
- (void)presentView:(NSNotification *)notification{
    //跳转到新的页面
    [JumpUtils jumpToLocation:[notification.userInfo objectForKey:@"target_url"] viewController:self];
}
//- (void)updataAfterLogin:(NSNotification *)notification{
//    // 微信登录
//    [self loginUpdateIsXiaoluMaMa];
//}
//- (void)phoneNumberLogin:(NSNotification *)notification{
//    //  NSLog(@"手机登录");
//    [self loginUpdateIsXiaoluMaMa];
//}
//- (void)loginOut {
//    
//}
//#pragma mark 登陆后刷新个人信息
//- (void)loginUpdateIsXiaoluMaMa {
//    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
//        if ([self isLogin]) {
//            if ([self isXiaolumama]) {
////                [self createRightItem];
//            }else {
//            }
//            //            [self performSelector:@selector(isGetCoupon) withObject:nil afterDelay:2.0];  // 判断用户是否可以领取新手礼包
//        }else {
//        }
//    } failure:^(NSInteger errorCode) {
//    }];
//}
//- (BOOL)isXiaolumama{
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    BOOL isXLMM = [users boolForKey:kISXLMM];
//    return isXLMM;
//}
//- (BOOL)isLogin {
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    BOOL isLog = [users boolForKey:kIsLogin];
//    return isLog;
//}
#pragma mark 视图生命周期
- (instancetype)init {
    if (self == [super init]) {
        _categoryNameArray = [NSMutableArray array];
        _categoryCidArray = [NSMutableArray array];
        _topImageArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"main"];
    
    UIApplication *app = [UIApplication sharedApplication];
    [JMNotificationCenter addObserver:self
                                             selector:@selector(rootViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    [JMNotificationCenter addObserver:self
                                             selector:@selector(rootViewDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:app];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"main"];
}
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[JMGlobal global] clearAllSDCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    
    [JMNotificationCenter addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
//    [JMNotificationCenter addObserver:self selector:@selector(updataAfterLogin:) name:@"weixinlogin" object:nil];
//    [JMNotificationCenter addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
//    [JMNotificationCenter addObserver:self selector:@selector(loginOut) name:@"logout" object:nil];
    
    
//    [self loginUpdateIsXiaoluMaMa];                    // 拿到用户的登录信息与个人信息
    [self createNavigaView];
    [self createSegmentControl];
    [self emptyView];
    [self loadCategoryData];
    [self autoUpdateVersion];                          // 版本自动升级
    [self loadItemizeData];                            // 获取商品分类
    [self loadAddressInfo];                            // 获得地址信息请求
    self.session = [self backgroundSession];           // 后台下载...
    [[JMGlobal global] showWaitLoadingInView:self.view];
}
#pragma mark 数据请求处理
- (void)loadCatrsNumData {
    if ([JMUserDefaults boolForKey:kIsLogin]) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json",Root_URL];
        [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
            if (!responseObject) return ;
            [self cartViewUpData:responseObject];
        } WithFail:^(NSError *error) {
        } Progress:^(float progress) {
        }];
    }else {
        self.cartsLabel.hidden = YES;
    }
}
- (void)cartViewUpData:(NSDictionary *)dic {
    NSInteger cartNum = [dic[@"result"] integerValue];
    if (cartNum == 0) {
        [JMGoodsCountTime initCountDownWithCurrentTime:0];
        self.cartsLabel.hidden = YES;
    }else {
        self.cartsLabel.hidden = NO;
        self.cartsLabel.text = [NSString stringWithFormat:@"%@",dic[@"result"]];
    }
}
- (void)loadCategoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/portal?exclude_fields=activitys",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        self.empty.hidden = YES;
        [[JMGlobal global] hideWaitLoading];
        [_topImageArray removeAllObjects];
        [self fetchCategoryData:responseObject];
    } WithFail:^(NSError *error) {
        self.empty.hidden = NO;
        [[JMGlobal global] hideWaitLoading];
    } Progress:^(float progress) {
    }];
}
- (void)fetchCategoryData:(NSDictionary *)categoryDic {
    NSArray *postersArr = categoryDic[@"posters"];
    for (NSDictionary *dic in postersArr) {
        [_topImageArray addObject:dic];
    }
    NSArray *categorys = categoryDic[@"categorys"];
    [_categoryNameArray addObjectsFromArray:@[@"精品活动",@"每日焦点"]];
    for (NSDictionary *dic in categorys) {
        [_categoryNameArray addObject:dic[@"name"]];
        [_categoryCidArray addObject:dic[@"id"]];
    }
    // 移除已经添加的子控制器
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    [self addChildController];
}
#pragma mark -- 创建UI->自定义 navigationView 自定义悬浮按钮 (个人,精品汇,购物车)
- (void)createSegmentControl {
    self.segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 45)];
    [self.view addSubview:self.segmentControl];
    self.segmentControl.backgroundColor = [UIColor whiteColor];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = 2.f;
    self.segmentControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
    [self createScrollView];
    kWeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf removeToPage:index];
    }];
}
- (void)createScrollView {
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    [self.view addSubview:self.baseScrollView];

}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 300) / 2, SCREENWIDTH, 300) Title:@"~~(>_<)~~" DescTitle:@"网络加载失败~!" BackImage:@"netWaring" InfoStr:@"重新加载"];
    [self.view addSubview:self.empty];
    self.empty.hidden = YES;
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            weakSelf.empty.hidden = YES;
            [weakSelf loadCategoryData];
        }
    };
}
- (void)addChildController {
    self.segmentControl.sectionTitles = [_categoryNameArray copy];
    for (int i = 0 ; i < _categoryNameArray.count; i++) {
        if (i == 0) {
            JMFineCounpGoodsController *fineVC = [[JMFineCounpGoodsController alloc] init];
            [self addChildViewController:fineVC];
            [fineVC didMoveToParentViewController:self];
        }else if (i == 1){
            JMHomeFirstController *homeFirst = [[JMHomeFirstController alloc] init];
            homeFirst.delegate = self;
            homeFirst.pageController = self;
            homeFirst.topImageArray = _topImageArray;
            [self addChildViewController:homeFirst];
            [homeFirst didMoveToParentViewController:self];
            self.homeFirst = homeFirst;
        }else {
            JMFineCounpContentController *childCategoryVC = [[JMFineCounpContentController alloc] init];
            childCategoryVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@", Root_URL,_categoryCidArray[i - 2]];
//            childCategoryVC.categoryCid = _categoryCidArray[i - 2];
            [self addChildViewController:childCategoryVC];
            [childCategoryVC didMoveToParentViewController:self];
        }
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * _categoryNameArray.count, self.baseScrollView.frame.size.height);
    [self removeToPage:0];

}
- (void)createNavigaView {
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 83, 44)];
    UIImageView *titleImage = [UIImageView new];
    titleImage.image = [UIImage imageNamed:@"name"];
    [naviView addSubview:titleImage];
    self.navigationItem.titleView = naviView;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(naviView.mas_centerX);
        make.centerY.equalTo(naviView.mas_centerY);
        make.width.mas_equalTo(@83);
        make.height.mas_equalTo(@20);
    }];
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton addTarget:self action:@selector(searchBarClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBarImage"]];
//    leftImageview.frame = CGRectMake(0, 13, 18, 18);
//    [leftButton addSubview:leftImageview];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

#pragma mark 移动到某个子视图
- (void)removeToPage:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        self.segmentControl.mj_y = 64;
        self.baseScrollView.mj_y = self.segmentControl.cs_max_Y;
    }];
//    if (index == 0 || index == 1) {
//        _currentCidString = _categoryCidArray[0];
//        _currentNameString = _categoryNameArray[2];
//    }else {
//        _currentCidString = _categoryCidArray[index - 2];
//        _currentNameString = _categoryNameArray[index - 2];
//    }
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    if (index == 0) {
        JMFineCounpGoodsController *fineVC = self.childViewControllers[index];
        fineVC.view.frame = self.baseScrollView.bounds;
        [self.baseScrollView addSubview:fineVC.view];
//        [fineVC didMoveToParentViewController:self];
    }else if (index == 1) {
        JMHomeFirstController *homeFirst = self.childViewControllers[index];
        homeFirst.view.frame = self.baseScrollView.bounds;
        [self.baseScrollView addSubview:homeFirst.view];
//        [homeFirst didMoveToParentViewController:self];
    }else {
        JMFineCounpContentController *childCategoryVC = self.childViewControllers[index];
        childCategoryVC.view.frame = self.baseScrollView.bounds;
        [self.baseScrollView addSubview:childCategoryVC.view];
//        [childCategoryVC didMoveToParentViewController:self];
    }
    NSDictionary *tempDict = @{@"segmentPage" : [NSString stringWithFormat:@"%@",_categoryNameArray[index]]};
    [MobClick event:@"currentSegmentPageWithHomeRoot" attributes:tempDict];
}
#pragma mark 点击事件处理
- (void)searchBarClick:(UIButton *)button {
    JMHomeRootCategoryController *rootCategoryVC = [[JMHomeRootCategoryController alloc] init];
    rootCategoryVC.cidString = CS_STRING(_currentCidString);
    rootCategoryVC.titleString = CS_STRING(_currentNameString);
    rootCategoryVC.categoryUrl = urlCategory;
    [self.navigationController pushViewController:rootCategoryVC animated:YES];
}

#pragma mark UIScrollViewDelegate 代理实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView { }
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self removeToPage:page];
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
}
- (void)scrollViewDeceleratingScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self removeToPage:page];
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
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
    }else {
        self.isPopUpdataView = NO;
    }
}
- (void)updataAppPopView {
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideUpdataView)]];
    self.updataPopView.releaseNotes = _releaseNotes;
    self.updataPopView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.updataPopView];
    [JMPopViewAnimationSpring showView:self.updataPopView overlayView:self.maskView];
}
- (void)composeUpdataAppButton:(JMUpdataAppPopView *)updataButton didClick:(NSInteger)index {
    self.isPopUpdataView = NO;
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
#pragma mark - 获取商品分类列表
- (void)loadItemizeData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/categorys/latest_version",Root_URL];
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
    NSString *isUpData = dic[@"sha1"];
    urlCategory = dic[@"download_url"];
    NSString *oldVersion = [JMUserDefaults stringForKey:@"itemHash"];
    if (oldVersion == nil) {
        [self downLoadUrl:urlCategory];
    }else {
        if ([oldVersion isEqualToString:isUpData] && [JMStoreManager isFileExist:@"GoodsItemFile.json"]) {
        }else {
            [self downLoadUrl:urlCategory];
        }
    }
    [JMUserDefaults setObject:isUpData forKey:@"itemHash"];
    [JMUserDefaults synchronize];
}
- (void)downLoadUrl:(NSString *)urlStr {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"默认下载地址%@",targetPath);
        [JMStoreManager removeFileByFileName:@"GoodsItemFile.json"];
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
    NSString *oldVersion = [JMUserDefaults stringForKey:@"hash"];
    if (oldVersion == nil) {
        [self startDownload:_downloadURLString];
    }else {
        [oldVersion isEqualToString:_hash] && [JMStoreManager isFileExist:@"addressInfo.json"] ? : [self startDownload:_downloadURLString];
    }
    [JMUserDefaults setObject:_hash forKey:@"hash"];
    [JMUserDefaults synchronize];
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
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *addressPath = [JMStoreManager getFullPathWithFile:@"addressInfo.json"];
    NSURL *pathUrl = [NSURL fileURLWithPath:addressPath];
    NSError *errorCopy;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:pathUrl error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:location toURL:pathUrl error:nil];
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

#pragma mark 悬浮视图手势事件
- (void)suspensionViewTap:(UIPanGestureRecognizer *)pan {
    CGFloat topInsetheight = 109.f;
    CGFloat spaceFloat = 20.f;
    CGPoint point = [pan translationInView:self.suspensionView];
    CGRect originalFrame = self.suspensionView.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= SCREENWIDTH) {
        originalFrame.origin.x += point.x;
    }if (originalFrame.origin.y >= topInsetheight && originalFrame.origin.y + originalFrame.size.height <= SCREENHEIGHT) {
        originalFrame.origin.y += point.y;
    }
    self.suspensionView.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self.suspensionView];
    if (pan.state == UIGestureRecognizerStateBegan) {
//        self.suspensionView.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
    } else {
        CGRect frame = self.suspensionView.frame;
        //是否越界
        BOOL isOver = NO;
        if (frame.origin.x < 0) {
            frame.origin.x = spaceFloat;
            isOver = YES;
        } else if (frame.origin.x+frame.size.width > SCREENWIDTH) {
            frame.origin.x = SCREENWIDTH - frame.size.width - spaceFloat;
            isOver = YES;
        }if (frame.origin.y < topInsetheight) {
            frame.origin.y = topInsetheight + spaceFloat;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > SCREENHEIGHT) {
            frame.origin.y = SCREENHEIGHT - frame.size.height - spaceFloat;
            isOver = YES;
        }if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.suspensionView.frame = frame;
            }];
        }
//        self.suspensionView.enabled = YES;
    }
}







@end
















/*
 //    [self createRightItem];
 
 - (void)createRightItem {
 if(self.navigationItem.rightBarButtonItem == nil) {
 NSString *titleStr = @"精品汇";
 CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
 self.navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
 [self.navRightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
 [self.navRightButton setTitle:titleStr forState:UIControlStateNormal];
 [self.navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
 self.navRightButton.titleLabel.font = [UIFont systemFontOfSize:14.];
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
 }else {}
 }
 - (void)rightNavigationClick:(UIButton *)button {
 BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
 BOOL xlmm = [[NSUserDefaults standardUserDefaults] boolForKey:kISXLMM];
 if (login && xlmm) {
 JMFineClassController *fineVC = [[JMFineClassController alloc] init];
 [self.navigationController pushViewController:fineVC animated:YES];
 }else {
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 [self.navigationController pushViewController:enterVC animated:YES];
 }
 }

 //    [self createSuspensionView];                       // 创建悬浮视图 (个人,精品汇,购物车)
 
 
 - (void)createSuspensionView {
 UIView *suspensionView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREENHEIGHT - 70, 160, 50)];
 [self.view addSubview:suspensionView];
 //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(suspensionViewTap:)];
 //    [suspensionView addGestureRecognizer:pan];
 self.suspensionView = suspensionView;
 //    self.suspensionView.backgroundColor = [UIColor colorWithRed:1/255.f green:1/255.f blue:1/255.f alpha:0.1];
 NSArray *imageArr = @[@"tabBar_personalSelected",@"homePagejingpinhui",@"tabBar_shoppingCartSelected"];
 for (int i = 0 ; i < imageArr.count; i ++) {
 UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
 customButton.backgroundColor = [UIColor blackColor];
 customButton.alpha = 0.8;
 customButton.layer.cornerRadius = 22;
 customButton.layer.borderWidth = 1;
 customButton.layer.borderColor = [UIColor settingBackgroundColor].CGColor;
 customButton.tag = 100 + i;
 [customButton addTarget:self action:@selector(suspensionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
 [suspensionView addSubview:customButton];
 [customButton mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(suspensionView).offset(4 + 54 * i);
 make.top.equalTo(suspensionView).offset(3);
 make.size.mas_equalTo(CGSizeMake(44, 44));
 }];
 
 UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
 iconView.image = [UIImage imageNamed:imageArr[i]];
 iconView.userInteractionEnabled = NO;
 [customButton addSubview:iconView];
 
 if (i == (imageArr.count - 1)) {
 self.cartsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, -6, 16, 16)];
 [iconView addSubview:self.cartsLabel];
 self.cartsLabel.font = [UIFont systemFontOfSize:10.];
 self.cartsLabel.textColor = [UIColor whiteColor];
 self.cartsLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
 self.cartsLabel.textAlignment = NSTextAlignmentCenter;
 self.cartsLabel.layer.cornerRadius = 8.;
 self.cartsLabel.layer.masksToBounds = YES;
 self.cartsLabel.hidden = YES;
 }
 }
 self.cartButton = (UIButton *)[self.view viewWithTag:102];
 
 }

 - (void)suspensionButtonClick:(UIButton *)button {
 BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
 BOOL xlmm = [[NSUserDefaults standardUserDefaults] boolForKey:kISXLMM];
 switch (button.tag) {
 case 100:
 {
 if (login) {
 JMMaMaHomeController *personalVC = [[JMMaMaHomeController alloc] init];
 [self.navigationController pushViewController:personalVC animated:YES];
 }else {
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 [self.navigationController pushViewController:enterVC animated:YES];
 }
 }
 break;
 case 101:
 {
 if (login && xlmm) {
 JMFineClassController *fineVC = [[JMFineClassController alloc] init];
 [self.navigationController pushViewController:fineVC animated:YES];
 }else {
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 [self.navigationController pushViewController:enterVC animated:YES];
 }
 }
 break;
 case 102:
 {
 if (login) {
 JMCartViewController *cartVC = [[JMCartViewController alloc] init];
 [self.navigationController pushViewController:cartVC animated:YES];
 }else {
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 [self.navigationController pushViewController:enterVC animated:YES];
 }
 }
 break;
 default:
 break;
 }
 
 }
 */
































//
//  TodayViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TodayViewController.h"
#import "MMClass.h"
#import "Head1View.h"
#import "Head2View.h"
#import "PeopleCollectionCell.h"
#import "PosterCollectionCell2.h"
#import "PromoteModel.h"
#import "PosterModel.h"
#import "ChildViewController.h"
#import "MJRefresh.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "AFNetworking.h"
#import "PostersViewController.h"
#import "CartViewController.h"
#import "MMNavigationDelegate.h"
#import "NSString+URL.h"
#import "Reachability.h"
#import "RESideMenu.h"
#import "MJPullGifHeader.h"
#import "MobClick.h"
#import "UIViewController+NavigationBar.h"
#import "MMAdvertiseView.h"
#import "HuodongViewController.h"
#import "HuodongCollectionViewCell.h"
#import "WXLoginController.h"





static NSString *ksimpleCell = @"simpleCell";
static NSString *kposterView = @"posterView";
static NSString *khead1View = @"head1View";
static NSString *khead2View = @"head2View";
static NSString *khuodongCell = @"HuodongCell";


#define UPDATE_URLSTRING [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1051166985"]

@interface TodayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    NSMutableArray *childDataArray;
    NSMutableArray *ladyDataArray;
    NSMutableArray *posterDataArray;
    
    NSInteger childListNumber;
    NSInteger ladyListNumber;
    BOOL login_required;
//    BOOL _isShouldLoad;
    

    NSTimer *theTimer;
    UIView *activityView;

    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    BOOL _isFirst;
    BOOL step1;
    BOOL step2;
    BOOL _isDone;
    UIView *backView;
    
    BOOL _updating;
    
    BOOL _isFirstChild;
    
    CGFloat oldScrollViewTop;
    
    
    NSString *nextUrl;
    NSMutableArray *targetUrls;
    BOOL _ishaveHuodong;
    NSDictionary *huodongJson;
    
    NSString *mobel;
}
@property (nonatomic, copy) NSString *latestVersion;
@property (nonatomic, copy) NSString *trackViewUrl1;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, retain) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *posterImages;

@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TodayViewPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TodayViewPage"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
   
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [reach startNotifier];
    
    if (_isFirst) {
        //集成刷新控件
//        _isFirst = NO;
    }
    
}

- (NSString *)stringFromStatus:(NetworkStatus)status{
    NSString *string;
    switch (status) {
        case NotReachable:
            string = @"无网络连接，请检查您的网络";
            break;
        case ReachableViaWiFi:
            string = @"wifi";
            break;
        case ReachableViaWWAN:
            string = @"wwan";
            break;
            
        default:
            
            string = @"unknown";
            break;
    }
    return string;
}
- (void)reachabilityChanged:(NSNotification *)notification{
    
    Reachability *reach = [notification object];
    
    if([reach isKindOfClass:[Reachability class]]){
        
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            UIAlertView *alterView = [[UIAlertView alloc]  initWithTitle:nil message:[self stringFromStatus:status] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alterView show];
        }
        //Insert your code here
        
    }
    
}


- (void)reload
{
    [self downloadData];
}

- (void)loadMore
{
   // NSLog(@"lodeMore url = %@", nextUrl);
    if ([nextUrl isKindOfClass:[NSString class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _updating = YES;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nextUrl]];
            [self performSelectorOnMainThread:@selector(fetchedPromoteMorePageData:)withObject:data waitUntilDone:YES];
        });
    } else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
   
    
    [self performSelector:@selector(stopFootRefresh) withObject:nil afterDelay:2];
}

- (void)stopFootRefresh{
    [self.myCollectionView.mj_footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 数据初始化。。。。
    childDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ladyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    targetUrls = [[NSMutableArray alloc] initWithCapacity:2];
    _ishaveHuodong = NO;
    step1 = NO;
    step2 = NO;
    _isFirst = YES;
    _isDone = NO;
    [self createCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCurrentState) name:UIApplicationDidBecomeActiveNotification object:nil];
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myCollectionView.mj_header = header;
    [self.myCollectionView.mj_header beginRefreshing];
    
    //判断系统版本
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
          [footer setAutomaticallyHidden:YES];
            self.myCollectionView.mj_footer = footer;
    }
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
  //  [footer setAutomaticallyHidden:YES];
//    self.myCollectionView.mj_footer = footer;
    
    
//    _isShouldLoad = YES;
  //  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1051166985"]];
    [self downLoadWithURLString:UPDATE_URLSTRING andSelector:@selector(fetchedUpdateData:)];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        [self performSelectorOnMainThread:@selector(fetchedUpdateData:)withObject:data waitUntilDone:YES];
//        
//    });
  
    [self ishavemobel];

}

- (void)fetchedUpdateData:(NSData *)data{
    NSError *error = nil;
    if (data == nil) {
        [self.myCollectionView.mj_header endRefreshing];
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"appInfoDic = %@", appInfoDic);
    if (error) {
    }
    NSArray *reluts = [appInfoDic objectForKey:@"results"];
    if (![reluts count]) {
    }
    NSDictionary *infoDic = reluts[0];
    
    
    
    self.latestVersion = [infoDic objectForKey:@"version"];
    self.trackViewUrl1 = [infoDic objectForKey:@"trackViewUrl"];//地址trackViewUrl
    self.trackName = [infoDic objectForKey:@"trackName"];//trackName
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
  
    NSString *app_Version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    double doubleCurrentVersion = [app_Version doubleValue];
    
    double doubleUpdateVersion = [self.latestVersion doubleValue];
    
    
 
    if (doubleCurrentVersion < doubleUpdateVersion) {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:self.trackName
                                           message:@"有新版本，是否升级！"
                                          delegate: self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles: @"升级", nil];
        alert.tag = 1001;
        [alert show];
    }
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl1]];
        }
    }
}

- (void)saveCurrentState{
}
- (void)restoreCurrentState{
    if (self.navigationController.isNavigationBarHidden) {
        [self.delegate hiddenNavigation];
        
    } else{
        [self.delegate showNavigation];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//设计倒计时方法。。。。
- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int nextday = day + 1;
    
    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:nextday];
    [endTime setHour:14];
    [endTime setMinute:0];
    [endTime setSecond:0];
    
    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;
    
    
    if ((long)[d day] == 0) {
        string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    }
    else{
        string = [NSString stringWithFormat:@"剩余%ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
    
    }
    childTimeLabel.text = string;
    ladyTimeLabel.text = string;
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5 );
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 20 - 33) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    [self.myCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    [self.myCollectionView registerClass:[PosterCollectionCell2 class] forCellWithReuseIdentifier:kposterView];
    [self.myCollectionView registerClass:[Head1View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead1View];
    [self.myCollectionView registerClass:[Head2View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View];
    [self.myCollectionView registerClass:[HuodongCollectionViewCell class] forCellWithReuseIdentifier:khuodongCell];
    [self.view addSubview:self.myCollectionView];
    
//    self.myCollectionView.contentOffset = CGPointMake(0, 50);
//    self.myCollectionView.backgroundColor = [UIColor greenColor];
}


- (void)downloadData{
    if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
        [self.delegate showNavigation];
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/products/promote_today_paging?page_size=10",Root_URL];
    //NSLog(@"string = %@", urlStr);
    [self downLoadWithURLString:urlStr andSelector:@selector(fetchedPromotePageData:)];
    [self downLoadWithURLString:kTODAY_POSTERS_URL andSelector:@selector(fetchedPosterData:)];
}


#pragma mark --今题推荐数据解析

- (void)fetchedPosterData:(NSData *)data{
    NSError *error;
    [posterDataArray removeAllObjects];
    if (data == nil) {

        return;
    }
   NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   // NSLog(@"posters = %@", jsonDic);
    
    NSArray *childArray = [jsonDic objectForKey:@"chd_posters"];
    self.posterImages = [[NSMutableArray alloc] init];

    for (NSDictionary *childDic in childArray) {
        PosterModel *childModel = [PosterModel new];
        childModel.imageURL = [childDic objectForKey:@"pic_link"];
        childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
        childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
        
        UIImage *image0 = [UIImage imagewithURLString:[childModel.imageURL URLEncodedString]];
        [self.posterImages addObject:image0];
        [posterDataArray addObject:childModel];


    }
   
   
    
    NSArray *ladyArray = [jsonDic objectForKey:@"wem_posters"];
    for (NSDictionary *ladyDic in ladyArray) {
    
        PosterModel *ladyModel = [PosterModel new];
        ladyModel.imageURL = [ladyDic objectForKey:@"pic_link"];
        ladyModel.firstName = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
        ladyModel.secondName = [[ladyDic objectForKey:@"subject"] objectAtIndex:1];
        
        UIImage *image1 = [UIImage imagewithURLString:[ladyModel.imageURL URLEncodedString]];
        [self.posterImages addObject:image1];
        [posterDataArray addObject:ladyModel];

    }
    
    
    
    
    if ([[jsonDic objectForKey:@"activity"] isKindOfClass:[NSDictionary class]]) {
        _ishaveHuodong = YES;
        huodongJson = [jsonDic objectForKey:@"activity"];
        login_required = [[huodongJson objectForKey:@"login_required"] boolValue];
        
        
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *activityID = [[huodongJson objectForKey:@"id"] stringValue];
        NSString *userNumber = [defaults objectForKey:@"activityid"];
        
      
        if ([activityID isEqualToString:userNumber]) {
  
        } else {
            if ([[huodongJson objectForKey:@"mask_link"] class] == [NSNull class]) {
            } else {
                if ([[huodongJson objectForKey:@"mask_link"] isEqualToString:@""]) {
                    
                } else{
                    
                
                    backView = [[UIView alloc] initWithFrame:self.view.bounds];
                    backView.backgroundColor = [UIColor blackColor];
                    backView.alpha = 0.5;
                    [self.view addSubview:backView];
                    NSArray *array;
                    array = [[NSBundle mainBundle] loadNibNamed:@"StartActivityView" owner:nil options:nil];
                  
                    
                    activityView = array[0];
                    activityView.frame = CGRectMake(0, 0, 300, 280);
                    UIButton *button = (UIButton *)[activityView viewWithTag:200];
                    [button addTarget:self action:@selector(guanbiClicked:) forControlEvents:UIControlEventTouchUpInside];
                    UIImageView *imageView = [activityView viewWithTag:100];
                    activityView.center = self.view.center;
                    
                   
                    NSString *imageUrl = [huodongJson objectForKey:@"mask_link"];
                    
                    UIImage *image = [UIImage imagewithURLString:imageUrl];
                    imageView.image = image;
                  
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huodongrukou)];
                    [imageView addGestureRecognizer:tap];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.layer.masksToBounds = YES;
                    imageView.userInteractionEnabled = YES;
                    [self.view addSubview:activityView];
                    [defaults setObject:activityID forKey:@"activityid"];
                }
                
                
                
            }
          
        }
        
        
    }

    step1 = YES;
    if (step1 && step2) {
        step1 = NO;
        step2 = NO;
        NSRange range = {1,2};
        if (_isFirst == YES) {
            _isFirst = NO;
            [self.myCollectionView reloadData];
        } else{
            [self.myCollectionView reloadSections:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        }
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
    }
}

- (void)guanbiClicked:(UIButton *)button{
    [backView removeFromSuperview];
    [activityView removeFromSuperview];
    
}

- (void)huodongrukou{
  
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
        
        huodongVC.diction = huodongJson;
        
        
        [self.navigationController pushViewController:huodongVC animated:YES];
        [backView removeFromSuperview];
        [activityView removeFromSuperview];
    } else{
        if (login_required) {
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else{
            HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
            
            huodongVC.diction = huodongJson;
            
            
            [self.navigationController pushViewController:huodongVC animated:YES];
            [backView removeFromSuperview];
            [activityView removeFromSuperview];
        }
        
        
        
    }

    
}

- (void)fetchedPromoteMorePageData:(NSData *)data{
    _updating = NO;
    if (data == nil) {
        
        return;
    }
    
    NSError *error = nil;
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    nextUrl = [promoteDic objectForKey:@"next"];
    NSArray *results = [promoteDic objectForKey:@"results"];
    
    NSMutableArray *reloadNum = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *ladyInfo in results) {
        
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        NSDictionary *category = model.category;
        
        if ([[category objectForKey:@"cid"] integerValue] == 8 || [[category objectForKey:@"parent_cid"] integerValue] == 8) {
            //女装
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ladyDataArray.count inSection:1];
            [ladyDataArray addObject:model];
            [reloadNum addObject:indexPath];
        } else{
//            if (childDataArray.count == 0 ) {
//                NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
//                
//                [self.myCollectionView insertSections:set];
//            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:childDataArray.count inSection:2];
            [childDataArray addObject:model];
            [reloadNum addObject:indexPath];
        }
    }
    
    [self.myCollectionView insertItemsAtIndexPaths:reloadNum];

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
//        [self.myCollectionView reloadData];
//    }else {
//        [self.myCollectionView insertItemsAtIndexPaths:reloadNum];
//    }
    
}
- (void)fetchedPromotePageData:(NSData *)data{
    
    [childDataArray removeAllObjects];
    [ladyDataArray removeAllObjects];
    if (data == nil) {
        
        return;
    }
    NSError *error = nil;
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"err = %@", error);
//     NSLog(@"promote = %@", promoteDic);
    
    nextUrl = [promoteDic objectForKey:@"next"];
    NSArray *results = [promoteDic objectForKey:@"results"];
    
   
    
    for (NSDictionary *ladyInfo in results) {
        
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        NSDictionary *category = model.category;
       // NSLog(@"cid = %@ , parent_id = %@", [category objectForKey:@"cid"], [category objectForKey:@"parent_cid"]);
        if ([[category objectForKey:@"cid"] integerValue] == 8 || [[category objectForKey:@"parent_cid"] integerValue] == 8) {
            [ladyDataArray addObject:model];
        } else{
            [childDataArray addObject:model];
        }
    }
   // NSLog(@"childcount = %ld, ladyCount = %ld", childDataArray.count, ladyDataArray.count);
    
    
    step2 = YES;
    
    if (step1 && step2) {
        step1 = NO;
        step2 = NO;
        NSRange range = {1,2};
        if (_isFirst == YES) {
            _isFirst = NO;
            [self.myCollectionView reloadData];
        } else{
            [self.myCollectionView reloadSections:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        }
           [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
        
    }

}

- (void)fetchedPromoteData:(NSData *)data{
    NSError *error;
    [childDataArray removeAllObjects];
    [ladyDataArray removeAllObjects];
    if (data == nil) {

        return;
    }
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   // NSLog(@"promote = %@", promoteDic);
    NSArray *ladyArray = [promoteDic objectForKey:@"female_list"];
   
    ladyListNumber = ladyArray.count;
    if (ladyListNumber == 0) {
       // return;
    }
   
    for (NSDictionary *ladyInfo in ladyArray) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        
        
        [ladyDataArray addObject:model];
        
    }
    
    PromoteModel *firstModel = [ladyDataArray objectAtIndex:0];
    NSString *string = firstModel.picPath;
    

    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    
    [defualt setObject:string forKey:@"imageUrlString"];
    [defualt synchronize];
    
    
    
    
    
    NSArray *childArray = [promoteDic objectForKey:@"child_list"];
    if (childArray.count == 0) {
        return;
    }
    if (![childArray isKindOfClass:[NSArray class]]) {
        return;
    }
     childListNumber = childArray.count;
   
    
    for (NSDictionary *childInfo in childArray) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:childInfo];
        
    
        [childDataArray addObject:model];
        
    }
    
    step2 = YES;
    
    if (step1 && step2) {
        step1 = NO;
        step2 = NO;
        [self.myCollectionView reloadData];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];

    }
    
    
}

- (void)stopRefresh{
    [self.myCollectionView.mj_header endRefreshing];
    
}

//- (PromoteModel *)fillModel:(NSDictionary *)dic{
//    PromoteModel *model = [PromoteModel new];
//    model.name = [dic objectForKey:@"name"];
//    
//    model.Url = [dic objectForKey:@"url"];
//    model.agentPrice = [dic objectForKey:@"lowest_price"];
//    model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
//    model.outerID = [dic objectForKey:@"outer_id"];
//    model.isNewgood = [dic objectForKey:@"is_newgood"];
//    model.isSaleopen = [dic objectForKey:@"is_saleopen"];
//    model.isSaleout = [dic objectForKey:@"is_saleout"];
//    model.ID = [dic objectForKey:@"id"];
//    model.category = [dic objectForKey:@"category"];
//    model.remainNum = [dic objectForKey:@"remain_num"];
//    model.saleTime = [dic objectForKey:@"sale_time"];
//    model.wareBy = [dic objectForKey:@"ware_by"];
//    model.watermark_op = [dic objectForKey:@"watermark_op"];
//    if ([[dic objectForKey:@"product_model"]class] == [NSNull class]) {
//        model.productModel = nil;
//          model.picPath = [dic objectForKey:@"head_img"];
//        model.productModel = nil;
//        
//    } else{
//        model.productModel = [dic objectForKey:@"product_model"];
//        
//        
//        if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
//            model.picPath = [dic objectForKey:@"head_img"];
//            
//        } else{
//            if ([[model.productModel objectForKey:@"head_imgs"] count] != 0) {
//                model.picPath = [[model.productModel objectForKey:@"head_imgs"] objectAtIndex:0];
//                
//            }
//            model.name = [model.productModel objectForKey:@"name"];
//            
//        }
//        
//    }
//    return model;
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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


#pragma mark --UICollectionViewDelegate--

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
//        if (childDataArray.count == 0) {
//            //如果童装数据为零就返回2个分区
//            return 2;
//        }else {
//            return 3;
//        }
//    }else {
//        return 3;
//    }
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (_ishaveHuodong) {
            return 2;
        } else {
            return 1;
        }
    } else if (section == 1){
        if (ladyDataArray.count == 0) {
            return 2;
        }
        return ladyDataArray.count;
   
    } else if (section == 2){
        
        return childDataArray.count;
        
    
    }
    return 0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREENWIDTH, SCREENWIDTH*253/618);
            
        } else {
            return CGSizeMake(SCREENWIDTH, 100 *SCREENWIDTH/320);
            
        }
        
    }

    return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *8/6 + 60);
  
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    return 5;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREENWIDTH, 0);
        
    } else if (section == 1){
        return CGSizeMake(SCREENWIDTH, 60);
    }
    else if (section == 2){
        if (childDataArray.count == 0) {
            return CGSizeZero;
        }
        return CGSizeMake(SCREENWIDTH, 60);
    }
    return CGSizeZero;
    
}

- (void)tapgesture:(UITapGestureRecognizer *)gesture{
  //  NSLog(@"22222");
    MMAdvertiseView *view =(MMAdvertiseView *)[gesture.view superview];
//    NSLog(@"view = %@", view);
//    NSLog(@"%ld", view.currentImageIndex);
//    NSInteger index = [view currentImageIndex];
//    if (targetUrls.count >1) {
//        NSString *urlString = [targetUrls objectAtIndex:index];
//        NSLog(@"urlString = %@", urlString);
//        
//    }
    if (view.currentImageIndex == 0) {
        PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/childlist", Root_URL];
        childVC.urlString = string;
        childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
        childVC.titleName = @"潮童装区";
        childVC.childClothing = YES;
        [self.navigationController pushViewController:childVC animated:YES];
    } else {
        PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/ladylist", Root_URL];

        childVC.urlString = string;
        childVC.orderUrlString = kLADY_LIST_ORDER_URL;
        childVC.titleName = @"时尚女装";
        childVC.childClothing = NO;
        [self.navigationController pushViewController:childVC animated:YES];

        
    }
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
       
      
        PosterCollectionCell2 *cell0 = (PosterCollectionCell2 *)[collectionView dequeueReusableCellWithReuseIdentifier:kposterView forIndexPath:indexPath];
        HuodongCollectionViewCell *cell1 = (HuodongCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:khuodongCell forIndexPath:indexPath];
        
        if (posterDataArray.count != 0) {
            
        
            if (indexPath.row == 0) {

                
                MMAdvertiseView *adView = [[MMAdvertiseView alloc] initWithFrame:cell.bounds andImages:self.posterImages];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
                [adView.scrollView addGestureRecognizer:tap];
                
                [cell0.contentView addSubview:adView];
//                NSLog(@"cell.subView = %@", cell.contentView.subviews);
//                NSLog(@"cell0 = %@", cell0);
                return cell0;

            } else {
                
                cell1.huodongImageView.contentMode = UIViewContentModeScaleAspectFill;
                cell1.huodongImageView.layer.masksToBounds = YES;
//                UIImage *image = [UIImage imagewithURLString:[huodongJson objectForKey:@"act_img"]];
//                if (image != nil) {
//                cell1.huodongImageView.image = image;
//                }
                
                [cell1.huodongImageView sd_setImageWithURL:[NSURL URLWithString:[huodongJson objectForKey:@"act_img"]]];
              
               
               // NSLog(@"cell.subView = %@", cell.contentView.subviews);

               // NSLog(@"cell1 = %@", cell1);
                return cell1;

            }
            
            


            
           
        }
        
        return cell0;
       
    }
    else if (indexPath.section == 2)
    {
        if (childDataArray.count != 0) {
            PromoteModel *model = [childDataArray objectAtIndex:indexPath.row];
            [cell fillData:model];
            return cell;
        }
    
    }
    
    else {
        if (ladyDataArray.count != 0) {
            PromoteModel *model = [ladyDataArray objectAtIndex:indexPath.row];
            [cell fillData:model];
 
            return cell;
        }
        
    }
    return cell;;
   
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;
    if (indexPath.section == 0) {
           headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead1View forIndexPath:indexPath];
        return headerView;
    } else if (indexPath.section == 2){
        
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View forIndexPath:indexPath];
        headerView.nameLabel.text = @"萌娃专区";
        childTimeLabel = headerView.timeLabel;
        headerView.headImageView.image = [UIImage imageNamed:@"childIcon.png"];
        return headerView;
    } else if (indexPath.section == 1){
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View forIndexPath:indexPath];
        headerView.nameLabel.text = @"时尚女装";
        childTimeLabel = headerView.timeLabel;

        headerView.headImageView.image = [UIImage imageNamed:@"ladyIcon.png"];
        return headerView;
    }
    
    
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
   
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [_slimeView scrollViewDidScroll];
    
    if (scrollView.contentOffset.y <200 && scrollView.contentOffset.y > -400) {
      //  NSLog(@"%F", scrollView.contentOffset.y);
        //下滑 小于0，  上滑 大于 0
        return;
    }
    CGPoint point = scrollView.contentOffset;
    CGFloat temp = oldScrollViewTop - point.y;
    
    
//    NSLog(@"%f", scrollView.contentSize.height - scrollView.contentOffset.y);
//    CGFloat distance = scrollView.contentSize.height - scrollView.contentOffset.y;
//    if (distance < 1500 && _isShouldLoad) {
//        [self loadMore];
//        _isShouldLoad = NO;
//    }
    
    
    CGFloat marine = 120;
    if (temp > marine) {
        if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
            [self.delegate showNavigation];
        }
      
        
    } else if (temp < -5){
        if (self.delegate && [self.delegate performSelector:@selector(hiddenNavigation)]) {
            [self.delegate hiddenNavigation];
        }
    }
    if (temp > marine ) {
        oldScrollViewTop = point.y;
        return;
        
    }
    if (temp < 0 - marine) {
        oldScrollViewTop = point.y;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return UIEdgeInsetsMake(0, 5, 50, 5);
    }
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)ishavemobel{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    mobel = [dic objectForKey:@"mobile"];
    NSLog(@"mobel = %@", mobel);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            
        } else{
          
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
              
                [self ishavemobel];
                if ([mobel isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginMethod] isEqualToString:kWeiXinLogin]) {
                    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
;
                    NSLog(@"请绑定手机");
                    WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
                    wxloginVC.userInfo = dic;
                    [self.navigationController pushViewController:wxloginVC animated:YES];
                    
                    
                    
                    
                } else {
                    HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
                    
                    huodongVC.diction = huodongJson;
                    
                    
                    [self.navigationController pushViewController:huodongVC animated:YES];
                }
                
                
            } else{
                if (login_required) {
                    LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
                    [self.navigationController pushViewController:loginVC animated:YES];
                } else{
                    [self ishavemobel];
                    if ([mobel isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginMethod] isEqualToString:kWeiXinLogin]) {
                        
                        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
                        ;
                        NSLog(@"请绑定手机");
                        WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
                        wxloginVC.userInfo = dic;
                        [self.navigationController pushViewController:wxloginVC animated:YES];
                        
                    } else {
                        HuodongViewController *huodongVC = [[HuodongViewController alloc] init];
                        
                        huodongVC.diction = huodongJson;
                        
                        
                        [self.navigationController pushViewController:huodongVC animated:YES];
                    }
                }
            

                
            }
            
            
            
            
        }
        
    } else if (indexPath.section == 2){
        if (childDataArray.count == 0) {
            return;
        }
        PromoteModel *model = [childDataArray objectAtIndex:indexPath.row];

        if (model.productModel == nil) {
           
            MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:YES];
         
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {

                MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:YES];

                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else{
                NSString *modelID = [model.productModel objectForKey:@"id"];
               
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:modelID isChild:YES];
       
                [self.navigationController pushViewController:collectionVC animated:YES];
                
            }
        }
        
        
    } else if (indexPath.section == 1){
        if (ladyDataArray.count == 0) {
            return;
        }
        PromoteModel *model = [ladyDataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
           
            MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:NO];
       
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
             
                MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:NO];
               
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else{
                NSString *modelID = [model.productModel objectForKey:@"id"];
              
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:modelID isChild:NO];
                [self.navigationController pushViewController:collectionVC animated:YES];
                
            }
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    
  //  NSLog(@"%ld", (long)indexPath.section);
    
    if (childDataArray.count == 0) {
        if ((ladyDataArray.count - indexPath.row < 5) && !_updating) {
            [self loadMore];
        };
    }else {
        if (childDataArray.count - indexPath.row < 5  && !_updating) {
            [self loadMore];
        }
    }
}


@end

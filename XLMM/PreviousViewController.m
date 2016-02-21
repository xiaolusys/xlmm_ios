//
//  TodayViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PreviousViewController.h"
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
#import "NSString+URL.h"
#import "PostersViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MJPullGifHeader.h"

static NSString *ksimpleCell = @"simpleCell";
static NSString *kposterView = @"posterView";
static NSString *khead1View = @"head1View";
static NSString *khead2View = @"head2View";


@interface PreviousViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    UIView *ladyPoster;
    UIView *childPoster;
    NSMutableArray *childDataArray;
    NSMutableArray *ladyDataArray;
    NSMutableArray *posterDataArray;
    UIView *frontView;
    NSInteger childListNumber;
    NSInteger ladyListNumber;
    BOOL step1;
    BOOL step2;
    NSTimer *theTimer;
    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    BOOL _isFirst;
    BOOL isqiangGuang;
    NSString *offSheltTime;
    
    BOOL isHidden;
    CGFloat oldScrollViewTop;
    
    NSString *nextUrl;
    BOOL _update;
    
}

@property (nonatomic, retain) UICollectionView *myCollectionView;


@end

@implementation PreviousViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        
        _isFirst = NO;
    }
    
}



- (void)reload
{
    [self downloadData];
    
}

- (void)loadMore
{
     NSLog(@"lodeMore url = %@", nextUrl);
    if ([nextUrl isKindOfClass:[NSString class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

- (void)fetchedPromoteMorePageData:(NSData *)data{
//    _updating = NO;
    if (data == nil) {
        
        return;
    }
    
    NSError *error = nil;
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    nextUrl = [promoteDic objectForKey:@"next"];
    NSArray *results = [promoteDic objectForKey:@"results"];
    
    NSMutableArray *reloadNum = [NSMutableArray arrayWithCapacity:0];
    _update = YES;
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


- (void)stopFootRefresh{
    [self.myCollectionView.mj_footer endRefreshing];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    childDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ladyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    step1 = NO;
    step2 = NO;
    _isFirst = YES;
    isqiangGuang = NO;
    _update = YES;
    //  myTimeLabelString = @"剩余1天23小时23分59秒";
    
    [self createCollectionView];
    
    // [self downloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCurrentState) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myCollectionView.mj_header = header;
    [self.myCollectionView.mj_header beginRefreshing];
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    [footer setAutomaticallyHidden:YES];
//    self.myCollectionView.mj_footer = footer;

    
}

- (void)saveCurrentState{
    NSLog(@"enterBackground");
    
}
- (void)restoreCurrentState{
    NSLog(@"还原状态");
    if (self.navigationController.isNavigationBarHidden) {
        [self.delegate hiddenNavigation];
        
    } else{
        [self.delegate showNavigation];
    }
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
   
    NSString *string = nil;
    NSDate *todate;

    if ([offSheltTime class] == [NSNull class] || offSheltTime == nil) {
        NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
        [endTime setYear:year];
        [endTime setMonth:month];
        [endTime setDay:day];
        [endTime setHour:14];
        [endTime setMinute:0];
        [endTime setSecond:0];
        
        todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
        
        //用来得到具体的时差
        
       
    } else{
        NSMutableString *string = [NSMutableString stringWithString:offSheltTime];
        NSRange range = [string rangeOfString:@"T"];
        [string replaceCharactersInRange:range withString:@" "];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        todate = [dateformatter dateFromString:string];
    }
   
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ((long)[d day] == 0) {
        string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    }
    else{
        string = [NSString stringWithFormat:@"剩余%ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
        
    }
    
  //  NSLog(@"time = %@", string);
    childTimeLabel.text = string;
    ladyTimeLabel.text = string;
    
    if ([date compare:todate ] == NSOrderedDescending) {
        childTimeLabel.text = @"敬请期待明日上新";
        ladyTimeLabel.text = @"敬请期待明日上新";
        isqiangGuang = YES;
    }
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 20 - 33) collectionViewLayout:flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    [self.myCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    [self.myCollectionView registerClass:[PosterCollectionCell2 class] forCellWithReuseIdentifier:kposterView];
    self.myCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    
    [self.myCollectionView registerClass:[Head1View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead1View];
    [self.myCollectionView registerClass:[Head2View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myCollectionView];
}





- (void)downloadData{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/products/promote_previous_paging?page_size=10",Root_URL];
    
    
    [self downLoadWithURLString:kPREVIOUS_POSTERS_URL andSelector:@selector(fetchedPosterData:)];
    [self downLoadWithURLString:urlStr andSelector:@selector(fetchedPromotePageData:)];
}
- (void)fetchedPromotePageData:(NSData *)data{
    
    [childDataArray removeAllObjects];
    [ladyDataArray removeAllObjects];
    if (data == nil) {
        
        return;
    }
    _update = YES;
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
    
       theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    step2 = YES;
    if (step1 && step2) {
        step1 = NO;
        step2 = NO;
        [self.myCollectionView reloadData];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
        
    }
    
}







#pragma mark --今题推荐数据解析


- (void)fetchedPosterData:(NSData *)data{
    NSError *error;
    [posterDataArray removeAllObjects];
    
    if (data == nil) {
        return;
    }
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary *childDic = [[jsonDic objectForKey:@"chd_posters"] lastObject];
    PosterModel *childModel = [PosterModel new];
    childModel.imageURL = [childDic objectForKey:@"pic_link"];
    childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
    childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
    
    NSDictionary *ladyDic = [[jsonDic objectForKey:@"wem_posters"] lastObject];
    PosterModel *ladyModel = [PosterModel new];
    ladyModel.imageURL = [ladyDic objectForKey:@"pic_link"];
    ladyModel.firstName = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
    ladyModel.secondName = [[ladyDic objectForKey:@"subject"] objectAtIndex:1];
    [posterDataArray addObject:ladyModel];
    [posterDataArray addObject:childModel];
    
    step1 = YES;
    if (step1 && step2) {
        
        step1 = NO;
        step2 = NO;
        [self.myCollectionView reloadData];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
        
    }
    
    
}
- (void)fetchedPromoteData:(NSData *)data{
    NSError *error;
    [childDataArray removeAllObjects];
    [ladyDataArray removeAllObjects];
    if (data == nil) {
        // [frontView removeFromSuperview];
        return;
    }
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *ladyArray = [promoteDic objectForKey:@"female_list"];
    ladyListNumber = ladyArray.count;
    for (NSDictionary *ladyInfo in ladyArray) {
       // PromoteModel *model = [self fillModel:ladyInfo];
         PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        
        [ladyDataArray addObject:model];
        
    }
    
    
    
    
    
    NSArray *childArray = [promoteDic objectForKey:@"child_list"];
    childListNumber = childArray.count;
    
    for (NSDictionary *childInfo in childArray) {
     // PromoteModel *model = [self fillModel:childInfo];
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:childInfo];
        
        [childDataArray addObject:model];
        
    }
    if (childArray.count != 0) {
        PromoteModel *tempModel = [childDataArray objectAtIndex:0];
        offSheltTime = tempModel.offshelfTime;
    }
   
    
    //倒计时。。。。。。
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    

    
    
    
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
//    // model.picPath = [childInfo objectForKey:@"pic_path"];
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
//    model.productModel = [dic objectForKey:@"product_model"];
//    model.offshelfTime = [dic objectForKey:@"offshelf_time"];
//    offSheltTime = model.offshelfTime;
//    model.watermark_op = [dic objectForKey:@"watermark_op"];
//    if ([model.productModel class] == [NSNull class]) {
//         model.picPath = [dic objectForKey:@"head_img"];
//        model.productModel = nil;
//        return model;
//    }
//    
//
//    if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
//       
//        model.picPath = [dic objectForKey:@"head_img"];
//
//    } else{
//        if ([[model.productModel objectForKey:@"head_imgs"] count] != 0) {
//            model.picPath = [[model.productModel objectForKey:@"head_imgs"] objectAtIndex:0];
//            
//        }
//        model.name = [model.productModel objectForKey:@"name"];
//    }
//    
//    
//    
//    return model;
//    
//    
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
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
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
        return CGSizeMake(SCREENWIDTH, SCREENWIDTH*253/618);
        
    }
    return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2*8/6 + 60);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        
        PosterCollectionCell2 *cell = (PosterCollectionCell2 *)[collectionView dequeueReusableCellWithReuseIdentifier:kposterView forIndexPath:indexPath];
        
        if (posterDataArray.count != 0) {
            
            
            PosterModel *model = [posterDataArray objectAtIndex:indexPath.row];
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[[model.imageURL imagePostersCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderPosterImage.png"]];

            
           
        }
        
        return cell;
        
        
    }
    else if (indexPath.section == 2)
    {
        if (childDataArray.count != 0) {
            PromoteModel *model = [childDataArray objectAtIndex:indexPath.row];
            [cell fillData:model];

        }
        
        
        
        
    }
    
    else {
        
        if (ladyDataArray.count != 0) {
            PromoteModel *model = [ladyDataArray objectAtIndex:indexPath.row];
            [cell fillData:model];

            return cell;
        }
     
        
        
    }
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;
    if (indexPath.section == 0) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead1View forIndexPath:indexPath];
        return headerView;
    } else if (indexPath.section == 2){
        
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View forIndexPath:indexPath];
        headerView.nameLabel.text = @"萌娃专区";
        headerView.headView.layer.cornerRadius = 4;
        childTimeLabel = headerView.timeLabel;
        headerView.headImageView.image = [UIImage imageNamed:@"childIcon.png"];
        
        return headerView;
    } else if (indexPath.section == 1){
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View forIndexPath:indexPath];
        headerView.nameLabel.text = @"时尚女装";
        headerView.headView.layer.cornerRadius = 4;
        childTimeLabel = headerView.timeLabel;
        headerView.headImageView.image = [UIImage imageNamed:@"ladyIcon.png"];
        return headerView;
    }
    
    
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
    
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <240 && scrollView.contentOffset.y > -400) {
        return;
    }
    
   
    if (scrollView.contentSize.height - scrollView.contentOffset.y < 1500 && _update) {
        [self loadMore];
        _update = NO;
        
    }
    
    
    CGPoint point = scrollView.contentOffset;
    CGFloat temp = oldScrollViewTop - point.y;
    
    
    CGFloat marine = 5;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
            childVC.urlString = kLADY_LIST_URL;
            childVC.orderUrlString = kLADY_LIST_ORDER_URL;
            childVC.titleName = @"时尚女装";
            childVC.childClothing = NO;
            [self.navigationController pushViewController:childVC animated:YES];
            
        } else{
            PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
            childVC.urlString = kCHILD_LIST_URL;
            childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
            childVC.titleName = @"潮童装区";
            childVC.childClothing = YES;
            
            [self.navigationController pushViewController:childVC animated:YES];
            
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



@end

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
#import "PosterCollectionCell.h"
#import "PeopleCollectionCell.h"

#import "PromoteModel.h"
#import "PosterModel.h"
#import "ChildViewController.h"
#import "MJRefresh.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "AFNetworking.h"
#import "PostersViewController.h"
#import "CartViewController.h"
#import "EnterViewController.h"
#import "MMNavigationDelegate.h"

static NSString *ksimpleCell = @"simpleCell";
static NSString *kposterView = @"posterView";
static NSString *khead1View = @"head1View";
static NSString *khead2View = @"head2View";


@interface TodayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *childDataArray;
    NSMutableArray *ladyDataArray;
    NSMutableArray *posterDataArray;
    
    NSInteger childListNumber;
    NSInteger ladyListNumber;

    NSTimer *theTimer;

    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    BOOL _isFirst;
    BOOL step1;
    BOOL step2;
    BOOL _isDone;
}

@property (nonatomic, retain) UICollectionView *myCollectionView;

@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 
}

- (void)viewDidAppear:(BOOL)animated
{
    

    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        
        [self setupRefresh];
        self.myCollectionView.footerHidden=NO;
        self.myCollectionView.headerHidden=NO;
        [self.myCollectionView headerBeginRefreshing];
        _isFirst = NO;
    }
    
}

- (void)setupRefresh{
    [self.myCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_myCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    _myCollectionView.headerPullToRefreshText = NSLocalizedString(@"下拉可以刷新", nil);
    _myCollectionView.headerReleaseToRefreshText = NSLocalizedString (@"松开马上刷新",nil);
    _myCollectionView.headerRefreshingText = NSLocalizedString(@"正在帮你刷新中", nil);
    
    _myCollectionView.footerPullToRefreshText = NSLocalizedString(@"上拉可以加载更多数据", nil);
    _myCollectionView.footerReleaseToRefreshText = NSLocalizedString(@"松开马上加载更多数据", nil);
    _myCollectionView.footerRefreshingText = NSLocalizedString(@"正在帮你加载中", nil);
    
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reload];
        sleep(1.5);
        [_myCollectionView headerEndRefreshing];
        _isDone = YES;
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMore];
        sleep(1.5);
        [_myCollectionView footerEndRefreshing];
        
    });
}

- (void)reload
{
    NSLog(@"reload");
    
    [self downloadData123];
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 数据初始化。。。。
    childDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ladyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    step1 = NO;
    step2 = NO;
    _isFirst = YES;
    _isDone = NO;
    [self createCollectionView];
 
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
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
        string = [NSString stringWithFormat:@"剩余%02ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
    
    }
    childTimeLabel.text = string;
    ladyTimeLabel.text = string;
    
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 20 - 33) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.backgroundColor = [UIColor colorWithR:249 G:249 B:249 alpha:1];
    [self.myCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    [self.myCollectionView registerClass:[PosterCollectionCell class] forCellWithReuseIdentifier:kposterView];
    [self.myCollectionView registerClass:[Head1View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead1View];
    [self.myCollectionView registerClass:[Head2View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View];
    
    [self.view addSubview:self.myCollectionView];
}





- (void)downloadData123{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_PROMOTE_URL]];
        NSLog(@"%@", kTODAY_PROMOTE_URL);
        [self performSelectorOnMainThread:@selector(fetchedPromoteData:)withObject:data waitUntilDone:YES];
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_POSTERS_URL]];
        NSLog(@"%@", kTODAY_POSTERS_URL);
        [self performSelectorOnMainThread:@selector(fetchedPosterData:)withObject:data waitUntilDone:YES];
        
    });
    
}





#pragma mark --今题推荐数据解析


- (void)fetchedPosterData:(NSData *)data{
    NSError *error;
   NSLog(@"data = %@", data);
    [posterDataArray removeAllObjects];
    if (data == nil) {

        
        return;
    }
   NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   NSLog(@"poster data : %@", jsonDic);
    
    NSDictionary *childDic = [[jsonDic objectForKey:@"chd_posters"] lastObject];
    NSLog(@"childDic = %@", childDic);
    if (childDic == nil) {
        NSLog(@"海报为空");
        return;
    }
    NSLog(@"%@", childDic);
    PosterModel *childModel = [PosterModel new];
    childModel.imageURL = [childDic objectForKey:@"pic_link"];
    childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
    childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
    
    NSDictionary *ladyDic = [[jsonDic objectForKey:@"wem_posters"] lastObject];
    NSLog(@"%@", ladyDic);
    PosterModel *ladyModel = [PosterModel new];
    ladyModel.imageURL = [ladyDic objectForKey:@"pic_link"];
    ladyModel.firstName = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
    ladyModel.secondName = [[ladyDic objectForKey:@"subject"] objectAtIndex:1];
    [posterDataArray addObject:ladyModel];
    [posterDataArray addObject:childModel];

  //  NSLog(@"%@", posterDataArray);
    step1 = YES;
    if (step1 && step2) {
        
        step1 = NO;
        step2 = NO;
        [self.myCollectionView reloadData];
        
        NSLog(@"poster finish");

    }
    
    
}
- (void)fetchedPromoteData:(NSData *)data{
    NSError *error;
    // NSLog(@"data = %@", data);
    [childDataArray removeAllObjects];
    [ladyDataArray removeAllObjects];
    if (data == nil) {

        return;
    }
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      NSLog(@"promote data = %@", promoteDic);
    NSArray *ladyArray = [promoteDic objectForKey:@"female_list"];
   
    ladyListNumber = ladyArray.count;
    if (ladyListNumber == 0) {
        return;
    }
   
    NSLog(@"%ld", (long)ladyArray.count);
    for (NSDictionary *ladyInfo in ladyArray) {
        PromoteModel *model = [self fillModel:ladyInfo];
        
        
        [ladyDataArray addObject:model];
        
    }
   NSLog(@"ladyDataArray = %@", ladyDataArray);
    
    PromoteModel *firstModel = [ladyDataArray objectAtIndex:0];
    NSString *string = firstModel.picPath;
    
    NSLog(@"first image url = %@", string);
   // UIImage *image = [UIImage imagewithURLString:string];
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    
    [defualt setObject:string forKey:@"imageUrlString"];
    [defualt synchronize];
    
    
    
    
    
    NSArray *childArray = [promoteDic objectForKey:@"child_list"];
    if (childArray.count == 0) {
        NSLog(@"列表为空");
        return;
    }
    if (![childArray isKindOfClass:[NSArray class]]) {
        NSLog(@"数据失败");
        return;
    }
     childListNumber = childArray.count;
   NSLog(@"%ld", (long)childArray.count);
   
    
    for (NSDictionary *childInfo in childArray) {
        PromoteModel *model = [self fillModel:childInfo];
        
        
        [childDataArray addObject:model];
        
    }
    NSLog(@"childDataArray = %@", childDataArray);
    
    step2 = YES;
    
    if (step1 && step2) {
        step1 = NO;
        step2 = NO;
        [self.myCollectionView reloadData];
        NSLog(@"promote finish");

    }
    
    
}



- (PromoteModel *)fillModel:(NSDictionary *)dic{
    PromoteModel *model = [PromoteModel new];
    model.name = [dic objectForKey:@"name"];
    
    // model.picPath = [childInfo objectForKey:@"pic_path"];
    model.Url = [dic objectForKey:@"url"];
    model.agentPrice = [dic objectForKey:@"agent_price"];
    model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
    model.outerID = [dic objectForKey:@"outer_id"];
    model.isNewgood = [dic objectForKey:@"is_newgood"];
    model.isSaleopen = [dic objectForKey:@"is_saleopen"];
    model.isSaleout = [dic objectForKey:@"is_saleout"];
    model.ID = [dic objectForKey:@"id"];
    model.category = [dic objectForKey:@"category"];
    model.remainNum = [dic objectForKey:@"remain_num"];
    model.saleTime = [dic objectForKey:@"sale_time"];
    model.wareBy = [dic objectForKey:@"ware_by"];
    if ([[dic objectForKey:@"product_model"]class] ==[NSNull class]) {
        model.productModel = nil;
          model.picPath = [dic objectForKey:@"head_img"];
        model.productModel = nil;
        NSLog(@"product_model==null");
        
    } else{
        model.productModel = [dic objectForKey:@"product_model"];
        
        
        if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
             NSLog(@"没有集合页");
            model.picPath = [dic objectForKey:@"head_img"];
            
        } else{
            if ([[model.productModel objectForKey:@"head_imgs"] count] != 0) {
                model.picPath = [[model.productModel objectForKey:@"head_imgs"] objectAtIndex:0];
                
            }
            model.name = [model.productModel objectForKey:@"name"];
            
        }
        
    }
    
    
   
    return model;

    
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


#pragma mark --UICollectionViewDelegate--

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return ladyDataArray.count;
        //return 4;
       // return childDataArray.count;
    } else if (section == 2){
        return childDataArray.count;
        
       // return 4;
        //return ladyDataArray.count;
    }
    return 0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, SCREENWIDTH*253/618+24);
        
    }
      NSLog(@"%f,%f", (SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 + 52);
    return CGSizeMake((SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 + 52);
  
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREENWIDTH, 0);
        
    } else if (section == 1){
        return CGSizeMake(SCREENWIDTH, 40);
    }
    else if (section == 2){
        return CGSizeMake(SCREENWIDTH, 40);
    }
    return CGSizeZero;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
       
      
            PosterCollectionCell *cell = (PosterCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kposterView forIndexPath:indexPath];
        
        if (posterDataArray.count != 0) {
            
        
            PosterModel *model = [posterDataArray objectAtIndex:indexPath.row];
           [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//               NSLog(@"error = %@", error);
//               NSLog(@"errorUserinfo = %@", error.userInfo);
//               NSLog(@"errordescription = %@", error.description);
//               NSLog(@"image = %@", image);
//               NSLog(@"url = %@", imageURL);
//               NSLog(@"cachetype = %d", (int)cacheType);
         }];
      //     cell.myImageView.image = [UIImage imagewithURLString:model.imageURL];
            cell.titleLabel.text = model.firstName;
            cell.subjectLabel.text = model.secondName;
           
        }
        return cell;
       

        
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
        headerView.nameLabel.text = @"潮童专区";
        childTimeLabel = headerView.timeLabel;
        headerView.headImageView.image = [UIImage imageNamed:@"childImage.png"];
        NSLog(@"asdfasdfasdfasdfasdf%@",[UIImage imageNamed:@"childImage.png"]);
        return headerView;
    } else if (indexPath.section == 1){
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:khead2View forIndexPath:indexPath];
        headerView.nameLabel.text = @"时尚女装";
        childTimeLabel = headerView.timeLabel;

        headerView.headImageView.image = [UIImage imageNamed:@"ladyImage.png"];
        return headerView;
    }
    
    
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
   
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    
//    NSLog(@"%f", point.y );
    
    if (point.y > 260) {
        
        if (self.delegate && [self.delegate performSelector:@selector(hiddenNavigation)]) {
            [self.delegate hiddenNavigation];
        }
        //self.navigationController.navigationBarHidden = YES;
        
        
    } else  if (point.y < - 66){
        //self.navigationController.navigationBarHidden = NO;
        
        if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
            [self.delegate showNavigation];
        }
 
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld",(long)indexPath.section, (long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
            childVC.urlString = kLADY_LIST_URL;
            childVC.orderUrlString = kLADY_LIST_ORDER_URL;
            childVC.titleName = @"时尚女装";
            
            [self.navigationController pushViewController:childVC animated:YES];
            

            
            
            
            
        } else{
            PostersViewController *childVC = [[PostersViewController alloc] initWithNibName:@"PostersViewController" bundle:nil];
            childVC.urlString = kCHILD_LIST_URL;
            childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
            childVC.titleName = @"潮童装区";
            
            [self.navigationController pushViewController:childVC animated:YES];
            
        }
        
    } else if (indexPath.section == 2){
        PromoteModel *model = [childDataArray objectAtIndex:indexPath.row];

        if (model.productModel == nil) {
            NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/", Root_URL];
            [urlString appendString:[NSString stringWithFormat:@"%@", model.ID]];
            [urlString appendString:@"/details.json"];
            MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailVC.urlString = urlString;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/", Root_URL];
                [urlString appendString:[NSString stringWithFormat:@"%@", model.ID]];
                [urlString appendString:@"/details.json"];
                MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailVC.urlString = urlString;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else{
                NSString *modelID = [model.productModel objectForKey:@"id"];
                NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/modellist/", Root_URL];
                [urlString appendString:[NSString stringWithFormat:@"%@.json", modelID]];
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = urlString;
                [self.navigationController pushViewController:collectionVC animated:YES];
                
            }
        }
        
        
    } else if (indexPath.section == 1){
        PromoteModel *model = [ladyDataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/", Root_URL];
            [urlString appendString:[NSString stringWithFormat:@"%@", model.ID]];
            [urlString appendString:@"/details.json"];
            MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailVC.urlString = urlString;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/", Root_URL];
                [urlString appendString:[NSString stringWithFormat:@"%@", model.ID]];
                [urlString appendString:@"/details.json"];
                MMDetailsViewController *detailVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailVC.urlString = urlString;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else{
                NSString *modelID = [model.productModel objectForKey:@"id"];
                NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/rest/v1/products/modellist/", Root_URL];
                [urlString appendString:[NSString stringWithFormat:@"%@.json", modelID]];
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = urlString;
                [self.navigationController pushViewController:collectionVC animated:YES];
                
            }
        }
    }
}







@end

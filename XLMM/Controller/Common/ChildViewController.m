//
//  ChildViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ChildViewController.h"
#import "PeopleCollectionCell.h"
#import "MMClass.h"
#import "CollectionModel.h"
#import "DetailsModel.h"
#import "CartViewController.h"
#import "PromoteModel.h"
#import "MJPullGifHeader.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "MJRefresh.h"
#import "UIViewController+NavigationBar.h"
#import "SVProgressHUD.h"

static NSString * ksimpleCell = @"simpleCell";

@interface ChildViewController (){
    
    NSMutableArray *_ModelListArray;
    UIActivityIndicatorView *activityIndicator;
    BOOL isOrder;
    NSInteger goodsCount;
    UILabel *countLabel;
    BOOL _isFirst;
    CGFloat oldScrollViewTop;
    
    BOOL _isupdate;
    NSString *nextUrl;
    CGFloat _contentY;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;

@end

@implementation ChildViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 

    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
   return self;
}

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
    }
//     else {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
//            [self.childCollectionView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }
    
    
    
}

- (void)fetchedPromoteMorePageData:(NSData *)data{
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
    NSError *error;
    if (data == nil) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    nextUrl = [json objectForKey:@"next"];
    _isupdate = YES;
    if (array.count == 0) {
        return;
    }
    NSMutableArray *numArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:_dataArray.count
                                                inSection:0];
        [_dataArray addObject:model];
        [numArray addObject:index];
    }
    [self.childCollectionView insertItemsAtIndexPaths:numArray];
    [numArray removeAllObjects];
    numArray = nil;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self.tuijianButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
    isOrder = NO;
    _isFirst = YES;
    _isupdate = YES;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];

    [self.view addSubview:[[UIView alloc] init]];
    [self setLayout];
    self.topdistant.constant = 0;
    self.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    
  //  self.childCollectionView.bounces = NO;
    [self.childCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    
   
    self.childCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self.view addSubview:self.containerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCurrentState) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.childCollectionView.mj_header = header;
    [self.childCollectionView.mj_header beginRefreshing];

 
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

- (void)setLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 15)/2, (SCREENWIDTH - 15)/2*7/6 + 60)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    [self.childCollectionView setCollectionViewLayout:flowLayout];
    self.childCollectionView.showsVerticalScrollIndicator = NO;
}

- (void)downloadData{
    if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
        [self.delegate showNavigation];
    }
    
    [self downLoadWithURLString:self.urlString andSelector:@selector(fatchedChildListData:)];
}

- (void)stopRefresh{
    [self.childCollectionView.mj_header endRefreshing];
}



- (void)fatchedChildListData:(NSData *)responseData{
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (json == nil) {
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    nextUrl = [json objectForKey:@"next"];
    _isupdate = YES;
    if (array.count == 0) {
        return;
    }
    [self.dataArray removeAllObjects];
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        [_dataArray addObject:model];
    }
    [self.childCollectionView reloadData];
}

#pragma mark  -----CollectionViewDelete----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isOrder) {
       
        return self.orderDataArray.count;
        
    }else{
        
        return self.dataArray.count;
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 * 8 / 6+ 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (isOrder) {
        if (_orderDataArray.count > indexPath.row) {
            PromoteModel *model = [_orderDataArray objectAtIndex:indexPath.row];
            
            [cell fillData:model];
        }
        
       
    }else{
        if (_dataArray.count > indexPath.row) {
            PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
            
            [cell fillData:model];
        }
       
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  if (_dataArray.count == 0) {
        return;
    }
    if (isOrder) {
        PromoteModel *model = [_orderDataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:self.isChildClothing];
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:self.isChildClothing];
                [self.navigationController pushViewController:detailsVC animated:YES];
            } else {
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[model.productModel objectForKey:@"id"] isChild:self.isChildClothing];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
        }
    } else {
        
        PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        if (model.productModel == nil) {
         
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:self.isChildClothing];
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:self.isChildClothing];
                [self.navigationController pushViewController:detailsVC animated:YES];
                
                
            } else {
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[model.productModel objectForKey:@"id"] isChild:self.isChildClothing];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _contentY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y <240 && scrollView.contentOffset.y > -400) {
//        return;
//    }
//    CGPoint point = scrollView.contentOffset;
//    CGFloat temp = oldScrollViewTop - point.y;
//    
    if (scrollView.contentSize.height - scrollView.contentOffset.y < 1200 && _isupdate) {
        if (isOrder == NO) {
            [self loadMore];
            _isupdate = NO;
        }
     
        
    }
//
//    CGFloat marine = 5;
//    if (temp > marine) {
//        if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
//            [self.delegate showNavigation];
//        }
//        
//        
//    } else if (temp < -5){
//        if (self.delegate && [self.delegate performSelector:@selector(hiddenNavigation)]) {
//            [self.delegate hiddenNavigation];
//        }
//    }
//    if (temp > marine ) {
//        oldScrollViewTop = point.y;
//        return;
//        
//    }
//    if (temp < 0 - marine) {
//        oldScrollViewTop = point.y;
//    }
    if (scrollView.isDragging) {
        if ((scrollView.contentOffset.y - _contentY) > 5.0f) {
            //隐藏
            if (self.delegate && [self.delegate performSelector:@selector(hiddenNavigation)]) {
                [self.delegate hiddenNavigation];
            }
        }else if((_contentY - scrollView.contentOffset.y) > 5.0f) {
            //显示
            if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
                [self.delegate showNavigation];
            }
        }
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
   
        return UIEdgeInsetsMake(0, 5, 50, 5);
  
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}




- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        isOrder = NO;
        [SVProgressHUD dismiss];
        
        //[activityIndicator removeFromSuperview];
        //activityIndicator = nil;
        [self.childCollectionView reloadData];
        [self.jiageButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.tuijianButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        
        
        
    } else if (sender.tag == 2){
        isOrder = YES;
        [self.tuijianButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.jiageButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        
        [self downloadOrderData];
//        if (activityIndicator == nil) {
//            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        }
//        
//        activityIndicator.backgroundColor = [UIColor clearColor];
//        [activityIndicator startAnimating];
//        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2 - 80);
//        [self.childCollectionView addSubview:activityIndicator];
        [SVProgressHUD show];
        
        
    }

}

- (void)downloadOrderData{
    [self downLoadWithURLString:self.orderUrlString andSelector:@selector(fatchedOrderLadyListData:)];
}
 
- (void)fatchedOrderLadyListData:(NSData *)responseData{
    NSError *error;
    self.orderDataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [[PromoteModel alloc] initWithDictionary:ladyInfo];
        [self.orderDataArray addObject:model];

    }
     //[activityIndicator removeFromSuperview];
    //activityIndicator = nil;
    
    [SVProgressHUD dismiss];
    [self.childCollectionView reloadData];
}






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

@end

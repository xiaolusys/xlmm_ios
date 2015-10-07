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
#import "PurchaseViewController.h"
#import "CollectionModel.h"
#import "DetailsModel.h"
#import "PersonCenterViewController.h"
#import "EmptyCartViewController.h"
#import "EnterViewController.h"
#import "CartViewController.h"
#import "PromoteModel.h"

#import "MMDetailsViewController.h"
#import "MMCollectionController.h"

#import "MJRefresh.h"

static NSString * ksimpleCell = @"simpleCell";

@interface ChildViewController (){
    
    NSMutableArray *_ModelListArray;
    UIActivityIndicatorView *activityIndicator;
    BOOL isOrder;
    NSInteger goodsCount;
    UILabel *countLabel;
    BOOL _isFirst;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;

@end

@implementation ChildViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        
        [self setupRefresh];
        self.childCollectionView.footerHidden=NO;
        self.childCollectionView.headerHidden=NO;
        [self.childCollectionView headerBeginRefreshing];
        _isFirst = NO;
    }
    
}

- (void)setupRefresh{
    
    
    
    [self.childCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_childCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    _childCollectionView.headerPullToRefreshText = NSLocalizedString(@"下拉可以刷新", nil);
    _childCollectionView.headerReleaseToRefreshText = NSLocalizedString (@"松开马上刷新",nil);
    _childCollectionView.headerRefreshingText = NSLocalizedString(@"正在帮你刷新中", nil);
    
    _childCollectionView.footerPullToRefreshText = NSLocalizedString(@"上拉可以加载更多数据", nil);
    _childCollectionView.footerReleaseToRefreshText = NSLocalizedString(@"松开马上加载更多数据", nil);
    _childCollectionView.footerRefreshingText = NSLocalizedString(@"正在帮你加载中", nil);
    
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reload];
        sleep(1.5);
        [_childCollectionView headerEndRefreshing];
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMore];
        sleep(1.5);
        [_childCollectionView footerEndRefreshing];
        
    });
}

- (void)reload
{
    NSLog(@"reload");
    [self downloadData];
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    // Do any additional setup after loading the view from its nib.
    isOrder = NO;
    _isFirst = YES;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];

    [self.view addSubview:[[UIView alloc] init]];
    [self setLayout];
    self.topdistant.constant = 64;
    NSLog(@"%ld",(long) self.topdistant.constant);
    self.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    
  //  self.childCollectionView.bounces = NO;
    [self.childCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    
   
   // [self downloadData];
   
 
}

- (void)setLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 4)/2, (SCREENWIDTH - 10)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.childCollectionView setCollectionViewLayout:flowLayout];
    self.childCollectionView.showsVerticalScrollIndicator = NO;
}


- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

- (void)downloadData{
    [self downLoadWithURLString:self.urlString andSelector:@selector(fatchedChildListData:)];
    
    NSLog(@"url = %@", self.urlString);
}

- (void)fatchedChildListData:(NSData *)responseData{
    NSError *error;
    //NSLog(@"responsedata = %@", responseData);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"数据解析失败");
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"数据解析失败");
        return;
    }
    
    [self.dataArray removeAllObjects];
    
    
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [self fillModel:ladyInfo];
        
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (isOrder) {
        PromoteModel *model = [_orderDataArray objectAtIndex:indexPath.row];
      
        [cell fillData:model];
       
    }else{
        PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        [cell fillData:model];
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
            NSLog(@"没有集合页面");
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailsVC.urlString = string;
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSLog(@"没有集合页面");
                NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailsVC.urlString = string;
                [self.navigationController pushViewController:detailsVC animated:YES];
                
            } else {
                NSString * string = [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json", Root_URL, [model.productModel objectForKey:@"id"]];
                NSLog(@"stringURL -> = %@", string);
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = string;
                [self.navigationController pushViewController:collectionVC animated:YES];
                
                
            }

        
        }
    } else {
        
        PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailsVC.urlString = string;
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSLog(@"没有集合页面");
                NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailsVC.urlString = string;
                [self.navigationController pushViewController:detailsVC animated:YES];
                
                
            } else {
                NSString * string = [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json", Root_URL, [model.productModel objectForKey:@"id"]];
                NSLog(@"stringURL -> = %@", string);
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = string;
                [self.navigationController pushViewController:collectionVC animated:YES];
                
                
                
            }
     
        }
    }
    
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark ----btnClicked:----

- (void)login:(UIButton *)button{
    NSLog(@"登录");
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:kIsLogin];
    if (islogin) {
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:personVC animated:YES];
        NSLog(@"您已经登录，可以购买");
    } else{
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:personVC animated:YES];
        NSLog(@"您现在是游客身份，请先登录");
    }

    
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        NSLog(@"推荐排序");
        isOrder = NO;
        [self.childCollectionView reloadData];
    } else if (sender.tag == 2){
        NSLog(@"价格排序");
        isOrder = YES;
        
        [self downloadOrderData];
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.backgroundColor = [UIColor clearColor];
        [activityIndicator startAnimating];
        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2 - 80);
        [self.childCollectionView addSubview:activityIndicator];
        
        [self.childCollectionView reloadData];
    }

}

- (void)downloadOrderData{
    [self downLoadWithURLString:self.orderUrlString andSelector:@selector(fatchedOrderLadyListData:)];
}
 
- (void)fatchedOrderLadyListData:(NSData *)responseData{
    NSError *error;
    self.orderDataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
   // MMLOG(json);
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [self fillModel:ladyInfo];
        
        
        [self.orderDataArray addObject:model];

    }
     [activityIndicator removeFromSuperview];
    [self.childCollectionView reloadData];
}

- (PromoteModel *)fillModel:(NSDictionary *)dic{
    PromoteModel *model = [PromoteModel new];
    model.ID = [dic objectForKey:@"id"];
    
    model.name = [dic objectForKey:@"name"];
    model.Url = [dic objectForKey:@"url"];
    model.agentPrice = [dic objectForKey:@"agent_price"];
    model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
    model.outerID = [dic objectForKey:@"outer_id"];
    model.isSaleopen = [dic objectForKey:@"is_saleopen"];
    model.isSaleout = [dic objectForKey:@"is_saleout"];
    model.category = [dic objectForKey:@"category"];
    model.remainNum = [dic objectForKey:@"remain_num"];
    model.saleTime = [dic objectForKey:@"sale_time"];
    model.wareBy = [dic objectForKey:@"ware_by"];
     model.productModel = [dic objectForKey:@"product_model"];
    
    if ([model.productModel class] == [NSNull class]) {
        model.picPath = [dic objectForKey:@"head_img"];
        model.productModel = nil;
        NSLog(@"productModel is null.");
        return model;
    }
    
    if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
        //  NSLog(@"没有集合页");
       
        model.picPath = [dic objectForKey:@"head_img"];
    } else{
        model.picPath = [[model.productModel objectForKey:@"head_imgs"] objectAtIndex:0];
        model.name = [model.productModel objectForKey:@"name"];
        //  NSLog(@"----集合页----");
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

@end

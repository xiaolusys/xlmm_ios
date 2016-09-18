//
//  ChildViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ChildViewController.h"
#import "JMRootgoodsCell.h"
#import "MMClass.h"
#import "DetailsModel.h"
#import "CartViewController.h"
#import "MJPullGifHeader.h"
#import "MMDetailsViewController.h"
#import "XlmmMall.h"
#import "WebViewController.h"
#import "JMGoodsDetailController.h"
#import "JMCategoryListController.h"
#import "JMRootGoodsModel.h"
#import "JMRootGoodsModel.h"

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
    
    NSMutableDictionary *_childDic;
    BOOL isLoading; //网络请求时置为true，用于网络还未应答时不能切换推荐和价格查询条件控制
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;
@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong) NSMutableArray *childArray;
@property (nonatomic, strong) NSMutableArray *womenArray;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation ChildViewController

- (NSMutableArray *)childArray {
    if (_childArray == nil) {
        _childArray = [NSMutableArray array];
    }
    return _childArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger )type{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark  -----init----
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        _isFirst = NO;
    }

}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.childCollectionView.mj_header = header;
}
- (void)refreshView {
    _isPullDown = YES;
    [self.childCollectionView.mj_footer resetNoMoreData];
    [self reloadGoods];
}

- (void)createPullFooterRefresh {
    kWeakSelf
    self.childCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.childCollectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.childCollectionView.mj_footer endRefreshing];
    }
}

- (void)reloadGoods
{
    [self.childCollectionView.mj_footer resetNoMoreData];
    NSLog(@"CHILD vc reload");
    if(isOrder){
        [self downloadOrderData];
    }
    else{
        [self downloadData];
    }
}

- (void)loadMore {
    
    NSLog(@"lodeMore url = %@", nextUrl);
    if ([nextUrl isKindOfClass:[NSNull class]] || nextUrl == nil || [nextUrl isEqual:@""]) {
        [self endRefresh];
        [self.childCollectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    isLoading = true;
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:nextUrl WithParaments:nil WithSuccess:^(id responseObject) {
//        [self stopFooterRefresh];
        if (!responseObject)return ;
        [self fetchedMorePageData:responseObject];
        [self endRefresh];
        isLoading = false;
    } WithFail:^(NSError *error) {
        [self endRefresh];
        isLoading = false;
    } Progress:^(float progress) {
        
    }];
    
}

- (void)fetchedMorePageData:(NSDictionary *)data{
    NSLog(@"fetchedMorePageData");
    NSDictionary *json =data;
    if (json == nil) {
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    nextUrl = [json objectForKey:@"next"];
    
    if (array.count == 0) {
        return;
    }
    NSMutableArray *numArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *ladyInfo in array) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:ladyInfo];
        NSIndexPath *index ;
        if(isOrder){
             index = [NSIndexPath indexPathForRow:_orderDataArray.count inSection:0];
            [_orderDataArray addObject:model];
        }
        else{
             index = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
            [_dataArray addObject:model];
        }
        [numArray addObject:index];
    }

    
    if((numArray != nil) && (numArray.count > 0)){
        @try{
            [self.childCollectionView insertItemsAtIndexPaths:numArray];
            [numArray removeAllObjects];
            numArray = nil;
        }
        @catch(NSException *except)
        {
            NSLog(@"DEBUG: childvc failure to batch update.  %@", except.description);
        }
    }
    
    _isupdate = YES;
}




- (void)viewDidLoad {
    [super viewDidLoad];
//    [self itemDataSource];
//    [self craeteRight];
    isOrder = NO;
    _isFirst = YES;
    _isupdate = YES;
    isLoading = NO;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.orderDataArray = [[NSMutableArray alloc] init];
    [self.view addSubview:[[UIView alloc] init]];
    [self setLayout];
    self.topdistant.constant = 64;
    self.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    [self createNavigationBarWithTitle:self.titleString selector:@selector(backClicked:)];
  //  self.childCollectionView.bounces = NO;
    [self.childCollectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:ksimpleCell];
    self.childCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self.view addSubview:self.containerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCurrentState) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadGoods)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.childCollectionView.mj_header = header;
//    //添加上拉加载
//    self.childCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        //此处用的是在scrollview里面画到底部前自动刷新了，此处不做处理，只是显示一个提示而已
//    }];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    [self.childCollectionView.mj_header beginRefreshing];
//    [self reloadGoods];
    NSLog(@"Child vc viewDidLoad end");
    [self createButton];
    
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

- (void)stopHeaderRefresh{
    [self.childCollectionView.mj_header endRefreshing];
}

- (void)stopFooterRefresh{
    [self.childCollectionView.mj_footer endRefreshing];
}

- (void)downloadData{
//    if (self.delegate && [self.delegate performSelector:@selector(showNavigation)]) {
//        [self.delegate showNavigation];
//    }
    
    //[self downLoadWithURLString:self.urlString andSelector:@selector(fatchedChildListData:)];
//    [SVProgressHUD show];
    isLoading = true;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,self.cid];
    
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//        [self stopHeaderRefresh];
//        [SVProgressHUD dismiss];
        if (!responseObject)return ;
        [self fatchedSuggestListData:responseObject];
        [self endRefresh];
        isLoading = false;
    } WithFail:^(NSError *error) {
//        [SVProgressHUD dismiss];
        [self endRefresh];
        isLoading = false;
    } Progress:^(float progress) {
        
    }];
}


- (void)fatchedSuggestListData:(NSDictionary *)responseData{
    NSLog(@"fatchedSuggestListData");

    NSDictionary *json = responseData;
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
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:ladyInfo];
        [_dataArray addObject:model];
    }
    NSLog(@"_dataArray count %lu",(unsigned long)_dataArray.count);
    [self.childCollectionView reloadData];
}

- (void)downloadOrderData{
    isLoading = true;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?order_by=price&cid=%@&page=1&page_size=10",Root_URL,self.cid];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//        [self stopHeaderRefresh];
        if (!responseObject)return ;
        [self fatchedOrderListData:responseObject];
        [self endRefresh];
        isLoading = false;
    } WithFail:^(NSError *error) {
        [self endRefresh];
        isLoading = false;
    } Progress:^(float progress) {
        
    }];
}

- (void)fatchedOrderListData:(NSDictionary *)responseData{
    NSLog(@"fatchedOrderListData");

    NSDictionary *json = responseData;
    if (json == nil) {
        return;
    }
    
    _isupdate = YES;
    
    NSArray *array = [json objectForKey:@"results"];
    nextUrl = [json objectForKey:@"next"];
    [self.orderDataArray removeAllObjects];
    for (NSDictionary *ladyInfo in array) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:ladyInfo];
        [self.orderDataArray addObject:model];
        
    }
    [self.childCollectionView reloadData];
}




- (void)createNavigationBarWithTitle:(NSString *)title selector:(SEL)aSelector{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image2.png"]];
    imageView.frame = CGRectMake(0, 14, 16, 16);
    [button addSubview:imageView];
    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark  -----CollectionViewDelegate----
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
    JMRootgoodsCell *cell = (JMRootgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (isOrder) {
        if (_orderDataArray.count > indexPath.row) {
            JMRootGoodsModel *model = [_orderDataArray objectAtIndex:indexPath.row];
            [cell fillData:model];
        }
    }else{
        if (_dataArray.count > indexPath.row) {
            JMRootGoodsModel *model = [_dataArray objectAtIndex:indexPath.row];
            [cell fillData:model];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    _childDic = [NSMutableDictionary dictionary];

    JMRootGoodsModel *model = nil;
    if (isOrder) {
        if (_orderDataArray.count == 0) {
            return;
        }
        model = [_orderDataArray objectAtIndex:indexPath.row];

    } else {
        if (_dataArray.count == 0) {
            return;
        }
        model = [_dataArray objectAtIndex:indexPath.row];
    }
    
    _childDic = model.mj_keyValues;
    [_childDic setValue:model.web_url forKey:@"web_url"];
    [_childDic setValue:@"ProductDetail" forKey:@"type_title"];
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    
    detailVC.goodsID = model.goodsID;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _contentY = scrollView.contentOffset.y;
    [UIView animateWithDuration:0.5 animations:^{
        self.topButton.hidden = NO;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height - scrollView.contentOffset.y < 2 * SCREENHEIGHT && _isupdate) {
            [self loadMore];
            _isupdate = NO;
    }
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
    NSLog(@"btnClicked %ld", (long)self.childCollectionView.visibleCells.count );
    if(isLoading){
        NSLog(@"isloading data,not change button.");
        return;
    }
    
    if(self.childCollectionView.visibleCells.count > 0){
        NSIndexPath *bottomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
        [self.childCollectionView scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    
    self.childCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //此处用的是在scrollview里面画到底部前自动刷新了，此处不做处理，只是显示一个提示而已
    }];
    
    if (sender.tag == 1) {
        isOrder = NO;
        [self reloadGoods];
        //[activityIndicator removeFromSuperview];
        //activityIndicator = nil;
//        [self.childCollectionView reloadData];
        [self.jiageButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.tuijianButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        
//        [self.childCollectionView.mj_header beginRefreshing];
//        [self.childCollectionView reloadData];
        
    } else if (sender.tag == 2){
        isOrder = YES;
        [self reloadGoods];
//        [self.childCollectionView.mj_header beginRefreshing];
//        if(self.orderDataArray.count > 0){
//           [self.childCollectionView reloadData];
//        }
//        else{
//            [self downloadOrderData];
//        }
        [self.tuijianButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.jiageButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        
    }

}



#pragma mark -- 添加返回顶部按钮

- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
//    self.topButton.frame = CGRectMake(SCREENWIDTH - 70, SCREENHEIGHT - 70, 50, 50);
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.childCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    // Dispose of any resources that can be recreated.
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)itemDataSource {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    //==JsonObject
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *dic in arr) {
        if ([dic[@"cid"] integerValue] == 1) {
            // 童装
            self.childArray = dic[@"childs"];
        }else if ([dic[@"cid"] integerValue] == 2) {
            // 女装
            self.womenArray = dic[@"childs"];
        }else {}
        
    }
    
    
}
- (void)craeteRight {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightClicked:(UIButton *)button {
    JMCategoryListController *catoryVC = [[JMCategoryListController alloc] init];
    if(self.childClothing) {
        catoryVC.titleString = @"童装专区";
        catoryVC.dataSource = self.childArray;
    }else {
        catoryVC.titleString = @"女装专区";
        catoryVC.dataSource = self.womenArray;
    }
    [self.navigationController pushViewController:catoryVC animated:YES];
}


@end






































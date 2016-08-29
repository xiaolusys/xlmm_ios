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
#import "CollectionModel.h"

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
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;
@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong) NSMutableArray *childArray;
@property (nonatomic, strong) NSMutableArray *womenArray;


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
//    if(TYPE_JUMP_CHILD == type){
//        
//        self.urlString = kCHILD_LIST_URL;
//        self.orderUrlString = kCHILD_LIST_ORDER_URL;
//        self.childClothing = YES;
//
//    }
//    else{
//        
//        self.urlString = kLADY_LIST_URL;
//        self.orderUrlString = kLADY_LIST_ORDER_URL;
//        self.childClothing = NO;
//    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark  -----init----
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    if(self.childClothing){
//        [MobClick beginLogPageView:@"child"];
//    }
//    else{
//        [MobClick beginLogPageView:@"women"];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
//    if(self.childClothing){
//        [MobClick endLogPageView:@"child"];
//    }
//    else{
//        [MobClick endLogPageView:@"women"];
//    }
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        _isFirst = NO;
    }

}



- (void)reloadGoods
{
    NSLog(@"CHILD vc reload");
    if(isOrder){
        [self downloadOrderData];
    }
    else{
        [self downloadData];
    }
}

- (void)loadMore
{
    
    NSLog(@"lodeMore url = %@", nextUrl);
    if([nextUrl class] == [NSNull class]
       || [nextUrl isEqualToString:@""] ) {
        [self.childCollectionView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:nextUrl WithParaments:nil WithSuccess:^(id responseObject) {
        [self stopFooterRefresh];
        if (!responseObject)return ;
        [self fetchedMorePageData:responseObject];
    } WithFail:^(NSError *error) {
        
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
        CollectionModel *model = [[CollectionModel alloc] initWithDiction:ladyInfo];
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
    [self.childCollectionView insertItemsAtIndexPaths:numArray];
    [numArray removeAllObjects];
    numArray = nil;
    
    _isupdate = YES;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Child vc viewDidLoad");

//    [self itemDataSource];
//    [self craeteRight];
    // Do any additional setup after loading the view from its nib.
    isOrder = NO;
    _isFirst = YES;
    _isupdate = YES;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.orderDataArray = [[NSMutableArray alloc] init];

    [self.view addSubview:[[UIView alloc] init]];
    [self setLayout];
    self.topdistant.constant = 64;
    self.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
//    if(self.childClothing){
//        [self createNavigationBarWithTitle:@"精选童装"  selector:@selector(backClicked:)];
//    }
//    else{
//        [self createNavigationBarWithTitle:@"精选女装"  selector:@selector(backClicked:)];
//    }
    [self createNavigationBarWithTitle:self.nameTitle selector:@selector(backClicked:)];
    
  //  self.childCollectionView.bounces = NO;
    [self.childCollectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:ksimpleCell];
    
   
    self.childCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self.view addSubview:self.containerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCurrentState) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadGoods)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.childCollectionView.mj_header = header;
    
    //添加上拉加载
    self.childCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //此处用的是在scrollview里面画到底部前自动刷新了，此处不做处理，只是显示一个提示而已
    }];
    
    //[self.childCollectionView.mj_header beginRefreshing];

    [self reloadGoods];
    NSLog(@"Child vc viewDidLoad end");
    [self createButton];
    
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
    [SVProgressHUD show];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        [self stopHeaderRefresh];
        [SVProgressHUD dismiss];
        if (!responseObject)return ;
        [self fatchedSuggestListData:responseObject];
    } WithFail:^(NSError *error) {
        [SVProgressHUD dismiss];
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
        CollectionModel *model = [[CollectionModel alloc] initWithDiction:ladyInfo];
        [_dataArray addObject:model];
    }
    NSLog(@"_dataArray count %lu",(unsigned long)_dataArray.count);
    [self.childCollectionView reloadData];
}

- (void)downloadOrderData{
    [SVProgressHUD show];
//    [self downLoadWithURLString:self.orderUrlString andSelector:@selector(fatchedOrderListData:)];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.orderUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self stopHeaderRefresh];
        if (!responseObject)return ;
        [self fatchedOrderListData:responseObject];
    } WithFail:^(NSError *error) {
        [SVProgressHUD dismiss];
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
        CollectionModel *model = [[CollectionModel alloc] initWithDiction:ladyInfo];
        [self.orderDataArray addObject:model];
        
    }
    //[activityIndicator removeFromSuperview];
    //activityIndicator = nil;
    

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
            CollectionModel *model = [_orderDataArray objectAtIndex:indexPath.row];
            
            [cell fillDataWithCollectionModel:model];
        }
        
       
    }else{
        //NSLog(@"collectionView cell _dataArray.count=%lu indexPath.row=%ld", (unsigned long)_dataArray.count, (long)indexPath.row);
        if (_dataArray.count > indexPath.row) {
            CollectionModel *model = [_dataArray objectAtIndex:indexPath.row];
            
            [cell fillDataWithCollectionModel:model];
        }
       
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    _childDic = [NSMutableDictionary dictionary];

    CollectionModel *model = nil;
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
    
    detailVC.goodsID = model.model_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    

//    WebViewController *webView = [[WebViewController alloc] init];
//    webView.webDiction = _childDic;
//    webView.isShowNavBar =false;
//    webView.isShowRightShareBtn=false;
//    [self.navigationController pushViewController:webView animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _contentY = scrollView.contentOffset.y;
    [UIView animateWithDuration:0.5 animations:^{
        self.topButton.hidden = NO;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y <240 && scrollView.contentOffset.y > -400) {
//        return;
//    }
//    CGPoint point = scrollView.contentOffset;
//    CGFloat temp = oldScrollViewTop - point.y;
//
//    NSLog(@"contentSize.height=%f y=%fl",scrollView.contentSize.height, scrollView.contentOffset.y );
    if (scrollView.contentSize.height - scrollView.contentOffset.y < 2 * SCREENHEIGHT && _isupdate) {
            [self loadMore];
            _isupdate = NO;
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
    NSLog(@"btnClicked %ld", (long)self.childCollectionView.visibleCells.count );
    
    if(self.childCollectionView.visibleCells.count > 0){
        NSIndexPath *bottomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
        [self.childCollectionView scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    
    self.childCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //此处用的是在scrollview里面画到底部前自动刷新了，此处不做处理，只是显示一个提示而已
    }];
    
    if (sender.tag == 1) {
        isOrder = NO;
        
        
        //[activityIndicator removeFromSuperview];
        //activityIndicator = nil;
        [self.childCollectionView reloadData];
        [self.jiageButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.tuijianButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        //[self downloadData];
        
        [self.childCollectionView reloadData];
        
    } else if (sender.tag == 2){
        isOrder = YES;
        
        if(self.orderDataArray.count > 0){
           [self.childCollectionView reloadData];
        }
        else{
            [self downloadOrderData];
        }

        
        [self.tuijianButton setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
        [self.jiageButton setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
        

//        if (activityIndicator == nil) {
//            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        }
//        
//        activityIndicator.backgroundColor = [UIColor clearColor];
//        [activityIndicator startAnimating];
//        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2 - 80);
//        [self.childCollectionView addSubview:activityIndicator];
        
        
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

//- (void)hiddenBackTopBtn {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topButton.hidden = YES;
//    }];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenBackTopBtn) userInfo:nil repeats:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    // Dispose of any resources that can be recreated.
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end






































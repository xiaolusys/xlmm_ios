//
//  JMClassifyListController.m
//  XLMM
//
//  Created by zhang on 16/8/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMClassifyListController.h"
#import "JMRootgoodsCell.h"
#import "JMGoodsDetailController.h"
#import "JMSelecterButton.h"
#import "JMEmptyView.h"
#import "JMEmptyGoodsView.h"
#import "JMRootGoodsModel.h"
#import "JMReloadEmptyDataView.h"

@interface JMClassifyListController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) JMSelecterButton *selectedButton;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

static NSString * cellId = @"JMClassifyListController";

@implementation JMClassifyListController {
    NSString *_nextPageUrlString;
    NSMutableArray *_numArray;
    NSString *_currentUrlString;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];
    
    _currentUrlString = self.urlString;
    [self createCollectionView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collectionView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{  //  MJRefreshBackNormalFooter -- > 空视图隐藏点击加载更多   MJRefreshAutoNormalFooter -- > 空视图不会隐藏点击加载更多 
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    _currentUrlString = self.urlString;
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}
- (void)refresh {
    if ([_currentUrlString isEqualToString:self.urlString]) {
        return ;
    }
    [MBProgressHUD showLoading:@""];
    [self loadDataSource];
}
- (void)loadDataSource {
//    [self.dataSource removeAllObjects];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
        [self fatchClassifyListData:responseObject];
        [self endRefresh];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fatchClassifyListMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

- (void)fatchClassifyListData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.collectionView cs_reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        _numArray = [NSMutableArray array];
        for (NSDictionary *dic in resultsArr) {
            NSIndexPath *index ;
            index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
            JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
            [_numArray addObject:index];
        }
        if((_numArray != nil) && (_numArray.count > 0)){
            @try{
                [self.collectionView insertItemsAtIndexPaths:_numArray];
                [_numArray removeAllObjects];
                _numArray = nil;
            }
            @catch(NSException *except)
            {
                NSLog(@"DEBUG: failure to batch update.  %@", except.description);
            }
        }
    }
    [self.collectionView cs_reloadData];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    if ([NSString isStringEmpty:self.titleString]) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) collectionViewLayout:layout];
    }else {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:cellId];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootgoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    [cell fillDataWithGoodsList:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    NSString *goodsID = model.goodsID;
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//- (void)emptyView {
//    if ([NSString isStringEmpty:self.emptyTitle]) {
//        self.emptyTitle = @"查看其它分类";
//    }
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"暂时没有商品哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:self.emptyTitle];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    };
//}

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if ([NSString isStringEmpty:self.emptyTitle]) {
        self.emptyTitle = @"查看其它分类";
    }
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"暂时没有商品哦~" DescTitle:@"" ButtonTitle:self.emptyTitle Image:@"emptyGoods" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}




//- (void)emptyView {
//    JMEmptyGoodsView *empty = [[JMEmptyGoodsView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99)];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    };
//    
//}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMClassifyListController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMClassifyListController"];
}









@end













































































































//
//  JMHomeCollectionController.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeCollectionController.h"
#import "JMGoodsDetailController.h"

@interface JMHomeCollectionController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

static NSString * homeCollectionIndefir = @"JMHomeCollectionControllerIdentifier";

@implementation JMHomeCollectionController {
    NSString *_nextPageUrl;
    NSString *_urlString;
    NSMutableArray *_numArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    [self createPullFooterRefresh];

}
#pragma mrak 刷新界面
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}
- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    [self.dataSource removeAllObjects];
    [self fetchData:dataDict];
    [self.collectionView.mj_footer resetNoMoreData];
}
- (void)fetchData:(NSDictionary *)goodsDic {
    _nextPageUrl = goodsDic[@"next"];
    NSArray *resultsArr = goodsDic[@"results"];
    if (resultsArr.count == 0) {
        return ;
    }
    for (NSDictionary *dic in resultsArr) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
    
}
- (void)loadMore
{
    if ([NSString isStringEmpty:_nextPageUrl]) {
        [self endRefresh];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//        [MBProgressHUD showMessage:@"加载完成,没有更多数据"];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchMoreData:(NSDictionary *)goodsDic {
    _nextPageUrl = goodsDic[@"next"];
    NSArray *resultsArr = goodsDic[@"results"];
    if (resultsArr.count == 0) {
        return ;
    }
    _numArray = [NSMutableArray array];
    for (NSDictionary *dic in resultsArr) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
        NSIndexPath *index ;
        index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
        [self.dataSource addObject:model];
        [_numArray addObject:index];
        
    }
    if((_numArray != nil) && (_numArray.count > 0)) {
        @try{
            [self.collectionView insertItemsAtIndexPaths:_numArray];
            [_numArray removeAllObjects];
            _numArray = nil;
        }
        @catch(NSException *except) {
            NSLog(@"DEBUG: failure to batch update.  %@", except.description);
        }
    }
    [self.collectionView reloadData];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 垂直滚动
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 80 - 45) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor orangeColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:CS_STRING([self class])];
    NSLog(@"%@",CS_STRING([self class]));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootgoodsCell *cell = (JMRootgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CS_STRING([self class]) forIndexPath:indexPath];
    if (self.dataSource.count == 0) {
        return cell;
    }
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    [cell fillDataWithGoodsList:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"checkGoodsDetailClick"];
    if (self.dataSource.count == 0) {
        return ;
    }
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMHomeCollectionController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMHomeCollectionController"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end



























































































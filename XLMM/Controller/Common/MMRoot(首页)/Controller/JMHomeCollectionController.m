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


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

static NSString * cellId = @"JMClassifyListController";
static NSString * collectionHeaderView = @"JMClassifyListControllerHeaderId";
static NSString * collectionFooterVIew = @"JMClassifyListControllerFooterId";

@implementation JMHomeCollectionController {
    NSString *_nextPageUrl;
    NSString *_urlString;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentSelectedIndexChange:) name:@"JMHomeCollectionController" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentSelectedIndexChange:) name:@"JMHomeYesterdayController" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentSelectedIndexChange:) name:@"JMHomeTomorrowController" object:nil];
//    _urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/today?page=1&page_size=10",Root_URL];
//    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick:)];
    [self createCollectionView];
//    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
//    [self loadDataSource];
}
#pragma mrak 刷新界面
//- (void)createPullHeaderRefresh {
//    kWeakSelf
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _isPullDown = YES;
//        [weakSelf loadDataSource];
//    }];
//}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
//    if (_isPullDown) {
//        _isPullDown = NO;
//        [self.collectionView.mj_header endRefreshing];
//    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    [self.dataSource removeAllObjects];
    [self fetchData:dataDict];
}

//- (void)segmentSelectedIndexChange:(NSNotification *)sender {
//    _urlString = sender.object;
////    [self loadDataSource];
//}

//- (NSString *)urlString {
//    return [NSString stringWithFormat:@"%@/rest/v2/modelproducts/today?page=1&page_size=10",Root_URL];
//}
//- (void)loadDataSource {
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlString WithParaments:self WithSuccess:^(id responseObject) {
//        if (!responseObject) return;
//        [self.dataSource removeAllObjects];
//        [self fetchData:responseObject];
//        [self endRefresh];
//        [self.collectionView reloadData];
//    } WithFail:^(NSError *error) {
//        [self endRefresh];
//    } Progress:^(float progress) {
//        
//    }];
//    
//}
- (void)loadMore
{
    if ([_nextPageUrl class] == [NSNull class]) {
        [self endRefresh];
        [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
        [self endRefresh];
        
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData:(NSDictionary *)goodsDic {
    _nextPageUrl = goodsDic[@"next"];
    NSArray *resultsArr = goodsDic[@"results"];
    for (NSDictionary *dic in resultsArr) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
//    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 0);
//    layout.footerReferenceSize = CGSizeMake(SCREENWIDTH, 64);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 垂直滚动
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 80) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:cellId];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderView];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterVIew];
    
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
    [cell fillData:model];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return (CGSize){SCREENWIDTH,44};
//}
// 和UITableView类似，UICollectionView也可设置段头段尾
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *supView = nil;
//    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
//        supView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderView forIndexPath:indexPath];
//        supView.backgroundColor = [UIColor whiteColor];
//    }
//    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        supView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterVIew forIndexPath:indexPath];
//        supView.backgroundColor = [UIColor redColor];
//    }
//    
//    return supView;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.readImageUrl = model.head_img;
    detailVC.goodsID = model.goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- (void)backClick:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [MobClick beginLogPageView:@"JMHomeCollectionController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"JMHomeCollectionController"];
    [super viewWillDisappear:animated];
}


/**
 *  @[yesterdayVC,todayVC,tomorrowVC];
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



























































































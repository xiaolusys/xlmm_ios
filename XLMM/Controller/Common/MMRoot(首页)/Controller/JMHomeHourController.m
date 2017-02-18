//
//  JMHomeHourController.m
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeHourController.h"
#import "JMHomeHourCell.h"
#import "JMHomeHourModel.h"
#import "JMGoodsDetailController.h"


@interface JMHomeHourController () <UITableViewDelegate,UITableViewDataSource> {
    NSString *_nextPageUrl;
    NSMutableArray *_numArray;
}

//@property (nonatomic, strong) NSMutableArray *dataSource;

//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMHomeHourController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self.view addSubview:self.collectionView];
//        
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
//    [self createPullFooterRefresh];
    
    
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}
//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake((SCREENWIDTH - 10), 100);
//        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        layout.minimumInteritemSpacing = 5;
//        layout.minimumLineSpacing = 5;
//        //    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 垂直滚动
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor orangeColor];
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//        _collectionView.scrollEnabled = NO;
//        //    [self.collectionView.collectionViewLayout invalidateLayout];
////        [self.view addSubview:self.collectionView];
//        
//        [_collectionView registerClass:[JMHomeHourCell class] forCellWithReuseIdentifier:CS_STRING([self class])];
////        NSLog(@"%@",CS_STRING([self class]));
//
//        
//    }
//    return _collectionView;
//}


- (void)createCollectionView {
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake((SCREENWIDTH - 10), 100);
//    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 5;
    //    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 垂直滚动
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
//    self.tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 100.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.translatesAutoresizingMaskIntoConstraints = YES;
//    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JMHomeHourCell class] forCellReuseIdentifier:CS_STRING([self class])];
//    [self.collectionView registerClass:[JMHomeHourCell class] forCellWithReuseIdentifier:CS_STRING([self class])];
    NSLog(@"%@",CS_STRING([self class]));
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeHourCell *cell = [tableView dequeueReusableCellWithIdentifier:CS_STRING([self class])];
    if (self.dataSource.count == 0) {
        return cell;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"checkGoodsDetailClick"];
    if (self.dataSource.count == 0) {
        return ;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMHomeHourController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMHomeHourController"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
























/*
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
 - (void)loadMore {
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
 JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:dic];
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
 */

























































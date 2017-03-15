//
//  CSCollectionController.m
//  XLMM
//
//  Created by zhang on 17/3/15.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSCollectionController.h"
#import "JMRootGoodsModel.h"
#import "JMFineCouponModel.h"
#import "JMDataManger.h"



@interface CSCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSString *_nextPageUrlString;
    NSMutableArray *_numArray;
}


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation CSCollectionController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"collectionView的视图已经加载完成");
    
    self.dataArray = [[[JMDataManger sharedInstance] pageInfoWithMenuId:self.urlString] mutableCopy];
    if (self.dataArray.count == 0) {
        [self.collectionView.mj_header beginRefreshing];
    }else {
        [self.collectionView reloadData];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"item"];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 109, 0);
    [self.view addSubview:self.collectionView];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        [weakSelf loaddataArray:self.urlString];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}
- (void)loaddataArray:(NSString *)urlString {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSLog(@"%@",responseObject);
        [self.dataArray removeAllObjects];
        [self fatchClassifyListData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
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
    NSMutableArray *dataA = [NSMutableArray array];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [dataA addObject:model];
        }
    }
    self.dataArray = [dataA mutableCopy];
    [self saveCurrentPageData];
    [self.collectionView reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        _numArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultsArr) {
            NSIndexPath *index ;
            index = [NSIndexPath indexPathForRow:self.dataArray.count inSection:0];
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
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
    [self saveCurrentPageData];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lineGrayColor];
    JMFineCouponModel *model = self.dataArray[indexPath.row];
    UILabel * title = [cell viewWithTag:888];
    if (nil == title) {
        title = [UILabel new];
        title.tag = 888;
        title.cs_size = CGSizeMake((SCREENWIDTH - 15) / 2, (SCREENWIDTH - 15) / 2);
        title.textColor = [UIColor redColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:14];
        [cell addSubview:title];
    }
    title.center = CGPointMake(cell.cs_w/2, cell.cs_h/2);
    title.text = [NSString stringWithFormat:@"Item %ld  \n  %@",indexPath.item,model.name];
    
    
    return cell;
}

- (void)saveCurrentPageData {
    [[JMDataManger sharedInstance] savePageInfo:self.dataArray menuId:self.urlString];
}










@end























































//
//  JMFineCounpContentController.m
//  XLMM
//
//  Created by zhang on 16/12/2.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFineCounpContentController.h"
#import "JMEmptyView.h"
#import "JMFineCouponModel.h"
#import "JMRootgoodsCell.h"
#import "JMGoodsDetailController.h"

@interface JMFineCounpContentController () <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;


@end

static NSString * JMFineCounpContentControllerIdentifier = @"JMFineCounpContentControllerIdentifier";

@implementation JMFineCounpContentController {
    NSString *_nextPageUrlString;
    NSMutableArray *_numArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    [self createCollectionView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    

}
- (void)refresh {
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
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
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
    if (resultsArr.count == 0) {
        //展示空视图
        [self emptyView];
        return ;
    }else {
        for (NSDictionary *dic in resultsArr) {
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.collectionView reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count == 0) {
        //展示空视图
        [self emptyView];
        return ;
    }
    _numArray = [NSMutableArray array];
    
    for (NSDictionary *dic in resultsArr) {
        NSIndexPath *index ;
        index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
        JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
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
    [self.collectionView reloadData];
    
    
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 150) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:JMFineCounpContentControllerIdentifier];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootgoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMFineCounpContentControllerIdentifier forIndexPath:indexPath];
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    [cell fillDataWithGoodsList:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    NSString *goodsID = model.fineCouponModelID;
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (void)emptyView {
    kWeakSelf
    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"暂时没有商品哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@"查看其它分类"];
    [self.view addSubview:empty];
    empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
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









@end

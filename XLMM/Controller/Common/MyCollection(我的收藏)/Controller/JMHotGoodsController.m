//
//  JMHotGoodsController.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHotGoodsController.h"
#import "JMRootgoodsCell.h"
#import "JMStoreUpModel.h"
#import "WebViewController.h"
#import "JMEmptyView.h"
#import "JMGoodsDetailController.h"
#import "MBProgressHUD+JMHUD.h"


//static NSString *storeUpCell = @"JMHotGoodsController";

@interface JMHotGoodsController ()

@property (nonatomic, strong) JMEmptyView *empty;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation JMHotGoodsController {
    NSString *_nextPageUrlString;
}


- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"我的收藏" selecotr:@selector(backClick:)];
    
    [self emptyView];
    [self createCollection];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collection.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collection.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
    self.collection.mj_footer = self.footer;
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collection.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collection.mj_footer endRefreshing];
    }
}

- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
    [self.dataSource removeAllObjects];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)loadMore {
    if ([NSString isStringEmpty:self.nextPageUrlString]) {
        [self endRefresh];
        [self.collection.mj_footer endRefreshingWithNoMoreData];
        [self endRefresh];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData:(NSDictionary *)goodsDic {
    self.nextPageUrlString = goodsDic[@"next"];
    NSArray *resultsArr = goodsDic[@"results"];
    for (NSDictionary *dic in resultsArr) {
        NSDictionary *productDic = dic[@"modelproduct"];
        NSString *shelfStatus = productDic[@"shelf_status"];
        if (![shelfStatus isEqual:@"off"]) {
            JMStoreUpModel *model = [JMStoreUpModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }else {
        
        }
    }
    if (self.dataSource.count == 0) {
        self.footer.stateLabel.hidden = YES;
        [self.view addSubview:self.empty];
    }else {
    }
    [self.collection reloadData];
}

- (void)createCollection {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.view addSubview:self.collection];
    
    [self.collection registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:@"JMHotGoodsController"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JMRootgoodsCell *cell = (JMRootgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"JMHotGoodsController" forIndexPath:indexPath];
    cell.block = ^(NSString *storID) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"model_id"] = storID;
        [JMHTTPManager requestWithType:RequestTypeDELETE WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
            if (!responseObject) return ;
            NSLog(@"%@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [MobClick event:@"cancleStoreUpSuccess"];
                [self.collection.mj_header beginRefreshing];
            }else {
                NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
                [MobClick event:@"cancleStoreUpFail" attributes:temp_dict];
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
        } WithFail:^(NSError *error) {
            [MobClick event:@"cancleStoreUpFail"];
        } Progress:^(float progress) {
            
        }];
    };
    JMStoreUpModel *model = self.dataSource[indexPath.row];
    [cell fillStoreUpData:model];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREENWIDTH - 15) / 2,(SCREENWIDTH - 15) * 0.5 * 8/6 + 60};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMStoreUpModel *model = self.dataSource[indexPath.row];
    
    NSDictionary *modelProductDic = model.modelproduct;
    
//    NSMutableDictionary *dictionDic = [NSMutableDictionary dictionary];
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = modelProductDic[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    

    
//    [dictionDic setValue:modelProductDic[@"web_url"] forKey:@"web_url"];
//    WebViewController *webView = [[WebViewController alloc] init];
//    webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:dictionDic];
//    webView.isShowNavBar =false;
//    webView.isShowRightShareBtn=false;
//    [self.navigationController pushViewController:webView animated:YES];
    
    
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99) Title:@"还没有收藏商品哦~!" DescTitle:@"喜欢的东西要收藏哦,赶紧去收藏吧~!" BackImage:@"emptyStoreUp" InfoStr:@"快去逛逛"];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}


- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMHotGoodsController"];
    [self.collection.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMHotGoodsController"];
}


@end


































































































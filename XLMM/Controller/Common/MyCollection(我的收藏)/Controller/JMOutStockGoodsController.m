//
//  JMOutStockGoodsController.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOutStockGoodsController.h"
#import "JMStoreUpModel.h"
#import "JMEmptyView.h"


@interface JMOutStockGoodsController ()

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@end

@implementation JMOutStockGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"下架商品" selecotr:@selector(backClick:)];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
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

- (void)lodaDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
    [self.dataSource removeAllObjects];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self fetchData:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([self.nextPageUrlString isKindOfClass:[NSNull class]] || self.nextPageUrlString == nil || [self.nextPageUrlString isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"没有更多数据....."];
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
        if ([shelfStatus isEqual:@"off"]) {
            JMStoreUpModel *model = [JMStoreUpModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }else {
            
        }
    }
    if (self.dataSource.count == 0) {
        [self emptyView];
    }else {
    }
    [self.collection reloadData];
}
- (void)emptyView {
    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99)];
    [self.view addSubview:empty];
    
    empty.block = ^(NSInteger index) {
        if (index == 100) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
}
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

















































































































































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
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) JMEmptyView *empty;

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
    self.collection.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collection.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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

- (void)lodaDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self.dataSource removeAllObjects];
            [self fetchData:responseObject];
        }
    } WithFail:^(NSError *error) {
        
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
        if ([shelfStatus isEqual:@"off"]) {
            JMStoreUpModel *model = [JMStoreUpModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }else {
            
        }
    }
    if (self.dataSource.count == 0) {
        self.footer.stateLabel.hidden = YES;
        if (self.empty == nil) {
            [self emptyView];
        }
    }else {
        if (self.empty) {
            [self.empty removeFromSuperview];
            self.empty = nil;
        }
    }
    [self.collection reloadData];
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99) Title:@"还没有收藏商品哦~!" DescTitle:@"喜欢的东西要收藏哦,赶紧去收藏吧~!" BackImage:@"emptyStoreUp" InfoStr:@"快去逛逛"];
    [self.view addSubview:self.empty];
    weakSelf.empty.block = ^(NSInteger index) {
        if (index == 100) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
        }
    };
}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

















































































































































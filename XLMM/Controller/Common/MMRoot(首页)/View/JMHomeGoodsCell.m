//
//  JMHomeGoodsCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeGoodsCell.h"
#import "MMClass.h"
#import "JMRootgoodsCell.h"
#import "JMRootGoodsModel.h"

NSString *const JMHomeGoodsCellIdentifier = @"JMHomeGoodsCellIdentifier";

@interface JMHomeGoodsCell ()<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *baseScrollView;

@property (nonatomic, strong) UICollectionView *collectionView;



@end

static NSString *JMRootgoodsCellIdfier = @"JMRootgoodsCellIdfier";

@implementation JMHomeGoodsCell {
//    NSInteger _currentIndex;
    NSMutableArray *_collectionArray;
    NSArray *_urlArray;
    NSString *_nextPage;                 // 下一页数据
    
    
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _collectionArray = [NSMutableArray array];
        _urlArray = @[@"/rest/v2/modelproducts/yesterday?page=1&page_size=10",
                               @"/rest/v2/modelproducts/today?page=1&page_size=10",
                               @"/rest/v2/modelproducts/tomorrow?page=1&page_size=10"];
        
//        [self createUI];
    }
    return self;
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
//    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * self.currentIndex, 0);
    
//    [self loadDataSource:currentIndex];
 
}

- (void)loadDataSource:(NSInteger)index {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",Root_URL,_urlArray[index]];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchGoodsInfo:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
        
    }];
    
}
- (void)fetchGoodsInfo:(NSDictionary *)goodsDic {
    _nextPage = goodsDic[@"next"];
    NSArray *resultsArr = goodsDic[@"results"];
    for (NSDictionary *dic in resultsArr) {
        JMRootGoodsModel *model = [JMRootGoodsModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
    
    [self.collectionView reloadData];
}




- (void)createUI {
    CGFloat contentW = self.contentView.frame.size.width;
    CGFloat contentH = SCREENHEIGHT;
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(1 * contentW, contentH);
    [self.contentView addSubview:self.baseScrollView];
    
    for (int i = 0; i < 3; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.baseScrollView addSubview:self.collectionView];
        [self.collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:JMRootgoodsCellIdfier];
        [_collectionArray addObject:self.collectionView];
    }
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMRootgoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMRootgoodsCellIdfier forIndexPath:indexPath];
    JMRootGoodsModel *model = self.dataSource[indexPath.row];
    [cell fillData:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){(SCREENWIDTH - 20) / 3,(SCREENWIDTH - 20) * 4 / 10};
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark --scrollView的代理方法w
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.baseScrollView) {
        NSInteger count = scrollView.contentOffset.x / SCREENWIDTH;
        self.currentIndex = count;
        
    }
}



@end














































































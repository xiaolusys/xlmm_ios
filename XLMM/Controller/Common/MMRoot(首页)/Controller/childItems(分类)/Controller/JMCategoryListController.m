//
//  JMCategoryListController.m
//  XLMM
//
//  Created by zhang on 16/8/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCategoryListController.h"
#import "JMCategoryListCell.h"
#import "JMClassifyListController.h"
#import "JMEmptyView.h"

@interface JMCategoryListController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString * categoryCellId = @"JMCategoryListController";

@implementation JMCategoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];
    
    if (self.dataSource.count == 0) {
        [self emptyView];
    }else {
        [self createCollectionView];
    }
    
    

}
- (void)emptyView {
    kWeakSelf
    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 3, SCREENWIDTH, SCREENHEIGHT - (SCREENHEIGHT / 3)) Title:@"暂时没有分类哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@"查看其它分类"];
    [self.view addSubview:empty];
    empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[JMCategoryListCell class] forCellWithReuseIdentifier:categoryCellId];

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JMCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellId forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.itemsDic = dic;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){(SCREENWIDTH - 20) / 3,(SCREENWIDTH - 20) * 4 / 10};
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *cid = dic[@"cid"];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,cid];
    JMClassifyListController *itemVC = [[JMClassifyListController alloc] init];
    itemVC.titleString = dic[@"name"];
    itemVC.urlString = urlString;
    [self.navigationController pushViewController:itemVC animated:YES];
    
}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}



@end






















































































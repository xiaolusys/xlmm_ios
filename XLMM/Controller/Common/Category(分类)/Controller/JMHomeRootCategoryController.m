//
//  JMHomeRootCategoryController.m
//  XLMM
//
//  Created by zhang on 16/9/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeRootCategoryController.h"
#import "MMClass.h"
#import "JMCategoryListCell.h"
#import "JMHomeRootCategoryCell.h"
#import "JMEmptyView.h"
#import "JMClassifyListController.h"

#define TabWidth SCREENWIDTH * 0.25
#define ColWidth SCREENWIDTH * 0.75

static NSString * homeCategoryCellId = @"JMHomeRootCategoryController";
static NSUInteger selectedIndex = 0;

@interface JMHomeRootCategoryController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSArray *tabDataArray;
@property (nonatomic, strong) NSMutableArray *tabDataSource;
@property (nonatomic, strong) NSMutableArray *colDataSource;

@property (nonatomic, strong) JMEmptyView *empty;

@end

@implementation JMHomeRootCategoryController

- (NSMutableArray *)tabDataSource {
    if (_tabDataSource == nil) {
        _tabDataSource = [NSMutableArray array];
    }
    return _tabDataSource;
}
- (NSMutableArray *)colDataSource {
    if (_colDataSource == nil) {
        _colDataSource = [NSMutableArray array];
    }
    return _colDataSource;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMHomeRootCategoryController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMHomeRootCategoryController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];

    [self createTableView];
    [self createCollectionView];
    
    [self itemDataSource];
}

- (void)itemDataSource {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    //==JsonObject
    self.tabDataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    int i = 0;
    for (NSDictionary *dict in self.tabDataArray) {
        [self.tabDataSource addObject:dict[@"name"]];
        if ([dict[@"cid"] isEqual:self.cidString]) {
            selectedIndex = i;
        }else {
            i ++;
        }
        NSMutableArray *dictArr = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"childs"]) {
            [dictArr addObject:dic];
        }
        [self.colDataSource addObject:dictArr];
    }

    [self.mainTableView reloadData];
    [self.mainCollectionView reloadData];
    

}
- (void)createTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TabWidth, SCREENHEIGHT) style:UITableViewStylePlain];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.backgroundColor = [UIColor countLabelColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.rowHeight = 60.;
    
    [self.view addSubview:self.mainTableView];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TabWidth, 64, ColWidth, SCREENHEIGHT - 64) collectionViewLayout:layout];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    [self.mainCollectionView registerClass:[JMCategoryListCell class] forCellWithReuseIdentifier:homeCategoryCellId];
    [self.view addSubview:self.mainCollectionView];
    
    [self emptyView];
    self.empty.hidden = YES;
    
}

- (void)emptyView {
//    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(TabWidth / 2, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"暂时没有分类哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@""];
    [self.view addSubview:self.empty];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMHomeRootCategoryCell";
    JMHomeRootCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMHomeRootCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *nameString = self.tabDataSource[indexPath.row];
    [cell configName:nameString Index:indexPath.row SelectedIndex:selectedIndex];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTableView reloadData];
    [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.mainCollectionView scrollRectToVisible:CGRectMake(0, 0, self.mainCollectionView.frame.size.width, self.mainCollectionView.frame.size.height) animated:YES];
    selectedIndex = indexPath.row;
    NSString *titleStr = self.tabDataSource[selectedIndex];
    [self createNavigationBarWithTitle:titleStr selecotr:@selector(backClick:)];
    [self.mainCollectionView reloadData];
//    [self.mainTableView reloadData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.empty.hidden = YES;
    NSArray *dicArr = self.colDataSource[selectedIndex];
    if (dicArr.count == 0) {
        self.empty.hidden = NO;
    }
    return dicArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCategoryCellId forIndexPath:indexPath];
    NSDictionary *dic = self.colDataSource[selectedIndex][indexPath.row];
    
    cell.itemsDic = dic;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){(ColWidth - 20) / 3,(ColWidth - 20) * 5 / 9};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.colDataSource[selectedIndex][indexPath.row];
    NSString *cid = dic[@"cid"];
    
    JMClassifyListController *itemVC = [[JMClassifyListController alloc] init];
    itemVC.titleString = dic[@"name"];
    itemVC.cid = cid;
    [self.navigationController pushViewController:itemVC animated:YES];

}





- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


@end























































































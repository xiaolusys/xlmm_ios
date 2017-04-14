//
//  JMHomeRootCategoryController.m
//  XLMM
//
//  Created by zhang on 16/9/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeRootCategoryController.h"
#import "JMCategoryListCell.h"
#import "JMHomeRootCategoryCell.h"
#import "JMEmptyView.h"
#import "JMClassifyListController.h"
#import "JMSearchViewController.h"
#import "JMCategoryColSectionReusableView.h"
#import "JMCategoryPageController.h"


#define TabWidth SCREENWIDTH * 0.25
#define ColWidth SCREENWIDTH * 0.75

static NSString * const homeCategoryCellId = @"JMHomeRootCategoryController";
static NSString * const CategoryCellId = @"JMHomeRootCategoryCell";

static NSUInteger selectedIndex = 0;

@interface JMHomeRootCategoryController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *tabDataArray;
@property (nonatomic, strong) NSMutableArray *tabDataSource;
@property (nonatomic, strong) NSMutableArray *colDataSource;
@property (nonatomic, strong) NSMutableArray *colSectionDataSource;

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
- (NSMutableArray *)colSectionDataSource {
    if (_colSectionDataSource == nil) {
        _colSectionDataSource = [NSMutableArray array];
    }
    return _colSectionDataSource;
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
    self.view.backgroundColor = [UIColor countLabelColor];
//    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];
    
    [self createSearchBarView];
    [self itemDataSource];
}
- (void)emptyCategory {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"暂时没有分类哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@""];
    [self.view addSubview:self.empty];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}
- (void)itemDataSource {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    if (data == nil) {
        if ([NSString isStringEmpty:self.categoryUrl]) {
            [self emptyCategory];
        }else {
            [self createTableView];
            [self createCollectionView];
            [self loadCategoryData];
        }
    }else {
        self.tabDataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self fetchCategoryData:self.tabDataArray];
        [self createTableView];
        [self createCollectionView];
    }
    
    //==JsonObject
    
    
}
- (void)loadCategoryData {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.categoryUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchCategoryData:responseObject];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self emptyCategory];
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchCategoryData:(NSArray *)tabDataArray {
    int i = 0;
    for (NSDictionary *dict1 in tabDataArray) {
        [self.tabDataSource addObject:dict1[@"name"]];
        NSString *cidStr = CS_STRING(dict1[@"cid"]);
        if ([cidStr isEqual:self.cidString]) {
            selectedIndex = i;
        }else {
            i ++;
        }
        NSMutableArray *dictArr1 = [NSMutableArray array];
        NSMutableArray *dictArr2 = [NSMutableArray array];
        for (NSDictionary *dict2 in dict1[@"childs"]) {
            [dictArr1 addObject:dict2];
            NSMutableArray *dictArr3 = [NSMutableArray array];
            for (NSDictionary *dict3 in dict2[@"childs"]) {
                [dictArr3 addObject:dict3];
            }
            [dictArr2 addObject:dictArr3];
        }
        [self.colDataSource addObject:dictArr2];
        [self.colSectionDataSource addObject:dictArr1];
    }
}
#pragma mark ==== 创建搜索框 ====
- (void)createSearchBarView {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:searchButton];
    searchButton.backgroundColor = [UIColor lineGrayColor];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateSelected];
    [searchButton setTitle:@"查找所有精品" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 5.;
    searchButton.frame = CGRectMake(0, 0, SCREENWIDTH - 80, 30);
    self.navigationItem.titleView = searchButton;

}
#pragma mark ==== 创建分类左边 UITableView ====
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TabWidth, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = 60.;
    [self.tableView registerClass:[JMHomeRootCategoryCell class] forCellReuseIdentifier:@"JMHomeRootCategoryCellIdentifier"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark ==== 创建分类右边 UICollectionView ====
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.itemSize = CGSizeMake((ColWidth - 20) / 3, (ColWidth - 20) * 5 / 9);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TabWidth, 64, ColWidth, SCREENHEIGHT - 64 - kAppTabBarHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[JMCategoryListCell class] forCellWithReuseIdentifier:@"JMCategoryListCellIdentifier"];
    [self.collectionView registerClass:[JMCategoryColSectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JMCategoryColSectionReusableViewIdentifier"];
    [self.view addSubview:self.collectionView];
}
#pragma mark ==== UITableView 代理实现 ====
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeRootCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMHomeRootCategoryCellIdentifier"];
    if (!cell) {
        cell = [[JMHomeRootCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JMHomeRootCategoryCellIdentifier"];
    }
    NSString *nameString = self.tabDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configName:nameString Index:indexPath.row SelectedIndex:selectedIndex];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}
#pragma mark ==== UICollectionView 代理实现 ====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.colSectionDataSource.count <= selectedIndex) {
        return 1;
    }else {
        NSArray *dicArr = self.colSectionDataSource[selectedIndex];
        return dicArr.count;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.colDataSource.count <= selectedIndex) {
        return 0;
    }else {
        NSArray *dicArr = self.colDataSource[selectedIndex];
        if (dicArr.count <= section) {
            return 0;
        }
        NSArray *dicRowArr = dicArr[section];
        return dicRowArr.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JMCategoryListCellIdentifier" forIndexPath:indexPath];
    NSArray *indexPathArr = self.colDataSource[selectedIndex];
    NSDictionary *dic = indexPathArr[indexPath.section][indexPath.row];
    cell.itemsDic = dic;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ColWidth, 60);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JMCategoryColSectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JMCategoryColSectionReusableViewIdentifier" forIndexPath:indexPath];
        NSArray *arr = self.colSectionDataSource[selectedIndex];
        NSString *titleStr = arr[indexPath.section][@"name"];
        reusableview.titleString = titleStr;
        return reusableview;
    }else {
        return nil;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexPathArr = self.colDataSource[selectedIndex];
    NSArray *arr = self.colSectionDataSource[selectedIndex];
    NSString *titleStr = arr[indexPath.section][@"name"];
    
    JMCategoryPageController *pageVC = [[JMCategoryPageController alloc] init];
    pageVC.title = titleStr;
    pageVC.sectionItems = indexPathArr[indexPath.section];
    pageVC.currentIndex = indexPath.row + 1;
    [self.navigationController pushViewController:pageVC animated:YES];
//    NSDictionary *dic = indexPathArr[indexPath.section][indexPath.row];
//    NSString *cid = dic[@"cid"];
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,cid];
//    JMClassifyListController *itemVC = [[JMClassifyListController alloc] init];
//    itemVC.titleString = dic[@"name"];
//    itemVC.urlString = urlString;
//    [self.navigationController pushViewController:itemVC animated:YES];
}
#pragma mark ==== 搜索框搜索事件 ====
- (void)searchButtonClick {
    JMSearchViewController *searchViewController = [JMSearchViewController searchViewControllerWithHistorySearchs:nil searchBarPlaceHolder:nil didSearchBlock:^(JMSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/search_by_name?name=%@",Root_URL,searchText];
        JMClassifyListController *searchVC = [[JMClassifyListController alloc] init];
        searchVC.titleString = searchText;
        searchVC.emptyTitle = @"搜索其他";
        searchVC.urlString = [urlString JMUrlEncodedString];
        [searchViewController.navigationController pushViewController:searchVC animated:YES];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
}
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


@end























































































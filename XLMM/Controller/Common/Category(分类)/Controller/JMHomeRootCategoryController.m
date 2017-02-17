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
#import "JMCategoryContentCell.h"
#import "JMSearchViewController.h"


#define TabWidth SCREENWIDTH * 0.25
#define ColWidth SCREENWIDTH * 0.75

static NSString * homeCategoryCellId = @"JMHomeRootCategoryController";
static NSString * CategoryCellId = @"JMHomeRootCategoryCell";

static NSUInteger selectedIndex = 0;

@interface JMHomeRootCategoryController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;

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
    [self createNavigationBarWithTitle:self.titleString selecotr:@selector(backClick:)];
    
    [self createSearchBarView];
    [self itemDataSource];
    
    
    //    [self createCollectionView];
    
    
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
            [self loadCategoryData];
        }
    }else {
        self.tabDataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self fetchCategoryData:self.tabDataArray];
        [self createTableView];
        [self crateContentTableView];
    }
    
    //==JsonObject
    
    
}
- (void)loadCategoryData {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.categoryUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchCategoryData:responseObject];
        [self.mainTableView reloadData];
        [self crateContentTableView];
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
    //    [self createTableView];
    //    [self.mainTableView reloadData];
    //    [self.mainCollectionView reloadData];
}
- (void)createSearchBarView {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:searchButton];
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateSelected];
    [searchButton setTitle:@"查找所有精品" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 2.;
    
    kWeakSelf
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view).offset(74);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - 30, 30));
    }];
    
    
}
- (void)createTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 + 64, TabWidth, SCREENHEIGHT - 50 - 64) style:UITableViewStylePlain];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.rowHeight = 60.;
//    self.mainTableView.contentInset = UIEdgeInsetsMake(50 + 64, 0, 0, 0);
    
    [self.view addSubview:self.mainTableView];
    
    [self emptyView];
    self.empty.hidden = YES;
}
- (void)crateContentTableView {
    // 添加测试数据
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(TabWidth, 64 + 50, ColWidth, SCREENHEIGHT - 64 - 50) style:UITableViewStylePlain];
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.showsVerticalScrollIndicator = NO;
    self.contentTableView.showsHorizontalScrollIndicator = NO;
    self.contentTableView.rowHeight = SCREENHEIGHT - 64;
//    self.contentTableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    [self.view addSubview:self.contentTableView];
    
    [self emptyView];
    self.empty.hidden = YES;
    
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.itemSize = CGSizeMake((ColWidth - 20) / 3, (ColWidth - 20) * 5 / 9);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TabWidth, 64, ColWidth, SCREENHEIGHT - 64 - 50) collectionViewLayout:layout];
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    [self.mainCollectionView registerClass:[JMCategoryListCell class] forCellWithReuseIdentifier:homeCategoryCellId];
//    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mainCollectionViewHeaderIdentifier];
    [self.view addSubview:self.mainCollectionView];
    
    
    
}

- (void)emptyView {
    //    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(TabWidth, 220, SCREENWIDTH - TabWidth, SCREENHEIGHT - 220) Title:@"暂时没有分类哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@""];
    [self.view addSubview:self.empty];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            //            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectiomn {
    if (tableView == self.mainTableView) {
        return self.tabDataSource.count;
    }else {
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //        static NSString *cellID = @"JMHomeRootCategoryCell";
        JMHomeRootCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCategoryCellId];
        if (!cell) {
            cell = [[JMHomeRootCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCategoryCellId];
        }
        NSString *nameString = self.tabDataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configName:nameString Index:indexPath.row SelectedIndex:selectedIndex];
        return cell;
    }else {
        //        JMCategoryContentCell
        //        static NSString *cellID = @"JMCategoryContentCell";
        JMCategoryContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellId];
        if (!cell) {
            cell = [[JMCategoryContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CategoryCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor orangeColor];
        //        NSString *nameString = self.tabDataSource[indexPath.row];
        //        [cell configName:nameString Index:indexPath.row SelectedIndex:selectedIndex];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        [self.mainTableView reloadData];
        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.contentTableView scrollRectToVisible:CGRectMake(0, 0, self.contentTableView.frame.size.width, self.contentTableView.frame.size.height) animated:YES];
        //        [self.mainCollectionView scrollRectToVisible:CGRectMake(0, 0, self.mainCollectionView.frame.size.width, self.mainCollectionView.frame.size.height) animated:YES];
        selectedIndex = indexPath.row;
        NSString *titleStr = self.tabDataSource[selectedIndex];
        [self createNavigationBarWithTitle:titleStr selecotr:@selector(backClick:)];
        [self.contentTableView reloadData];
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(JMCategoryContentCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentTableView) {
        [cell setCollectionViewDataSourceDelegate:self IndexPath:indexPath];
        //        selectedIndex = cell.contentCollecionView.ContentCollectionIndexPath.row;
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    self.empty.hidden = YES;
    NSArray *dicArr = self.colSectionDataSource[selectedIndex];
    if (dicArr.count == 0) {
        self.empty.hidden = NO;
    }
    return dicArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.empty.hidden = YES;
    //    selectedIndex = [(JMContentCollectionView *)collectionView ContentCollectionIndexPath].row;
    NSArray *dicArr = self.colDataSource[selectedIndex];
    NSArray *dicRowArr = dicArr[section];
    if (dicRowArr.count == 0) {
        self.empty.hidden = NO;
    }
    return dicRowArr.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ContentCollectionViewIndentifier forIndexPath:indexPath];
    NSInteger count = [self.colDataSource[selectedIndex] count];
    CGFloat contentH = (count / 3 + 1) * ((ColWidth - 20) * 5 / 9) + (count / 3) * 5;
    if (contentH > SCREENHEIGHT) {
        self.contentTableView.scrollEnabled = YES;
    }else {
        self.contentTableView.scrollEnabled = NO;
    }
    NSArray *indexPathArr = self.colDataSource[selectedIndex];
    NSDictionary *dic = indexPathArr[indexPath.section][indexPath.row];
    cell.itemsDic = dic;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.colSectionDataSource[selectedIndex];
    NSString *titleStr = arr[indexPath.section][@"name"];
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:mainCollectionViewHeaderIdentifier forIndexPath:indexPath];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, ColWidth, 60);
        button.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 100 + indexPath.section;
        [reusableview addSubview:button];
        return reusableview;
    }else {
        return nil;
    }

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ColWidth, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexPathArr = self.colDataSource[selectedIndex];
    NSDictionary *dic = indexPathArr[indexPath.section][indexPath.row];
    NSString *cid = dic[@"cid"];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,cid];
    JMClassifyListController *itemVC = [[JMClassifyListController alloc] init];
    itemVC.titleString = dic[@"name"];
    itemVC.urlString = urlString;
    [self.navigationController pushViewController:itemVC animated:YES];
    
}
//- (void)buttonClick:(UIButton *)button {
//    NSInteger index = button.tag - 100;
//    NSArray *arr = self.colSectionDataSource[selectedIndex];
//    NSDictionary *dic = arr[index];
//    NSString *cid = dic[@"cid"];
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@&page=1&page_size=10",Root_URL,cid];
//    JMClassifyListController *itemVC = [[JMClassifyListController alloc] init];
//    itemVC.titleString = dic[@"name"];
//    itemVC.urlString = urlString;
//    [self.navigationController pushViewController:itemVC animated:YES];
//    
//}
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























































































//
//  JMSearchViewController.m
//  XLMM
//
//  Created by zhang on 17/1/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchViewController.h"
#import "JMSearchHistoryCell.h"
#import "JMSearchHistoryModel.h"
#import "JMSearchHeaderView.h"


@interface JMSearchViewController () <UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

/** 键盘正在移动 */
@property (nonatomic, assign) BOOL keyboardshowing;
/** 记录键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

static NSString * JMSearchHistoryCellIdentifier = @"JMSearchHistoryCellIdentifier";
static NSString * JMSearchHistoryHeaderIdentifier = @"JMSearchHistoryHeaderIdentifier";

@implementation JMSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadHistoryData];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor buttonEnabledBackgroundColor];
    [MobClick beginLogPageView:@"JMSearchController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.searchBar resignFirstResponder];
    [MobClick endLogPageView:@"JMSearchController"];
}
/** 视图完全显示 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 弹出键盘
    [self.searchBar becomeFirstResponder];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//- (instancetype)init {
//    if (self = [super init]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        [self setup];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceHolder:(NSString *)placeHolder didSearchBlock:(JMDidSearchBlock)block {
    JMSearchViewController *searchVC = [self searchViewControllerWithHistorySearchs:historySearchs searchBarPlaceholder:placeHolder];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
    
}
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceholder:(NSString *)placeHolder {
    JMSearchViewController *searchVC = [[JMSearchViewController alloc] init];
    searchVC.historySearchs = historySearchs;
//    searchVC.searchBar.placeholder = placeHolder;
    return searchVC;
}
- (void)loadHistoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/searchhistory/product_search_history",Root_URL];
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
- (void)fetchData:(NSDictionary *)dict {
    NSArray *results = dict[@"results"];
    if (results.count == 0) {
        
    }else {
//        NSDictionary *firstDic = results[0];
//        self.searchBar.placeholder = firstDic[@"content"];
        for (NSDictionary *dic in results) {
            JMSearchHistoryModel *model = [JMSearchHistoryModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
        
    }
    self.searchBar.text = nil;
    [self.collectionView reloadData];
    
    
}

/** 初始化 */
- (void)setup {
//    for (NSString *title in self.historySearchs) {
//        JMSearchHistoryModel *model = [[JMSearchHistoryModel alloc] init];
//        model.title = title;
//        [self.dataSource addObject:model];
//    }
//    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [navRightButton addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    [navRightButton setTitle:@"取消" forState:UIControlStateNormal];
    [navRightButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    navRightButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.mj_x = 10 * 0.5;
    titleView.mj_y = 7;
    titleView.mj_w = self.view.mj_w - 64 - titleView.mj_x * 2;
    titleView.mj_h = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    // 关闭自动调整
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    // 为titleView添加约束来调整搜索框
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeWidth  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeHeight  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *xCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *yCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeLeft  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [titleView addConstraint:widthCons];
    [titleView addConstraint:heightCons];
    [titleView addConstraint:xCons];
    [titleView addConstraint:yCons];
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.searchBar.placeholder = @"请输入搜索关键字";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 0, 15);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT ) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[JMSearchHistoryCell class] forCellWithReuseIdentifier:JMSearchHistoryCellIdentifier];
    [self.collectionView registerClass:[JMSearchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JMSearchHistoryHeaderIdentifier];
//    [self.collectionView reloadData];
    
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMSearchHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMSearchHistoryCellIdentifier forIndexPath:indexPath];
    JMSearchHistoryModel *model  = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMSearchHistoryModel *model = self.dataSource[indexPath.row];
//    if (model.cellWidth > SCREENWIDTH / 2) {
//        return CGSizeMake(SCREENWIDTH, 35);
//    }
    return CGSizeMake(model.cellWidth + 10, 35);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMSearchHistoryModel *model = self.dataSource[indexPath.row];
    self.searchBar.text = model.content;
    [self searchBarSearchButtonClicked:self.searchBar];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return nil;
    }else {
        if (kind == UICollectionElementKindSectionHeader) {
            JMSearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:JMSearchHistoryHeaderIdentifier forIndexPath:indexPath];
            headerView.block = ^(UIButton *button) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除全部历史记录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.delegate = self;
                [alert show];
            };
            return headerView;
        }else {
            return nil;
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(SCREENWIDTH, 50);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self loadClearHistoryData];
    }
}
- (void)loadClearHistoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/searchhistory/clear_search_history",Root_URL];
    NSDictionary *params = @{@"target":@"ModelProduct"};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [MBProgressHUD showSuccess:responseObject[@"info"]];
                [self.dataSource removeAllObjects];
                [self.collectionView reloadData];
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];

}





/** 点击取消 */
- (void)cancelDidClick {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText -- %@",searchText);
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked ");
//    if ([NSString isStringEmpty:searchBar.text]) {
//        searchBar.text = self.searchBar.placeholder;
//    }
    if (self.didSearchBlock) self.didSearchBlock(self, searchBar, searchBar.text);
}



/** 键盘显示完成（弹出） */
- (void)keyboardDidShow:(NSNotification *)noti {
    // 取出键盘高度
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardshowing = YES;
    // 调整搜索建议的内边距
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动时，回收键盘
    if (self.keyboardshowing)  {
        [self.searchBar resignFirstResponder];
    }
}
/** 控制器销毁 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}








@end
























































































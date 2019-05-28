//
//  JMCategoryPageController.m
//  XLMM
//
//  Created by zhang on 17/3/17.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMCategoryPageController.h"
#import "HMSegmentedControl.h"
#import "JMClassifyListController.h"
#import "JMCategorySortingCell.h"

#define JMCategorySortingCellIdentifier @"JMCategorySortingCellIdentifier"
@interface JMCategoryPageController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSString *_titleString;
    NSArray *_menuItems;
    NSArray *_menuImages;
    NSArray *_menuSelectedImages;
    NSInteger _currentIndex;
    NSInteger _currentWithMenuIndex;
    
    UIControl * _backgroundView;
    UICollectionView * _collectionView;
//    UIImageView * _buttomImageView;
    
}

@property (nonatomic, strong) NSArray *titleItems;
@property (nonatomic, strong) NSArray *itemUrls;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) JMClassifyListController *currentClassListVC;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, assign) BOOL isShowMenu;


@end

@implementation JMCategoryPageController
#pragma mark 懒加载
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH * 0.85, 45)];
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.sectionTitles = self.titleItems;
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 2.f;
        _segmentControl.selectionIndicatorColor = [UIColor orangeColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _segmentControl.cs_h - 0.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [UIColor lineGrayColor];
        [_segmentControl addSubview:lineView];
        
    }
    return _segmentControl;
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.delegate = self;
    }
    return _baseScrollView;
}
- (UIButton *)categoryButton {
    if (!_categoryButton) {
        _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_categoryButton setImage:[UIImage imageNamed:@"SortingWithDefault_Selected"] forState:UIControlStateNormal];
        [_categoryButton addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
        _categoryButton.frame = CGRectMake(SCREENWIDTH * 0.85, 64, SCREENWIDTH * 0.15, 45);
        
        _backgroundView = [[UIControl alloc] initWithFrame:CGRectMake(0, self.segmentControl.cs_max_Y, SCREENWIDTH, SCREENHEIGHT - self.segmentControl.cs_max_Y)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgroundView.opaque = NO;
        [_backgroundView addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREENWIDTH , 60);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.segmentControl.cs_max_Y, SCREENWIDTH, 0) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[JMCategorySortingCell class] forCellWithReuseIdentifier:JMCategorySortingCellIdentifier];
        
//        _buttomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
//        _buttomImageView.image = [UIImage imageNamed:@"icon_chose_bottom"];
        
        
    }
    return _categoryButton;
}
- (void)setSectionItems:(NSArray *)sectionItems {
    _sectionItems = sectionItems;
    if (sectionItems.count == 0) {
        return;
    }
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *urls = [NSMutableArray array];
    [urls addObject:[self setUrlData:sectionItems[0][@"parent_cid"]]];
    [titles addObject:@"全部"];
    for (NSDictionary *dic in sectionItems) {
        [titles addObject:dic[@"name"]];
        NSArray *cidArr = [self setUrlData:dic[@"cid"]];
        [urls addObject:cidArr];
    }
    self.titleItems = [titles mutableCopy];
    self.itemUrls = [urls mutableCopy];
}
- (NSArray *)setUrlData:(NSString *)cid {
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@", Root_URL,cid];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?order_by=price&cid=%@", Root_URL,cid];
    NSArray *arr = @[urlStr1,urlStr2];
    return arr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMCategoryPageController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMCategoryPageController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    
    _menuItems = @[@"默认排序",@"价格排序"];
    _menuImages = @[@"SortingWithDefault_Nomarl",@"SortingWithPrice_Nomarl"];
    _menuSelectedImages = @[@"SortingWithDefault_Selected",@"SortingWithPrice_Selected"];
    _currentWithMenuIndex = 0;
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.categoryButton];
    self.segmentControl.selectedSegmentIndex = self.currentIndex;
    [self.view addSubview:self.baseScrollView];
    [self addChildController];
    [self removeToPage:self.currentIndex URLIndex:_currentWithMenuIndex];

}
- (void)addChildController {
    // 移除已经添加的子控制器
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    for (int i = 0 ; i < self.titleItems.count; i++) {
        JMClassifyListController *fineVC = [[JMClassifyListController alloc] init];
        [self addChildViewController:fineVC];
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * self.titleItems.count, self.baseScrollView.frame.size.height);
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    self.isShowMenu = NO;
    NSInteger page = segmentedControl.selectedSegmentIndex;
    _currentIndex = page;
    [self removeToPage:page URLIndex:_currentWithMenuIndex];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    _currentIndex = page;
    //    _lastSelectedIndex = (int)page;
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
    [self removeToPage:page URLIndex:_currentWithMenuIndex];
    
}
- (void)removeToPage:(NSInteger)index URLIndex:(NSInteger)urlIndex {
    if (self.itemUrls.count <= urlIndex) {
        return;
    }
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    JMClassifyListController *itemVC = self.childViewControllers[index];
    self.currentClassListVC = itemVC;
    NSArray *dicUrl = self.itemUrls[index];
    itemVC.urlString = dicUrl[urlIndex];
    itemVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:itemVC.view];
    [itemVC didMoveToParentViewController:self];
    [self.currentClassListVC refresh];
}

#pragma mark ==== 分类排序 点击事件处理,重写 isShowMenu SET方法 控制  UICollectionView 的隐藏于显示
- (void)categoryClick {
    self.isShowMenu = !self.isShowMenu;
}
- (void)setIsShowMenu:(BOOL)isShowMenu {
    if (isShowMenu == _isShowMenu) {
        return ;
    }
    [UIView animateWithDuration:0.2 animations:^() {
        if (isShowMenu) {
            [self.view addSubview:_backgroundView];
            [self.view addSubview:_collectionView];
//            [self.view addSubview:_buttomImageView];
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                _collectionView.cs_h = _menuItems.count * 60.f;;
//                _buttomImageView.cs_y = _collectionView.cs_max_Y - 1;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
                _collectionView.cs_h = 0.f;
//                _buttomImageView.cs_y = _collectionView.cs_max_Y - 1;
            } completion:^(BOOL finish) {
                [_backgroundView removeFromSuperview];
                [_collectionView removeFromSuperview];
//                [_buttomImageView removeFromSuperview];
            }];
        }
    } completion:^(BOOL finish) {
        if (! isShowMenu) {
        }
    }];
    _isShowMenu = isShowMenu;
}

#pragma mark ==== 分类排序 UICollectionView 代理实现 ====
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCategorySortingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMCategorySortingCellIdentifier forIndexPath:indexPath];
    cell.titlLabel.text = _menuItems[indexPath.row];
    if (indexPath.row == _currentWithMenuIndex) {
        cell.titlLabel.textColor = [UIColor buttonEnabledBackgroundColor];
        cell.iconImageView.image = [UIImage imageNamed:_menuSelectedImages[indexPath.row]];
        cell.selectedImageView.hidden = NO;
    }else {
        cell.selectedImageView.hidden = YES;
        cell.titlLabel.textColor = [UIColor buttonTitleColor];
        cell.iconImageView.image = [UIImage imageNamed:_menuImages[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentWithMenuIndex == indexPath.row) {
        return;
    }
    if (self.childViewControllers.count > 0 && self.currentClassListVC) {
        _currentWithMenuIndex = indexPath.row;
        [_collectionView reloadData];
        self.isShowMenu = NO;
        [_categoryButton setImage:[UIImage imageNamed:_menuSelectedImages[_currentWithMenuIndex]] forState:UIControlStateNormal];
        [self removeToPage:_currentIndex URLIndex:_currentWithMenuIndex];
        
    }
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end



































































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
#import "DOPDropDownMenu.h"


@interface JMCategoryPageController () <UIScrollViewDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate> {
    NSString *_titleString;
    NSArray *_menuItems;
    NSArray *_menuImages;
    NSArray *_menuSelectedImages;
    NSInteger _currentIndex;
    NSInteger _currentWithMenuIndex;
}

@property (nonatomic, strong) NSArray *titleItems;
@property (nonatomic, strong) NSArray *itemUrls;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) DOPDropDownMenu *menuView;
@property (nonatomic, strong) JMClassifyListController *currentClassListVC;


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
- (DOPDropDownMenu *)menuView {
    if (!_menuView) {
        _menuView = [[DOPDropDownMenu alloc] initWithOrigin:CGRectMake(SCREENWIDTH * 0.85, 64, SCREENWIDTH * 0.15, 45) andHeight:45];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.segmentType = segmentTypeImage;
        _menuView.selectedImageArray = _menuSelectedImages;
        [_menuView selectDefalutIndexPath];  // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    }
    return _menuView;
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
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [self.view addSubview:self.menuView];
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
    [self.menuView hideMenu];
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



- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return _menuItems.count;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return _menuItems[indexPath.row];
}
- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return _menuImages[indexPath.row];
}
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    menu.itemImageView.image = [UIImage imageNamed:_menuSelectedImages[indexPath.row]];
    if (self.childViewControllers.count > 0 && self.currentClassListVC) {
        _currentWithMenuIndex = indexPath.row;
        [self removeToPage:_currentIndex URLIndex:_currentWithMenuIndex];
        
    }
}







- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end



































































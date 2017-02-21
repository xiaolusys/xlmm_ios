//
//  JMHomeFirstController.m
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeFirstController.h"
#import "HMSegmentedControl.h"
#import "JMMainTableView.h"
#import "JMHomeSegmentCell.h"
#import "JMHomeSegmentView.h"
#import "JMHomeHourController.h"
#import "JMHomeHourModel.h"
#import "JMAutoLoopPageView.h"
#import "JMHomeHeaderCell.h"
#import "JumpUtils.h"
#import "JMHomePageController.h"
#import "UIImage+ColorImage.h"
#import "JMRichTextTool.h"


@interface JMHomeFirstController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, JMAutoLoopPageViewDataSource, JMAutoLoopPageViewDelegate> {
    /**
     *  主页视图滚动位置判断
     */
    BOOL _canScroll;
    BOOL _isTopIsCanNotMoveTabView;
    BOOL _isTopIsCanNotMoveTabViewPre;
    
    BOOL _isPullDown;                        //下拉的标志
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *itemNameArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) UIImageView *currentSelectedItemImageView;
@property (nonatomic, strong) JMHomeSegmentView *segmentView;
@property (nonatomic, strong) JMAutoLoopPageView *pageView;

@property(nonatomic,strong)NSMutableArray *tableViews;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, strong) JMHomePageController *pageVC;
//记录上一个偏移量
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;
//存放button
@property(nonatomic,strong)NSMutableArray *titleButtons;
@property(nonatomic,strong)NSMutableArray *titleLabels;
//记录上一个button
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UILabel *previousLabel;

@end

@implementation JMHomeFirstController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)itemNameArr {
    if (!_itemNameArr) {
        _itemNameArr = [NSMutableArray array];
    }
    return _itemNameArr;
}
- (NSMutableArray *)controllArr {
    if (!_controllArr) {
        _controllArr = [NSMutableArray array];
    }
    return _controllArr;
}
- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}
- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"main"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"main"];
    if (self.pageView) {
        [self.pageView endAutoScroll];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.pageView) {
        [self.pageView removeFromSuperview];
        self.pageView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [[JMGlobal global] clearAllSDCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//     self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    _currentIndex = 0;
//    [self createTabelView];
    
    
    [self.view addSubview:self.tableView];
    
    
    [self createPullHeaderRefresh];
//    [self loadDataSource];
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

//- (void)createUI {
//    [self.view addSubview:self.bottomScrollView];
//    [self.view addSubview:self.pageView];
//    [self.view addSubview:self.segmentedControl];
//
//}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREENHEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell.contentView addSubview:self.bottomScrollView];
    [cell.contentView addSubview:self.segmentScrollView];
    [cell.contentView addSubview:self.pageView];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



- (UIScrollView *)bottomScrollView {
    
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.scrollEnabled = NO;
        
        
        
        
        
    }
    
    return _bottomScrollView;
}
- (JMAutoLoopPageView *)pageView {
    if (!_pageView) {
        _pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 0.4)];
        _pageView.dataSource = self;
        _pageView.delegate = self;
        _pageView.isCreatePageControl = YES;
        [_pageView registerCellWithClass:[JMHomeHeaderCell class] identifier:@"JMHomeHeaderCell"];
        _pageView.scrollStyle = JMAutoLoopScrollStyleHorizontal;
        _pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
        _pageView.scrollForSingleCount = YES;
        _pageView.atuoLoopScroll = YES;
        _pageView.scrollFuture = YES;
        _pageView.autoScrollInterVal = 4.0f;
    }
    return _pageView;
}
//- (HMSegmentedControl *)segmentedControl {
//    if (!_segmentedControl) {
//        
//        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, SCREENWIDTH * 0.4, SCREENWIDTH, 60)];
//        if (self.itemNameArr.count != 0) {
//            self.segmentedControl.sectionTitles = self.itemNameArr;
//        }
//        self.segmentedControl.selectedSegmentIndex = _currentIndex;
//        self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 30, 0, 30);
//        self.segmentedControl.backgroundColor = [UIColor whiteColor];
//        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15.]};
//        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
//        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
//        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
//        self.segmentedControl.selectionIndicatorHeight = 1.0f;
//        self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
//        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
//        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//        //        self.segmentedControl.shouldAnimateUserSelection = NO;
//        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//        //        __weak typeof(self) weakSelf = self;
////        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
//            //            [weakSelf.segmentScrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 80, SCREENWIDTH, SCREENHEIGHT) animated:YES];
////        }];
//        
//    }
//    return _segmentedControl;
//}
- (UIScrollView *)segmentScrollView {
    
    if (!_segmentScrollView) {
        
        _segmentScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH * 0.4, SCREENWIDTH, 60)];
        [_segmentScrollView addSubview:self.currentSelectedItemImageView];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _segmentScrollView;
}
- (UIImageView *)currentSelectedItemImageView {
    if (!_currentSelectedItemImageView) {
        _currentSelectedItemImageView = [[UIImageView alloc] init];
        _currentSelectedItemImageView.image = [UIImage imageWithColor:[UIColor orangeColor] Frame:CGRectMake(0, 0, 80, 2)];
    }
    return _currentSelectedItemImageView;
}







#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }

}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    NSLog(@"%@",self.parentViewController);
//    NSLog(@"%@",scrollView);
//    if (scrollView != self.bottomScrollView) {
//        return ;
//    }
//    if (self.tableView == scrollView) {
//        CGFloat offsetY = self.tableView.contentOffset.y;
//        
//        
//        if (offsetY > 150) {
//            self.pageController.baseScrollView.scrollEnabled = NO;
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                self.pageController.segmentControl.mj_y = 0;
//                self.pageController.baseScrollView.mj_y = 64;
//            }];
////            scrollView.contentOffset = CGPointMake(0, 150);
//        }else {
//            self.pageController.baseScrollView.scrollEnabled = YES;
//            [UIView animateWithDuration:0.3 animations:^{
//                self.pageController.segmentControl.mj_y = 64;
//                self.pageController.baseScrollView.mj_y = 64 + 60;
//            }];
//            
//            
//        }
//        
//    }
//    
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@",change);
    
    UITableView *tableView = (UITableView *)object;
    if (!(self.currentTableView == tableView)) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
//    NSLog(@"%f",tableViewoffsetY);
//    tableView.bounces = NO; // 禁止回弹效果
    self.lastTableViewOffsetY = tableViewoffsetY;
    
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=  SCREENWIDTH * 0.4) {
        self.pageController.baseScrollView.scrollEnabled = YES;
        self.segmentScrollView.frame = CGRectMake(0, SCREENWIDTH * 0.4-tableViewoffsetY - 0, SCREENWIDTH, 60);
        self.pageView.frame = CGRectMake(0, 0-tableViewoffsetY - 0, SCREENWIDTH, SCREENWIDTH * 0.4);
        [UIView animateWithDuration:0.3 animations:^{
            self.pageController.segmentControl.mj_y = 64;
            self.pageController.baseScrollView.mj_y = 64 + 45;
        }];
    }else if( tableViewoffsetY < 0){
        self.segmentScrollView.frame = CGRectMake(0, SCREENWIDTH * 0.4, SCREENWIDTH, 60);
        self.pageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 0.4);
        if (tableViewoffsetY < -60) {
            [self.tableView.mj_header beginRefreshing];
        }
    }else if (tableViewoffsetY > SCREENWIDTH * 0.4){
        self.segmentScrollView.frame = CGRectMake(0, 64 - 64, SCREENWIDTH, 60);
        self.pageView.frame = CGRectMake(0, -SCREENWIDTH * 0.4 - 64, SCREENWIDTH, SCREENWIDTH * 0.4);
        self.pageController.baseScrollView.scrollEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.pageController.segmentControl.mj_y = 0;
            self.pageController.baseScrollView.mj_y = 64;
        }];
        
    }
}

#pragma mark 数据请求
// 请求整点上新数据
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/today",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.itemNameArr removeAllObjects];
        [self.dataSource removeAllObjects];
//        [self.controllArr removeAllObjects];
//        [self.tableViews removeAllObjects];
        [self fetchData:responseObject];
        [self endRefresh];
//        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchData:(NSArray *)dataArray {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    int currentHourInt = [strHour intValue];
    
    for (NSDictionary *itemDic in dataArray) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        NSArray *items = itemDic[@"items"];
        for (NSDictionary *itemD in items) {
            JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:itemD];
            [itemsArr addObject:model];
        }
        [self.dataSource addObject:itemsArr];
        int hourInt = [itemDic[@"hour"] intValue];
        
        NSString *hourStr;
        if (currentHourInt >= hourInt) {
            hourStr = [NSString stringWithFormat:@"%02d:00\n抢购中",hourInt];
        }else {
            hourStr = [NSString stringWithFormat:@"%02d:00\n预热中",hourInt];
        }
        
        [self.itemNameArr addObject:hourStr];
    }
    if (self.itemNameArr.count != 0) {
        if (self.controllArr.count == 0) {
            for (int i = 0; i < self.itemNameArr.count; i++) {
                JMHomeHourController *tableViewController = [[JMHomeHourController alloc] init];
                tableViewController.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT - 64);
                [self.bottomScrollView addSubview:tableViewController.view];
                [self.controllArr addObject:tableViewController];
                [self.tableViews addObject:tableViewController.tableView];
                [self addChildViewController:tableViewController];
                [tableViewController didMoveToParentViewController:self];
                NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
                [tableViewController.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
                
                
            }
            self.bottomScrollView.contentSize = CGSizeMake(self.itemNameArr.count * SCREENWIDTH, 0);
            
            JMHomeHourController *control = self.controllArr[_currentIndex];
            control.dataSource = self.dataSource[_currentIndex];
            self.currentTableView = self.tableViews[_currentIndex];
            self.bottomScrollView.contentOffset = CGPointMake(_currentIndex * SCREENWIDTH, 0);
        }
//        self.segmentedControl.sectionTitles = self.itemNameArr;
        
    }
    
//    [self.titleButtons removeAllObjects];
//    [self.titleLabels removeAllObjects];
    if (self.titleButtons.count == 0) {
        NSInteger btnoffset = 0;
        for (int i = 0; i < self.itemNameArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [btn setTitle:CATEGORY[i] forState:UIControlStateNormal];
            //            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            //            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            //            btn.titleLabel.font = [UIFont systemFontOfSize:FONTMIN];
            //            CGSize size = [UIButton sizeOfLabelWithCustomMaxWidth:SCREEN_WIDTH systemFontSize:FONTMIN andFilledTextString:CATEGORY[i]];
            
            float originX =  i? 10*2+btnoffset:10;
            
            btn.frame = CGRectMake(originX, 0, 80, 60);
            btnoffset = CGRectGetMaxX(btn.frame);
            
            
            //            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:btn];
            
            //        NSString *allPriceString = @"测试";
            //        NSString *allString = [NSString stringWithFormat:@"08:00 \n %@",allPriceString];
            
            
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:18.];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            
            [btn addSubview:label];
            label.text = self.itemNameArr[i];
            NSMutableString * string = self.itemNameArr[i];
            NSString *qianggouStr = [string componentsSeparatedByString:@"\n"][1];
            //        label.textColor = [UIColor buttonTitleColor];
            label.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:12.] AllString:string SubStringArray:@[qianggouStr]];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //            make.centerX.equalTo(btn.mas_centerX);
                //            make.top.equalTo(btn).offset(0);
                make.center.equalTo(btn);
            }];
            
            [self.titleButtons addObject:btn];
            [self.titleLabels addObject:label];
            //contentSize 等于按钮长度叠加
            //默认选中第一个按钮
            if (i == _currentIndex) {
                
                btn.selected = YES;
                //            btn.backgroundColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
                label.textColor = [UIColor orangeColor];
                _previousButton = btn;
                _previousLabel = label;
                
                _currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(btn.frame), self.segmentScrollView.frame.size.height - 2, 80, 2);
            }else {
                label.textColor = [UIColor blackColor];
            }
        }
        
        _segmentScrollView.contentSize = CGSizeMake(btnoffset + 10, 25);
    }
    

    
//    [self.tableView reloadData];

    
//    [self initUI];
//    self.segmentedControl.sectionTitles = self.itemNameArr;
}

//
//#pragma mark 创建tableView
//- (void)createTabelView {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 60) style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[JMHomeSegmentCell class] forCellReuseIdentifier:JMHomeSegmentCellIdentifier];
//    
//    _pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 0.4)];
//    _pageView.dataSource = self;
//    _pageView.delegate = self;
//    _pageView.isCreatePageControl = YES;
//    [_pageView registerCellWithClass:[JMHomeHeaderCell class] identifier:@"JMHomeHeaderCell"];
//    _pageView.scrollStyle = JMAutoLoopScrollStyleHorizontal;
//    _pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
//    _pageView.scrollForSingleCount = YES;
//    _pageView.atuoLoopScroll = YES;
//    _pageView.scrollFuture = YES;
//    _pageView.autoScrollInterVal = 4.0f;
//    
//    self.tableView.tableHeaderView = _pageView;
//
//}
//
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return (SCREENHEIGHT - 64);
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    JMHomeSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeSegmentCellIdentifier];
//    if (!cell) {
//        cell = [[JMHomeSegmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeSegmentCellIdentifier];
//    }
//    if (self.itemNameArr.count != 0) {
//        [cell addSubview:self.segmentView];
//    }
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 60.f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
//    if (self.itemNameArr.count != 0) {
//        self.segmentedControl.sectionTitles = self.itemNameArr;
//    }
//    self.segmentedControl.selectedSegmentIndex = _currentIndex;
//    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
//    self.segmentedControl.backgroundColor = [UIColor whiteColor];
//    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13.]};
//    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
//    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
//    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
//    self.segmentedControl.selectionIndicatorHeight = 1.0f;
//    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
//    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
//    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    //        self.segmentedControl.shouldAnimateUserSelection = NO;
//    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    //        __weak typeof(self) weakSelf = self;
//    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
//        //            [weakSelf.segmentScrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 80, SCREENWIDTH, SCREENHEIGHT) animated:YES];
//    }];
//    return self.segmentedControl;
//}
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
//    _currentIndex = segmentedControl.selectedSegmentIndex;
//    [self.segmentedControl setSelectedSegmentIndex:_currentIndex animated:YES];
////    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
////    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
////    [self.tableView reloadData];
//    self.bottomScrollView.contentOffset = CGPointMake(_currentIndex * SCREENWIDTH, 0);
//    JMHomeHourController *control = self.controllArr[_currentIndex];
//    self.currentTableView = self.tableViews[_currentIndex];
//    
//    for (UITableView *tableView in self.tableViews) {
//        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=SCREENWIDTH * 0.4) {
//            
//            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
//            
//        }else if(self.lastTableViewOffsetY < 0){
//            
//            tableView.contentOffset = CGPointMake(0, 0);
//            
//        }else if ( self.lastTableViewOffsetY > SCREENWIDTH * 0.4){
//            tableView.contentOffset = CGPointMake(0, self.lastTableViewOffsetY);
////            tableView.contentOffset = CGPointMake(0, SCREENWIDTH * 0.4);
////            tableView.contentOffset = CGPointMake(0, 0);
//        }
//    }
//    
//    
//    control.tableView = self.currentTableView;
//    control.dataSource = self.dataSource[_currentIndex];
//    
//    
//    
//    
//}

#pragma  mark - 选项卡点击事件

- (void)changeSelectedItem:(UIButton *)currentButton {
    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    _currentIndex = [self.titleButtons indexOfObject:currentButton];
    self.bottomScrollView.contentOffset = CGPointMake(SCREENWIDTH *_currentIndex, 0);
    UILabel *currentLabel = self.titleLabels[_currentIndex];
    _previousLabel.textColor = [UIColor blackColor];
    currentLabel.textColor = [UIColor orangeColor];
    _previousLabel = currentLabel;
    
    JMHomeHourController *control = self.controllArr[_currentIndex];
    self.currentTableView = self.tableViews[_currentIndex];
    control.tableView = self.currentTableView;
    control.dataSource = self.dataSource[_currentIndex];
    
//    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=SCREENWIDTH * 0.4) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > SCREENWIDTH * 0.4){
            
            tableView.contentOffset = CGPointMake(0, self.lastTableViewOffsetY);
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (_currentIndex == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(10, self.segmentScrollView.frame.size.height - 2,80, 2);
            
        }else{
            
            
            UIButton *preButton = self.titleButtons[_currentIndex - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-10*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
        
        
    }];
}



#pragma mark 添加segmentViewController
//- (JMHomeSegmentView *)segmentView {
//    if (!_segmentView) {
//        self.controllArr = [NSMutableArray array];
//        for (int i = 0; i < self.itemNameArr.count; i ++) {
//            JMHomeHourController *hourVC = [[JMHomeHourController alloc] init];
//            [self.controllArr addObject:hourVC];
//        }
//        self.segmentView = [[JMHomeSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) DataSource:self.dataSource Controllers:self.controllArr TitleArray:self.itemNameArr PageController:self];
//    }
//    return _segmentView;
//    
//}
#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return self.topImageArray.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMHomeHeaderCell *testCell = cell;
    NSDictionary *dict = self.topImageArray[index];
    testCell.topDic = dict;
}
- (NSString *)cellIndentifierWithIndex:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    return @"JMHomeHeaderCell"; // 返回自定义cell的identifier
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidScrollToIndex:(NSUInteger)index {
    //    NSLog(@"JMHomeRootController ---> pageView滚动");
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index {
    [MobClick event:@"banner_click"];
    NSDictionary *topDic = _topImageArray[index];
    [JumpUtils jumpToLocation:topDic[@"app_link"] viewController:self];
}










@end



























































































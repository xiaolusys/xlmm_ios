//
//  JMAutoLoopPageView.m
//  XLMM
//
//  Created by zhang on 16/9/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAutoLoopPageView.h"
#import "JMPageControl.h"


#define DataSourceItemCount [self.dataSource numberOfItemWithPageView:self]
// 默认indentifier
static NSString *const kDefaultCellIdentifier = @"kDefaultCellIdentifier";
// 默认 滚动间隔
static CGFloat const kDefaultautoScrollTimeInterval = 5.f;

@interface JMAutoLoopPageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSUInteger _realPageIndex;                      // pageIndex
    BOOL _isScrolling;                              // 是否在滚动
    BOOL _isWaitingToChangeScrollDirection;         // 是否等待改变滚动方向
    JMAtuoLoopScrollViewStyle _tempDirection;       // 滚动方向
    BOOL _isRealyPageControl;                       // 是否已经给pageNumber赋值
}

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) JMPageControl *systemPageCtrol;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JMAutoLoopPageView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //兼容横竖屏切换
    [self.mainCollectionView.collectionViewLayout invalidateLayout];
    
    self.mainCollectionView.frame = self.bounds;
    if (DataSourceItemCount > 0) {
        //调整位置
        [self scrollToIndex:self.currentIndex animated:NO];
    }
    
}
//视图消失时停止计时器，否则无法释放
- (void)removeFromSuperview {
    [super removeFromSuperview];
    if (self != nil) {
        [self endAutoScroll];
    }
    
}
//当视图出现时判断是否要自动滚
- (void)didMoveToWindow {
    [super didMoveToWindow];
    if ([self canAutoScroll]) {
        [self beginAutoScroll];
    }
}

#pragma mark - Initialize
//初始化
- (void)initSelf {
    _scrollStyle = JMAutoLoopScrollStyleHorizontal;
    _scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
    _autoScrollInterVal = kDefaultautoScrollTimeInterval;
    _pageEnable = YES;
    _scrollForSingleCount = YES;
    _scrollUserEnable = YES;
    _scrollFuture = YES;
    _isRealyPageControl = NO;
    [self addSubview:self.mainCollectionView];
}
- (void)setIsCreatePageControl:(BOOL)isCreatePageControl {
    _isRealyPageControl = isCreatePageControl;
    if (_isRealyPageControl) {
        [self addSubview:self.systemPageCtrol];
        [self insertSubview:self.systemPageCtrol aboveSubview:self.mainCollectionView];
    }
}
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.scrollsToTop = NO;
    }
    return _mainCollectionView;
}
- (JMPageControl *)systemPageCtrol {
    if (!_systemPageCtrol) {
        self.systemPageCtrol = [[JMPageControl alloc] init];
        self.systemPageCtrol.frame = CGRectMake(0, self.mj_h  - 30, self.mj_w, 20);
        self.systemPageCtrol.enabled = NO;
        //    [self.systemPageCtrl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
        UIView *nomalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
        nomalView.backgroundColor = [UIColor buttonDisabledBorderColor];
        selectedView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.systemPageCtrol.normalPageView = nomalView;
        self.systemPageCtrol.currentPageView = selectedView;
        self.systemPageCtrol.padding = 10;
    }
    return _systemPageCtrol;
}
- (void)setScrollStyle:(JMAtuoLoopScrollViewStyle)scrollStyle {
    // 处理滚动时换方向的问题
    if (scrollStyle != _scrollStyle && _isScrolling) {
        _isWaitingToChangeScrollDirection = YES;
        _tempDirection = scrollStyle;
        return ;
    }
    _scrollStyle = scrollStyle;
    [(UICollectionViewFlowLayout *)self.mainCollectionView.collectionViewLayout setScrollDirection:scrollStyle == JMAutoLoopScrollStyleHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical];
    
}
- (void)setPageEnable:(BOOL)pageEnable {
    _pageEnable = pageEnable;
    self.mainCollectionView.pagingEnabled = _pageEnable;
}
- (void)setScrollForSingleCount:(BOOL)scrollForSingleCount {
    _scrollForSingleCount = scrollForSingleCount;
    // 设置后需要重新加载才可以
    [self reloadData];
}
- (void)setAtuoLoopScroll:(BOOL)atuoLoopScroll {
    _atuoLoopScroll = atuoLoopScroll;
    if ([self canAutoScroll]) {
        [self beginAutoScroll];
    }else {
        [self endAutoScroll];
    }
    
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterVal target:self selector:@selector(didTimeGo:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setAutoScrollInterVal:(CGFloat)autoScrollInterVal {
    _autoScrollInterVal = autoScrollInterVal;
    if ([self canAutoScroll]) {
        //设置时间后要重新生成timer
        [self restartAutoScroll];
    }
}

- (void)setScrollUserEnable:(BOOL)scrollUserEnable {
    _scrollUserEnable = scrollUserEnable;
    self.mainCollectionView.scrollEnabled = _scrollUserEnable;
}
- (void)setScrollFuture:(BOOL)scrollFuture {
    _scrollFuture = scrollFuture;
    [self reloadData];
}

#pragma mark 注册cell
- (void)registerCellWithClass:(Class)cellClass identifier:(NSString *)identifier {
    [self.mainCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}
- (void)registerCellWithClass:(Class)cellClass {
    [self registerCellWithClass:cellClass identifier:kDefaultCellIdentifier];
}
- (void)registerCellWithNib:(UINib *)cellNib identifier:(NSString *)identifier {
    [self.mainCollectionView registerNib:cellNib forCellWithReuseIdentifier:identifier];
}
- (void)registerCellWithNib:(UINib *)cellNib {
    [self registerCellWithNib:cellNib identifier:kDefaultCellIdentifier];
}

- (void)reloadData {
    [self.mainCollectionView reloadData];
    // 数据清空
    if (DataSourceItemCount == 0) {
        _currentIndex = 0;
        _realPageIndex = 0;
        _isScrolling = NO;
        _isWaitingToChangeScrollDirection = NO;
        [self.mainCollectionView setContentOffset:CGPointZero animated:NO];
    }else if (self.currentIndex > DataSourceItemCount - 1) { // 如果当前页大于最大页则重置为最大页
        _currentIndex = DataSourceItemCount - 1;
        [self scrollToIndex:self.currentIndex animated:NO];
    }
    if (self.currentIndex != _realPageIndex) {   //如果当前输出的页码和实际的页码不同重置为当前输出页码
        _realPageIndex = self.currentIndex;
        [self scrollToIndex:self.currentIndex animated:NO];
    }
    if ([self canAutoScroll]) { //判断是否能够自动滚能的话开启，不能的话关闭
        [self beginAutoScroll];
    }else {
        [self endAutoScroll];
    }

    self.systemPageCtrol.numberOfPages = DataSourceItemCount;

}
- (void)setPageCtrlCurrentPage:(NSInteger)currentPage {
    if (self.systemPageCtrol) {
        self.systemPageCtrol.currentPage = currentPage;
    }
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    
//    if (self.dataSource == nil) {
//        return ;
//    }
    
    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    //提示:此处可能存在越界崩溃,可以试试注释上面的方法打开下面的方法来急救
    //    CGPoint contentOffset = {0,0};
    //    if (self.scrollDirection == JJCyclePageViewScrollDirectionHorizontal) {
    //        contentOffset.x = index * self.bounds.size.width;
    //    }
    //    if (self.scrollDirection == JJCyclePageViewScrollDirectionVertical) {
    //        contentOffset.y = index * self.bounds.size.height;
    //    }
    //    [self.mainCollectionView setContentOffset:contentOffset animated:animated];
    
    
}



#pragma mark 滚动事件处理
//根据pageIndex获取对应offset，区分滚动方向
- (CGPoint)contentOffsetForIndex:(NSUInteger)index {
    return self.scrollStyle == JMAutoLoopScrollStyleHorizontal ? CGPointMake(index * [self boundsWidth], 0.f) : CGPointMake(0.f, index * [self boundsHeight]);
}

//根据真实的index获取输出到外部的index
- (NSUInteger)outputIndexForRealIndex:(NSUInteger)realIndex {
    return realIndex == DataSourceItemCount ? 0 : realIndex;
}

//根据offset获取真实的index，区分滚动方向
- (NSUInteger)realIndexForContentOffset:(CGPoint)contentOffset {
    return self.scrollStyle == JMAutoLoopScrollStyleHorizontal ? round(contentOffset.x / [self boundsWidth]) : round(contentOffset.y / [self boundsHeight]);
}

//单位宽
- (CGFloat)boundsWidth {
    return self.mainCollectionView.bounds.size.width;
}

//单位高
- (CGFloat)boundsHeight {
    return self.mainCollectionView.bounds.size.height;
}

//开始自动滚
- (void)beginAutoScroll {
    if (!_timer) {
//        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//结束自动滚
- (void)endAutoScroll {
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//判断是否能滚
- (BOOL)canScroll {
    return DataSourceItemCount != 0 && !(!self.scrollForSingleCount && DataSourceItemCount == 1);
}

//是否能自动滚
- (BOOL)canAutoScroll {
    //要自动滚 & 出现在window上 & 能滚
    return self.atuoLoopScroll && self.window && [self canScroll] && self.autoScrollInterVal > 0;
}

//重启自动滚动
- (void)restartAutoScroll {
    if (_timer) {
        [self endAutoScroll];
        [self beginAutoScroll];
    }
}

//结束滚动时的处理
- (void)handleScrollingEnd {
    _isScrolling = NO;
    if (_isWaitingToChangeScrollDirection) {
        self.scrollStyle = _tempDirection;
        _isWaitingToChangeScrollDirection = NO;
    }
}

//处理滚动开始
- (void)handleScrolling {
    _isScrolling = YES;
}

- (void)didTimeGo:(NSTimer *)timer {
    NSUInteger nextPageIndex = self.currentIndex;
    
    switch (self.scrollDirectionStyle) {
        case JMAutoLoopScrollStyleAscending: {
            nextPageIndex ++;
            
            //如果应该滚到世界尽头
            if (self.scrollFuture) {
                //如果处于真实的最后一个，且下一个是输出的第二个
                if (_realPageIndex == DataSourceItemCount) {
                    //移动到输出的第一个
                    self.mainCollectionView.contentOffset = [self contentOffsetForIndex:0];
                }
            }else {
                if (nextPageIndex >= DataSourceItemCount) {
                    nextPageIndex = 0;
                }
            }
            
        }
            break;
        case JMAutoLoopScrollStyleDescending: {
            //如果处于第一个
            if (self.currentIndex == 0) {
                
                nextPageIndex = DataSourceItemCount - 1;
                
                //如果应该滚到世界尽头
                if (self.scrollFuture) {
                    //移动到真实的最后一个
                    self.mainCollectionView.contentOffset = [self contentOffsetForIndex:DataSourceItemCount];
                }
                
            }
            else {
                nextPageIndex --;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    [self scrollToIndex:nextPageIndex animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = DataSourceItemCount;
    //判断是否是无限滚动模式
    return [self canScroll] && self.scrollFuture ? count + 1: count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger outputIndex = [self outputIndexForRealIndex:indexPath.row];
    
    NSString *identifier = kDefaultCellIdentifier;
    if ([self.dataSource respondsToSelector:@selector(cellIndentifierWithIndex:PageView:)]) {
        identifier = [self.dataSource cellIndentifierWithIndex:outputIndex PageView:self];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [self.dataSource configCell:cell Index:outputIndex PageView:self];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //如果没有数据就不进行位置调整
    if (DataSourceItemCount <= 0) {
        return;
    }
    
    [self handleScrolling];
    
    //设置真实的pageindex
    _realPageIndex = [self realIndexForContentOffset:scrollView.contentOffset];
    
    //如果应该滚到世界尽头
    if (self.scrollFuture) {
        switch (self.scrollStyle) {
                //横向滚动
            case JMAutoLoopScrollStyleHorizontal:
            {
                //往左滚到头
                if (scrollView.contentOffset.x < 0.f) {
                    CGPoint contentOffset = [self contentOffsetForIndex:DataSourceItemCount];
                    contentOffset.x += scrollView.contentOffset.x - 0.f;
                    scrollView.contentOffset = contentOffset;
                    return;
                }
                //往右滚到头
                if (scrollView.contentOffset.x > scrollView.contentSize.width - 1 * [self boundsWidth]) {
                    CGPoint contentOffset = [self contentOffsetForIndex:0];
                    contentOffset.x += scrollView.contentOffset.x - (scrollView.contentSize.width - 1 * [self boundsWidth]);
                    scrollView.contentOffset = contentOffset;
                    return;
                }
            }
                break;
                //竖直滚动
            case JMAutoLoopScrollStyleVertical:
            {
                //往上滚到头
                if (scrollView.contentOffset.y < 0.f) {
                    CGPoint contentOffset = [self contentOffsetForIndex:DataSourceItemCount];
                    contentOffset.y += scrollView.contentOffset.y - 0.f;
                    scrollView.contentOffset = contentOffset;
                    return;
                }
                //往下滚到头
                if (scrollView.contentOffset.y > scrollView.contentSize.height - 1 * [self boundsHeight]) {
                    CGPoint contentOffset = [self contentOffsetForIndex:0];
                    contentOffset.y += scrollView.contentOffset.y - (scrollView.contentSize.height - 1 * [self boundsHeight]);
                    scrollView.contentOffset = contentOffset;
                    return;
                }
            }
                break;
            default:
                break;
                
        }
    }
    
    //设置outputpageindex
    NSUInteger pageIndex = [self outputIndexForRealIndex:_realPageIndex];
    [self setPageCtrlCurrentPage:pageIndex];
    if (pageIndex != _currentIndex) {
        _currentIndex = pageIndex;
        if ([self.delegate respondsToSelector:@selector(JMAutoLoopPageView:DidScrollToIndex:)]) {
            [self.delegate JMAutoLoopPageView:self DidScrollToIndex:pageIndex];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //拖拽时销毁timer
    [self endAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //结束拖拽创建timer
    if ([self canAutoScroll]) {
        [self beginAutoScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScrollingEnd];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollingEnd];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(JMAutoLoopPageView:DidSelectedIndex:)]) {
        [self.delegate JMAutoLoopPageView:self DidSelectedIndex:[self outputIndexForRealIndex:indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}


@end





































































































//
//  JMAutoLoopScrollView.m
//  滚动视图封装
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "JMAutoLoopScrollView.h"
#import "JMTimerWeakTarget.h"
#import "JMRollView.h"

#define kWIDTH self.bounds.size.width
#define kHEIGHT self.bounds.size.height

@interface JMAutoLoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, weak) JMRollView *rollView1;
@property (nonatomic, weak) JMRollView *rollView2;
@property (nonatomic, weak) JMRollView *rollView3;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) NSUInteger totlaPage;

@property (nonatomic, assign, getter=isApper) BOOL appear;

@property (nonatomic, assign) Class contentClass;
@property (nonatomic, strong) UINib *contentNib;


@end

@implementation JMAutoLoopScrollView {
    BOOL _isInitLayoutSubviews;
}
- (instancetype)initWithStyle:(JMAutoLoopScrollViewStyle)style {
    if (self = [super init]) {
        _jm_scrollStyle = style;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [super setDelegate:self];
        [self createUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [super setDelegate:self];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    self.jm_isAutoLoopScroll = YES;
    self.jm_autoScrollInterval = 3.0;
    self.totlaPage = 0;
    _jm_scrollStyle = JMAutoLoopScrollStyleVertical;
    self.delegate = self;
    
}

- (void)createRollView {
    JMRollView *rollView1 = nil;
    JMRollView *rollView2 = nil;
    JMRollView *rollView3 = nil;
    
    if (self.contentNib) {
        rollView1 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
        rollView2 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
        rollView3 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
    }else if (self.contentClass) {
        rollView1 = [[self.contentClass alloc] init];
        rollView2 = [[self.contentClass alloc] init];
        rollView3 = [[self.contentClass alloc] init];
    }
    [self addSubview:rollView1];
    [self addSubview:rollView2];
    [self addSubview:rollView3];
    
    self.rollView1 = rollView1;
    self.rollView2 = rollView2;
    self.rollView3 = rollView3;
    
    self.rollView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jm_viewTap:)];
    [self.rollView2 addGestureRecognizer:tap];
    
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    self.appear = YES;
    NSUInteger count = [self.jm_scrollDataSource jm_numberOfNewViewInScrollView:self];
    if (count) {
        [self dealAotuScrollTimer];
    }
    
}

- (void)layoutSubviews {

    if (!_isInitLayoutSubviews) {
        if (self.jm_scrollStyle == JMAutoLoopScrollStyleVertical) {
            self.contentOffset = CGPointMake(0, kHEIGHT);
            [self reloadNewsData];
            
            self.rollView1.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
            self.rollView2.frame = CGRectMake(0, kHEIGHT, kWIDTH, kHEIGHT);
            self.rollView3.frame = CGRectMake(0, kHEIGHT * 2, kWIDTH, kHEIGHT);
            self.contentSize = CGSizeMake(kWIDTH, kHEIGHT * 3);
        }else if (self.jm_scrollStyle == JMAutoLoopScrollStyleHorizontal) {
            self.contentOffset = CGPointMake(kWIDTH, 0);
            [self reloadNewsData];
            
            self.rollView1.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
            self.rollView2.frame = CGRectMake(kWIDTH, 0, kWIDTH, kHEIGHT);
            self.rollView3.frame = CGRectMake(kWIDTH * 2, 0, kWIDTH, kHEIGHT);
            self.contentSize = CGSizeMake(kWIDTH * 3, kHEIGHT);
        }
        _isInitLayoutSubviews = YES;
    }
    [super layoutSubviews];
}
- (void)dealloc {
    [self.autoScrollTimer invalidate];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.autoScrollTimer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self dealAotuScrollTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = self.contentOffset.x;
    NSUInteger page;
    
    CGPoint offsetPoint = CGPointZero;
    
    if (self.jm_scrollStyle == JMAutoLoopScrollStyleVertical) {
        offsetPoint = CGPointMake(0, kHEIGHT);
        page = offsetY / CGRectGetHeight(self.frame);
    }else if (self.jm_scrollStyle == JMAutoLoopScrollStyleHorizontal) {
        offsetPoint = CGPointMake(kWIDTH, 0);
        page = offsetX / CGRectGetWidth(self.frame);
    }else {}
    
    if (page == 0) {
        //向左
        self.currentPage = _currentPage == 0 ? (self.totlaPage - 1) : _currentPage - 1;
    }else if (page == 2){
        //向右
        self.currentPage = _currentPage == (self.totlaPage - 1) ? 0 : _currentPage + 1;
    }
    
    [self reloadNewsData];
    
    //将content offset设为第二页的偏移量，即，展示的永远是scrollview中第二页的偏移位置的图片
    self.contentOffset = offsetPoint;
}

- (void)createAutoScrollTimer {
    if (!_autoScrollTimer.isValid) {
        JMTimerWeakTarget *target = [[JMTimerWeakTarget alloc] initWithTarget:self selector:@selector(autoScrollTimerFire:)];
        _autoScrollTimer = [NSTimer timerWithTimeInterval:self.jm_autoScrollInterval
                                                   target:target
                                                 selector:@selector(timerDidFire:)
                                                 userInfo:nil
                                                  repeats:YES
                            ];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)autoScrollTimerFire:(NSTimer *)timer {
    
    CGPoint offsetPoint = CGPointZero;
    
    if (self.jm_scrollStyle == JMAutoLoopScrollStyleVertical) {
        
        offsetPoint = CGPointMake(0, 2 * kHEIGHT);
        
    } else if (self.jm_scrollStyle == JMAutoLoopScrollStyleHorizontal) {
        
        offsetPoint = CGPointMake(2 * kWIDTH, 0);
    }else {}
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.contentOffset = offsetPoint;
                     }
                     completion:^(BOOL finished) {
                         [self scrollViewDidEndDecelerating:self];
                     }];
}


- (void)jm_reloadData {
    
    NSUInteger count = [self.jm_scrollDataSource jm_numberOfNewViewInScrollView:self];
    self.totlaPage = count;
    if (_currentPage > count - 1) {
        _currentPage = count - 1;
    }
    
    if (count && self.isApper) {
        
        [self dealAotuScrollTimer];
    }
    
    [self reloadNewsData];
    
}
- (void)jm_registerNib:(UINib *)contentNib {
    
    self.contentNib = contentNib;
    self.contentClass = nil;
    
    [self checkContentClass:[[contentNib instantiateWithOwner:nil options:nil].firstObject class]];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createRollView];
}

- (void)jm_registerClass:(Class)contentClass {
    
    self.contentClass = contentClass;
    self.contentNib = nil;
    
    [self checkContentClass:contentClass];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createRollView];
}

- (void)checkContentClass:(Class)contentClass {
    
    if (![contentClass isSubclassOfClass:[JMRollView class]] ) {
        
        NSException *e = [NSException
                          exceptionWithName: [NSString stringWithFormat:@"%s %@ not fount", __func__, contentClass]
                          reason: @"lp_contentViewClass 不是 LPContentView 的子类,请继承 LPContentView"
                          userInfo: nil];
        @throw e;
        
    }
}
- (void)reloadNewsData {
    
    if (!self.totlaPage) return;
    
    [self.jm_scrollDataSource jm_scrollView:self newViewIndex:_currentPage forRollView:self.rollView2];
    [self.jm_scrollDataSource jm_scrollView:self newViewIndex:_currentPage == (self.totlaPage - 1) ? 0 : _currentPage + 1 forRollView:self.rollView3];
    [self.jm_scrollDataSource jm_scrollView:self newViewIndex:_currentPage == 0 ? (self.totlaPage - 1) : _currentPage - 1 forRollView:self.rollView1];
    
    if ([self.jm_scrollDelegate respondsToSelector:@selector(jm_scrollView:didDidScrollToPage:)]) {
        [self.jm_scrollDelegate jm_scrollView:self didDidScrollToPage:self.currentPage];
    }
}

- (void)dealAotuScrollTimer {
    [self.autoScrollTimer invalidate];
    
    if (self.jm_isAutoLoopScroll) {
        if (self.jm_isStopScrollForSingleCount && self.totlaPage == 1) return;
        [self createAutoScrollTimer];
    }
    
}


- (void)jm_viewTap:(UITapGestureRecognizer *)tap {
    if (!self.totlaPage) return;
    
    if ([self.jm_scrollDelegate respondsToSelector:@selector(jm_scrollView:didSelectedIndex:)]){
        [self.jm_scrollDelegate jm_scrollView:self didSelectedIndex:self.currentPage];
    }
}



- (void)setJm_autoScrollInterval:(CGFloat)jm_autoScrollInterval {
    _jm_autoScrollInterval = _jm_autoScrollInterval > 1 ? jm_autoScrollInterval : 1.5;
}

- (void)setJm_scrollDataSource:(id<JMAutoLoopScrollViewDatasource>)jm_scrollDataSource {
    _jm_scrollDataSource = jm_scrollDataSource;
    [self jm_reloadData];
}
- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    if (delegate != self) {
        self.myDelegate = delegate;
    } else {
        [super setDelegate:self];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;
    
    return [self.myDelegate respondsToSelector:aSelector];
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.myDelegate;
}






@end






















































































































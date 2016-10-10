//
//  JMMaMaCenterFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaCenterFansController.h"
#import "MMClass.h"
#import "JMNowFansController.h"
#import "JMFetureFansController.h"
#import "JMAboutFansController.h"



@interface JMMaMaCenterFansController () 

@property (nonatomic, strong)UIView *headerV;
@property (nonatomic, strong)UIView *btnView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *tableViewArr;
@property (nonatomic, strong)NSMutableArray *urlArr;


@property (nonatomic, strong)NSMutableArray *pageContent;
@property (nonatomic, strong)NSMutableArray *btnArr;

@end

@implementation JMMaMaCenterFansController {
    NSInteger _pageCurrentIndex;
    NSInteger _currentIndex;
    NSString *_badgeValue;
}
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        self.btnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArr;
}
- (NSMutableArray *)pageContent {
    if (_pageContent == nil) {
        _pageContent = [NSMutableArray array];
    }
    return _pageContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"粉丝列表" selecotr:@selector(btnClicked:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createPageView];
    [self createFansBtn];
    _badgeValue = @"";
    //判断页数
    for (UIButton *btn in self.btnArr) {
        if (btn.tag == self.index) {
            [self titleBtnClickAction:btn];
            break;
        }
    }

    
}

- (void)createPageView {
    self.pageControll = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageControll.view.frame = CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT - 104);
    self.pageControll.view.userInteractionEnabled = YES;
    self.pageControll.dataSource = self;
    self.pageControll.delegate = self;
    NSArray *classArr = [self classArr];
    for (int i = 0; i < classArr.count; i++) {
        NSString *className = [NSString stringWithFormat:@"%@",classArr[i]];
        Class cls = NSClassFromString(className);
        JMPageViewBaseController *VC = [[cls alloc] init];
        VC.fansUrlString = self.fansUrlStr;
        [self.pageContent addObject:VC];
        
    }
//    JMNowFansController *newFans = [[JMNowFansController alloc] init];
//    JMFetureFansController *fetureFans = [[JMFetureFansController alloc] init];
//    JMAboutFansController *aboutFans = [[JMAboutFansController alloc] init];
//    self.pageContent = @[newFans, fetureFans, aboutFans];
    [self.pageControll setViewControllers:@[self.pageContent[0]] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:self.pageControll];
    [self.view addSubview:self.pageControll.view];
    [self.pageControll didMoveToParentViewController:self];
    for (UIView *v in  self.pageControll.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
    
    
    
}
- (NSArray *)classArr {
    return @[@"JMNowFansController",@"JMFetureFansController",@"JMAboutFansController"];
}
- (NSArray *)titleArr {
    return @[@"粉丝列表", @"未来粉丝", @"关于粉丝"];
}
- (void)createFansBtn {
    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    
    //创建button
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    UIView *btnlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    btnlineView.backgroundColor = [UIColor lightGrayColor];
    btnlineView.alpha = 0.3;
    [self.btnView addSubview:btnlineView];
    [self.headerV addSubview:self.btnView];
    
    
    NSArray *nameArr = [self titleArr];
    CGFloat buttonW = SCREENWIDTH / nameArr.count;
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * buttonW, 0, buttonW, 39);
        btn.titleLabel.font =  [UIFont systemFontOfSize: 14];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btn];
        [self.btnArr addObject:btn];
        
    }
    [self.view addSubview:self.headerV];
}
- (void)loadData {
    
}
- (void)titleBtnClickAction:(UIButton *)btn {
    
    NSInteger btnTag = btn.tag;
    _currentIndex = btnTag - 100;
    [self changeBtnSelect:_currentIndex];
    
    BOOL state = 0;
    if (_pageCurrentIndex < _currentIndex) {
        state = 1;
    }
    _pageCurrentIndex = _currentIndex;
    [self.pageControll setViewControllers:@[[self.pageContent objectAtIndex:_currentIndex]] direction:state?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}
- (void)changeBtnSelect:(NSInteger)btnTag {
    for (UIButton *button in self.btnArr) {
        if ((button.tag - 100) == btnTag) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
}
- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --pageViewControll代理方法
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    _currentIndex = [self.pageContent indexOfObject:viewController];
    if (_currentIndex < self.pageContent.count - 1) {
        _pageCurrentIndex = _currentIndex + 1;
        return [self.pageContent objectAtIndex:_pageCurrentIndex];
    } else{
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    _currentIndex = [self.pageContent indexOfObject:viewController];
    if (_currentIndex > 0) {
        _pageCurrentIndex = _currentIndex - 1;
        return [self.pageContent objectAtIndex:_pageCurrentIndex];
    } else{
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _currentIndex  = [self.pageContent indexOfObject:pageViewController.viewControllers[0]];
    if (completed)
    {
        [self changeBtnSelect:_currentIndex];
    }else
    {
        if (finished)
        {
            [self changeBtnSelect:_currentIndex];
        }
    }
    
}
@end












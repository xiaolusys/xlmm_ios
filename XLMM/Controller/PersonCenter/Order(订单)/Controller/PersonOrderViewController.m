//
//  PersonOrderViewController.m
//  XLMM
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PersonOrderViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "PersonCenterViewController1.h"
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"

#define BTNWIDTH (SCREENWIDTH/3)

@interface PersonOrderViewController ()
@property (nonatomic, strong)UIView *headerV;
@property (nonatomic, strong)UIView *btnView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *tableViewArr;
@property (nonatomic, strong)NSMutableArray *urlArr;

@property (nonatomic, strong)UIPageViewController *pageControll;
@property (nonatomic, strong)NSArray *pageContent;
@property (nonatomic, strong)NSMutableArray *btnArr;

@end

static NSString *identifier = @"orderStatic";
@implementation PersonOrderViewController
{
    NSInteger _pageCurrentIndex;
    NSInteger _currentIndex;
}
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        self.btnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBarWithTitle:@"全部订单" selecotr:@selector(btnClicked:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createOrderBtn];
    [self createPageView];
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
    self.pageControll.view.frame = CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99);
    self.pageControll.view.userInteractionEnabled = YES;
    self.pageControll.dataSource = self;
    self.pageControll.delegate = self;
    PersonCenterViewController3 *allOrder = [[PersonCenterViewController3 alloc] initWithNibName:@"PersonCenterViewController3" bundle:nil];
    PersonCenterViewController2 *waitReceive = [[PersonCenterViewController2 alloc] initWithNibName:@"PersonCenterViewController2" bundle:nil];
    PersonCenterViewController1 *noPay = [[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:[NSBundle mainBundle]];
    self.pageContent = @[allOrder, noPay, waitReceive];
    [self.pageControll setViewControllers:@[allOrder] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:self.pageControll];
    [self.view addSubview:self.pageControll.view];
    [self.pageControll didMoveToParentViewController:self];
    for (UIView *v in  self.pageControll.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
}

- (void)createOrderBtn {
    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 35)];
    
    //创建button
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    UIView *btnlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWIDTH, 1)];
    btnlineView.backgroundColor = [UIColor lightGrayColor];
    btnlineView.alpha = 0.3;
    [self.btnView addSubview:btnlineView];
    [self.headerV addSubview:self.btnView];
    
    NSArray *nameArr = @[@"全部订单", @"待支付", @"待收货"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * BTNWIDTH, 0, BTNWIDTH, 34);
        btn.titleLabel.font =  [UIFont systemFontOfSize: 14];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateSelected];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btn];
        [self.btnArr addObject:btn];
    }
    [self.view addSubview:self.headerV];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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























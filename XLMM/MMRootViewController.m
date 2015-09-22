//
//  MMRootViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMRootViewController.h"
#import "RESideMenu.h"
#import "TodayViewController.h"
#import "PreviousViewController.h"
#import "ChildViewController.h"
#import "LeftMenuViewController.h"
#import "MMClass.h"
#import "LogInViewController.h"
#include "EnterViewController.h"


#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MMRootViewController ()
{
    UIView *_view;                  //
    UIPageViewController *_pageVC;  //
    NSArray *_pageContentVC;        //
    NSInteger _pageCurrentIndex;    //
    BOOL _isFirst;                  //
    NSInteger topdistance;
}

@end

@implementation MMRootViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirst = YES;
    topdistance = 110;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, topdistance, WIDTH, HEIGHT - topdistance)];
    [self.view addSubview:_view];//展示pageviews
    
    _pageCurrentIndex = 0;
    
    [self createInfo];
    
    [self creatPageData];
}

- (void)createInfo{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font-logo.png"]];
    imageView.frame = CGRectMake(0, 0, 147, 40);
    self.navigationItem.titleView = imageView;
    
    UIButton *leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [leftItemButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"]];
    leftImageview.frame = CGRectMake(8, 8, 26, 30);
//    leftItemButton.backgroundColor = [UIColor orangeColor];
    [leftItemButton addSubview:leftImageview];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [rightBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"]];
    loginImageView.frame = CGRectMake(8, 8, 26, 30);
    [rightBtn addSubview:loginImageView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)loginBtnClicked:(UIButton *)button{
    
    NSLog(@"login = %d", [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        NSLog(@"login");

    }else{
    EnterViewController *loginVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    }
}
  //创建PageVC
- (void)creatPageData{
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT - topdistance);
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    
    TodayViewController *todayVC = [[TodayViewController alloc] initWithNibName:@"TodayViewController" bundle:nil];
    PreviousViewController *preVC = [[PreviousViewController alloc] initWithNibName:@"PreviousViewController" bundle:nil];
    ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:nil];
    childVC.urlString = kCHILD_LIST_URL;
    childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
    ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:nil];
    womanVC.urlString = kLADY_LIST_URL;
    womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
    _pageContentVC = @[todayVC, preVC, childVC, womanVC];
    
    [_pageVC setViewControllers:@[todayVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];

    [self addChildViewController:_pageVC];
    [_view addSubview:_pageVC.view];
    [_pageVC didMoveToParentViewController:self];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (_isFirst) {
        
   
        
    }else{
   
        

    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    _isFirst = NO;
    [super viewWillDisappear:animated];
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark --PageViewControllerDelegate--

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    
}




- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    if (currentIndex < _pageContentVC.count - 1) {
        _pageCurrentIndex = currentIndex + 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    }
    return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    if (currentIndex > 0) {
        _pageCurrentIndex = currentIndex - 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _pageCurrentIndex = [_pageContentVC indexOfObject:pageViewController.viewControllers[0]];
    if (completed)
    {
        [self changeColor];
    }else{
        if (finished)
        {
            [self changeColor];
        }
    }
}

- (void)changeColor{
    NSInteger btnTag = _pageCurrentIndex + 100;
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            UIButton *button = (UIButton *)[self.btnView viewWithTag:i];
            button.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
        }
        else{
            UIButton *button = (UIButton *)[self.btnView viewWithTag:i];
            button.backgroundColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:20/255.0 alpha:1];
        }
    }
}

- (IBAction)btnClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger btnTag = button.tag;
  
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            button.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            button.backgroundColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:20/255.0 alpha:1];
        }
    }
    NSInteger index = btnTag - 100;
    BOOL state = 0;
    if (_pageCurrentIndex < index) {
        state = 1;
    }
    _pageCurrentIndex = index;
    [_pageVC setViewControllers:@[[_pageContentVC objectAtIndex:index]] direction:state?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
@end


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
#import "WomanViewController.h"
#import "ChildViewController.h"
#import "LeftMenuViewController.h"
#import "MMClass.h"
#import "LogInViewController.h"
#include "EnterViewController.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MMRootViewController ()
{
    UIView *_view;
    UIPageViewController *_pageVC;
    NSArray *_pageContentVC;
    NSInteger _pageCurrentIndex;
    UIButton *leftButton;
    BOOL _isFirst;
    
}

@end

@implementation MMRootViewController

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//        self.navigationController.navigationBarHidden = NO;
//   
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirst = YES;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+5+40, WIDTH, HEIGHT - 64 - 5 - 40)];
    [self.view addSubview:_view];
    _pageCurrentIndex = 0;
    [self createInfo];
    
    [self creatPageData];
}

- (void)createInfo{
    self.title = @"小鹿美美";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font-logo.png"]];
    imageView.frame = CGRectMake(0, 0, 147, 40);
    self.navigationItem.titleView = imageView;
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"]];
    leftImageview.frame = CGRectMake(8, 8, 26, 30);
    [leftButton addSubview:leftImageview];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [rightBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"]];
    loginImageView.frame = CGRectMake(8, 8, 26, 30);
    [rightBtn addSubview:loginImageView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(presentLeftMenuViewController:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(presentRightMenuViewController:)];
    
    [ self.view addSubview:[[UIView alloc] init]];
}

- (void)loginBtnClicked:(UIButton *)button{
    NSLog(@"login");
    
    EnterViewController *loginVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)creatPageData{
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 45);
    _pageVC.view.userInteractionEnabled = YES;
    
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
    NSLog(@"DEMOFirstViewController will appear");
    if (_isFirst) {
        
        NSLog(@"111");
        
    }else{
        NSLog(@"222");
        
       // [self presentLeftMenuViewController:leftButton];

    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    _isFirst = NO;
    [super viewWillDisappear:animated];
    NSLog(@"DEMOFirstViewController will disappear");
   
   
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



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    if (currentIndex < _pageContentVC.count - 1) {
        
     //   pageViewController.view.userInteractionEnabled = YES;
        NSLog(@"1111");
        _pageCurrentIndex = currentIndex + 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
        

    } else{
        NSLog(@"2222");

    }
    // pageViewController.view.userInteractionEnabled = NO;
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    if (currentIndex > 0) {
    //    pageViewController.view.userInteractionEnabled = YES;
        
        NSLog(@"3333");
        _pageCurrentIndex = currentIndex - 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    } else{
        
        NSLog(@"4444");
   //pageViewController.view.userInteractionEnabled = NO;
    }
    
    //pageViewController.view.userInteractionEnabled = NO;

    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger currentIndex  = [_pageContentVC indexOfObject:pageViewController.viewControllers[0]];
    
    if (completed)
    {
        NSInteger btnTag = currentIndex + 100;
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
        
       // [self sliderLabelPositonWithIndex:currentIndex withDuration:.35];
        
    }else
    {
        if (finished)
        {
            
            NSInteger btnTag = currentIndex + 100;
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

            
            //[self sliderLabelPositonWithIndex:currentIndex withDuration:.35];
        }
    }
    
}

- (IBAction)btnClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger btnTag = button.tag;
    if (btnTag == 100) {
        NSLog(@"100");
    } else if (btnTag == 101){
        NSLog(@"101");
        
    } else if (btnTag == 102){
        NSLog(@"102");
    } else if (btnTag == 103){
        NSLog(@"103");
    }
    
    else{
        NSLog(@"others");
    }
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

//
//NSInteger index = sender.tag - 101;
//BOOL state = 0;
//[self sliderLabelPositonWithIndex:index withDuration:.35];
//
//if (_pageCurrentIndex < index) {
//    
//    state = 1;
//    
//}
//
//_pageCurrentIndex = index;
//
//[_pageVC setViewControllers:@[[_pageContentVC objectAtIndex:index]] direction:state?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
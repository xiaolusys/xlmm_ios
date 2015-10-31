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

#import "CartViewController.h"

#import "MMCartsView.h"
#import "MMNavigationDelegate.h"



#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MMRootViewController ()<MMNavigationDelegate>

{
    UIView *_view;
    UIPageViewController *_pageVC;
    NSArray *_pageContentVC;
    NSInteger _pageCurrentIndex;
    UIButton *leftButton;
    BOOL _isFirst;
    
    NSInteger goodsCount;
    UILabel *label;
    
    CGRect frame;

    
}

@end

@implementation MMRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFirst) {
        
        NSLog(@"111");
        
    }else{
        NSLog(@"222");
        
        // [self presentLeftMenuViewController:leftButton];
        
    }
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    cartView.frame = CGRectMake(2, SCREENHEIGHT - 166, 44, 44);
    if (self.navigationController.navigationBarHidden) {
        NSLog(@"导航栏被隐藏了");
    } else {
        NSLog(@"显示导航栏");
    }
    self.view.frame = frame;
    
    [self setLabelNumber];
    
    
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
  
    if (_isFirst) {

    }else{
        
//        UIView *cartView = [_view viewWithTag:123];
//        cartView.frame = CGRectMake(2, SCREENHEIGHT - 166, 44, 44);
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    _isFirst = NO;
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"DEMOFirstViewController will disappear");
    frame = self.view.frame;
    

    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    frame = self.view.frame;
    NSLog(@"fram = %@", NSStringFromCGRect(frame));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirst = YES;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+35, WIDTH, HEIGHT - 20 - 5 - 28 - 2)];
    [self.view addSubview:_view];
    _pageCurrentIndex = 0;
    
    [self createInfo];
    
    [self creatPageData];
    
}


- (void)createInfo{
    self.title = @"小鹿美美";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
    
    imageView.frame = CGRectMake(0, 8, 83, 20);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [view addSubview:imageView];
    imageView.center = view.center;
    CGRect imageframe = imageView.frame;
    imageframe.origin.y += 2;
   imageView.frame = imageframe;
    
    self.navigationItem.titleView = view;
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles.png"]];
    leftImageview.frame = CGRectMake(0, 11, 26, 26);
    [leftButton addSubview:leftImageview];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
//    rightImageView.frame = CGRectMake(18, 11, 26, 26);
//    [rightBtn addSubview:rightImageView];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;

//    rightBtn.backgroundColor = [UIColor redColor];
//    leftButton.backgroundColor = [UIColor redColor];
    
    [ self.view addSubview:[[UIView alloc] init]];
}

- (void)rightClicked:(UIButton *)button{
    NSLog(@"right");
}


  
- (void)creatPageData{
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = _view.bounds;
    _pageVC.view.userInteractionEnabled = YES;
    
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    
    TodayViewController *todayVC = [[TodayViewController alloc] initWithNibName:@"TodayViewController" bundle:nil];
    todayVC.delegate = self;
    PreviousViewController *preVC = [[PreviousViewController alloc] initWithNibName:@"PreviousViewController" bundle:nil];
    preVC.delegate = self;
    
    ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    childVC.urlString = kCHILD_LIST_URL;
    childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
    childVC.delegate = self;
  
    ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    womanVC.urlString = kLADY_LIST_URL;
    womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
    womanVC.delegate = self;
    
    _pageContentVC = @[todayVC, preVC, childVC, womanVC];
    
    [_pageVC setViewControllers:@[todayVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:_pageVC];
    [_view addSubview:_pageVC.view];
    
    [self createCartsView];

    [_pageVC didMoveToParentViewController:self];
    
 
    
}

- (void)createCartsView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2, SCREENHEIGHT - 166, 44, 44)];
    view.tag = 123;
    [_view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-gouwuche.png"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    UIView *litleView = [[UIView alloc] initWithFrame:CGRectMake(22, 6, 16, 16)];
    litleView.layer.cornerRadius = 8;
    litleView.backgroundColor = [UIColor colorWithR:232 G:79 B:136 alpha:1];
    litleView.userInteractionEnabled = NO;
    litleView.alpha = 0.7;
    
    [button addSubview:litleView];
    label = [[UILabel alloc] initWithFrame:litleView.bounds];
    label.text = @"12";
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [litleView addSubview:label];
    
    
    [self setLabelNumber];
    
    //  http://m.xiaolu.so/rest/v1/carts/show_carts_num
  
}

- (void)setLabelNumber{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] == NO) {
        label.text = @"0";
        return;
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num.json", Root_URL];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSError *error = nil;
    if (data == nil) {
        label.text = @"0";
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
    goodsCount = [[dic objectForKey:@"result"]integerValue];
    NSLog(@"goods count = %ld", (long)goodsCount);
    label.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"result"] stringValue]];
    
}

- (void)gotoCarts:(id)sender{
    NSLog(@"进入购物车。。。");
    
    NSLog(@"gouguche ");
    
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    if (goodsCount == 0) {
//        NSLog(@"购物车为空");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的购物车为空~" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//        return;
    }
    
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
    
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
    NSLog(@"-->%@", pendingViewControllers);
}




- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    
    NSLog(@"currentIndex = %ld", (long)currentIndex);

    if (currentIndex < _pageContentVC.count - 1) {
        
        NSLog(@"1111");
        _pageCurrentIndex = currentIndex + 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
        

    } else{
        NSLog(@"2222");

    }
    
    return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [_pageContentVC indexOfObject:viewController];
    
    NSLog(@"currentIndex = %ld", (long)currentIndex);
    if (currentIndex > 0) {
        
        NSLog(@"3333");
        _pageCurrentIndex = currentIndex - 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    } else{
        
        
        
     
        
        NSLog(@"4444");
    }
  //  return [_pageContentVC objectAtIndex:_pageCurrentIndex];

   return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger currentIndex  = [_pageContentVC indexOfObject:pageViewController.viewControllers[0]];
    
    NSLog(@"currentIndex = %ld", (long)currentIndex);
    if (completed)
    {
        NSInteger btnTag = currentIndex + 100;
        for (int i = 100; i<104; i++) {
            if (btnTag == i) {
                UIButton *button = (UIButton *)[self.btnView viewWithTag:i];
              [button setTitleColor:[UIColor colorWithR:252 G:185 B:22 alpha:1] forState:UIControlStateNormal];
                
            }
            else{
                UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                [button setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];

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
                  [button setTitleColor:[UIColor colorWithR:252 G:185 B:22 alpha:1] forState:UIControlStateNormal];
                    
                }
                else{
                    UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                    [button setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
                    
                }
            }
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
            [button setTitleColor:[UIColor colorWithR:252 G:185 B:22 alpha:1] forState:UIControlStateNormal];
            
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            [button setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
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

#pragma mark --mmNavigationDelegate--

- (void)hiddenNavigation{
    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, -44, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    cartView.frame = CGRectMake(2, SCREENHEIGHT - 122, 44, 44);
}

- (void)showNavigation{
   // NSLog(@"sssssss");
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    cartView.frame = CGRectMake(2, SCREENHEIGHT - 166, 44, 44);
}

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
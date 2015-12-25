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
#import "MMClass.h"
#import "LogInViewController.h"
#import "UIImage+ColorImage.h"
#import "CartViewController.h"

#import "MMCartsView.h"
#import "MMNavigationDelegate.h"
#import "LogInViewController.h"
#import "WXApi.h"
#import "MaMaViewController.h"



#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MMRootViewController ()<MMNavigationDelegate, WXApiDelegate>

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
    NSInteger _currentIndex;

    
}

@end

@implementation MMRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFirst) {
        
        
    }else{
        
        // [self presentLeftMenuViewController:leftButton];
        
    }
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156 , 44, 44);
    if (self.navigationController.navigationBarHidden) {
    } else {
    }
    self.view.frame = frame;
    
    [self setLabelNumber];
    
    
    //设置NavigationBar背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
   // [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(SCREENWIDTH, 1)]];
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirst = YES;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+34.9, WIDTH, HEIGHT - 20 - 5 - 28 - 2)];
    [self.view addSubview:_view];
    _pageCurrentIndex = 0;
    
    [self createInfo];
    
    [self creatPageData];
    
}


- (void)createInfo{
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
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
    rightImageView.frame = CGRectMake(18, 11, 26, 26);
    [rightBtn addSubview:rightImageView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;


    
    [self.view addSubview:[[UIView alloc] init]];
}

- (void)rightClicked:(UIButton *)button{
//    NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    MaMaViewController *ma = [[MaMaViewController alloc] init];
    [self.navigationController pushViewController:ma animated:YES];
//    [self presentViewController:ma animated:YES completion:nil];
    
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
    childVC.childClothing = YES;
    childVC.delegate = self;
  
    ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    womanVC.urlString = kLADY_LIST_URL;
    womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
    womanVC.childClothing = NO;
    womanVC.delegate = self;
    
    _pageContentVC = @[todayVC, preVC, childVC, womanVC];
    
    [_pageVC setViewControllers:@[todayVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:_pageVC];
    [_view addSubview:_pageVC.view];
    
    [self createCartsView];

    [_pageVC didMoveToParentViewController:self];
    
    
    for (UIView *v in  _pageVC.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
    
}

- (void)createCartsView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, SCREENHEIGHT - 156, 44, 44)];
    view.tag = 123;
    [_view addSubview:view];
    view.backgroundColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithR:38 G:38 B:46 alpha:1].CGColor;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    iconView.image = [UIImage imageNamed:@"gouwucheicon2.png"];
    iconView.userInteractionEnabled = NO;
    [button addSubview:iconView];
    
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
    goodsCount = [[dic objectForKey:@"result"]integerValue];
    label.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"result"] stringValue]];
    
}

- (void)gotoCarts:(id)sender{
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        LogInViewController *enterVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
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

#pragma mark UIscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((scrollView.contentInset.left < 0) && (_currentIndex == 0) && velocity.x < 0) {
        [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil withObject:self];
    }
}


#pragma mark --PageViewControllerDelegate--

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    _currentIndex = [_pageContentVC indexOfObject:viewController];
    

    if (_currentIndex < _pageContentVC.count - 1) {
        _pageCurrentIndex = _currentIndex + 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
        

    } else{

    }
    
    return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    _currentIndex = [_pageContentVC indexOfObject:viewController];
    
    if (_currentIndex > 0) {
        
        _pageCurrentIndex = _currentIndex - 1;
        return [_pageContentVC objectAtIndex:_pageCurrentIndex];
    } else{
    }

   return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _currentIndex  = [_pageContentVC indexOfObject:pageViewController.viewControllers[0]];
    
    if (completed)
    {
        NSInteger btnTag = _currentIndex + 100;
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
            
            NSInteger btnTag = _currentIndex + 100;
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
    } else if (btnTag == 101){
        
    } else if (btnTag == 102){
    } else if (btnTag == 103){
    }
    
    else{
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
    cartView.frame = CGRectMake(15, SCREENHEIGHT - 112, 44, 44);
  

}

- (void)showNavigation{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156, 44, 44);
}

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
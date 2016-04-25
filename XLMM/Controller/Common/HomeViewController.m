//
//  HomeViewController.m
//  XLMM
//
//  Created by zhang on 16/4/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HomeViewController.h"
#import "RESideMenu.h"
#import "TodayViewController.h"
#import "PreviousViewController.h"
#import "ChildViewController.h"
#import "MMClass.h"
#import "LogInViewController.h"
#import "UIImage+ColorImage.h"
#import "CartViewController.h"
#import "MMDetailsViewController.h"
#import "MMCollectionController.h"
#import "MMCartsView.h"
#import "MMNavigationDelegate.h"
#import "LogInViewController.h"
#import "WXApi.h"
#import "MaMaViewController.h"
#import "YouHuiQuanViewController.h"
#import "XiangQingViewController.h"
#import "MaMaPersonCenterViewController.h"
#import "MMLoginStatus.h"
#import "AFNetworking.h"
#import "NSString+Encrypto.h"
#import "PublishNewPdtViewController.h"
#import "ActivityView.h"
#import "NSString+URL.h"
#import "TuihuoViewController.h"
#import "MMAdvertiseView.h"
#import "XlmmMall.h"

#define SECRET @"3c7b4e3eb5ae4cfb132b2ac060a872ee"
#define ABOVEHIGHT 300



#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HomeViewController ()<MMNavigationDelegate, WXApiDelegate>{
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
    UIBarButtonItem *rightItem;
    UIView *dotView;
    UILabel *countLabel;
    NSNumber *last_created;
    NSTimer *theTimer;
    
}

@property (nonatomic, strong)ActivityView *startV;
@property (nonatomic, strong)NSTimer *sttime;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)NSString *imageUrl;
 
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
    //    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156 , 44, 44);
    [self setLabelNumber];
    
}

//- (void)updataAfterLogin:(NSNotification *)notification{
//    // 微信登录
//    if ([self loginUpdateIsXiaoluMaMa]) {
//        [self createRightItem];
//    } else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//}
//
//- (void)phoneNumberLogin:(NSNotification *)notification{
//    //  NSLog(@"手机登录");
//    if ([self loginUpdateIsXiaoluMaMa]) {
//        [self createRightItem];
//    } else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//}
//
//- (BOOL)isXiaolumama{
//    //    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
//    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    //        if (!responseObject)return ;
//    //        return YES;
//    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    //        return NO;
//    //    }];
//    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
//    //    if (data == nil) {
//    //        return NO;
//    //    }
//    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    //    NSLog(@"dic = %@", dic);
//    //    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
//    //    return YES;
//    
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    BOOL isXLMM = [users boolForKey:@"isXLMM"];
//    return isXLMM;
//}
//
//- (BOOL)loginUpdateIsXiaoluMaMa {
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
//    if (data == nil) {
//        return NO;
//    }
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"dic = %@", dic);
//    return [[dic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
//}
//
//- (void)createRightItem{
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category.png"]];
//    rightImageView.frame = CGRectMake(18, 11, 26, 26);
//    [rightBtn addSubview:rightImageView];
//    rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}



#pragma mark init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  type:(NSInteger)type{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (type == TYPE_JUMP_CHILD) {
        
    }
    else{
        
    }
    return self;
}


- (void)showNotification:(NSNotification *)notification{
    NSLog(@"弹出提示框");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    frame = self.view.frame;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    frame = self.view.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super viewDidLoad];
    
    self.timeCount = 0;
    
    //弹出消息框提示用户有订阅通知消息。主要用于用户在使用应用时，弹出提示框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification:) name:@"Notification" object:nil];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
//    _isFirst = YES;
    
//    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+34.9, WIDTH, HEIGHT - 20 - 5 - 28 - 2)];
//    [self.view addSubview:_view];
//    _pageCurrentIndex = 0;
    
    
//    [self createInfo];
    
        [self creatPageData];
    

}

- (void)createBanner {
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    bannerView.backgroundColor = [UIColor redColor];
//    [self.aboveView addSubview:bannerView];
    
    UIView *childAndWomanView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREENWIDTH, 120)];
    childAndWomanView.backgroundColor = [UIColor greenColor];
//    [self.aboveView addSubview:childAndWomanView];
    //创建童装和女装
    
    //创建分类
    
}

- (void)startDeal:(NSDictionary *)dic {
    self.imageUrl = [dic objectForKey:@"picture"];
    
    if (self.imageUrl.length == 0 || [self.imageUrl class] == [NSNull class]) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
    }
    self.startV.imageV.alpha = 1;
    
    [self.startV.imageV sd_setImageWithURL:[NSURL URLWithString:[self.imageUrl imagePostersCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.3 animations:^{
            self.startV.imageV.alpha = 1;
        }];
    }];
}

- (void)ActivityTimeUpdate {
    self.timeCount++;
    if (self.timeCount > 2) {
        [self.sttime invalidate];
        self.sttime = nil;
        
        [self.startV removeFromSuperview];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bombbox" object:self];
        
    }
}

#pragma mark  设置导航栏样式
//- (void)createInfo{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
//    imageView.frame = CGRectMake(0, 8, 83, 20);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [view addSubview:imageView];
//    imageView.center = view.center;
//    CGRect imageframe = imageView.frame;
//    imageframe.origin.y += 2;
//    imageView.frame = imageframe;
//    self.navigationItem.titleView = view;
//    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *leftImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profiles.png"]];
//    leftImageview.frame = CGRectMake(0, 11, 26, 26);
//    [leftButton addSubview:leftImageview];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    
//    
//    
//    [self.view addSubview:[[UIView alloc] init]];
//}
//

#pragma mark 创建购物车按钮。。
- (void)createCartsView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT - 156, 108, 44)];
    view.tag = 123;
    [_view addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor settingBackgroundColor].CGColor;
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
    [button addTarget:self action:@selector(gotoCarts:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    iconView.image = [UIImage imageNamed:@"gouwucheicon2.png"];
    iconView.userInteractionEnabled = NO;
    [button addSubview:iconView];
    //    button.backgroundColor = [UIColor redColor];
    
    dotView = [[UIView alloc] initWithFrame:CGRectMake(26, 4, 16, 16)];
    dotView.layer.cornerRadius = 8;
    dotView.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    [button addSubview:dotView];
    dotView.hidden = YES;
    
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 60, 24)];
    countLabel.text = @"";
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentLeft;
    [button addSubview:countLabel];
    label = [[UILabel alloc] initWithFrame:dotView.bounds];
    label.font = [UIFont systemFontOfSize:10];
    [dotView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    countLabel.userInteractionEnabled = NO;
    dotView.userInteractionEnabled = NO;
    label.userInteractionEnabled = NO;
    countLabel.hidden = YES;
    
    
    
}
#pragma mark 设置购物车数量


- (void)setLabelNumber{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == NO) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        
        label.text = @"0";
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/show_carts_num.json", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            label.text = @"0";
            dotView.hidden = YES;
            countLabel.hidden = YES;
            UIView *view = [_view viewWithTag:123];
            CGRect rect = view.frame;
            rect.size.width = 44;
            view.frame = rect;
            return ;
        }else {
            [self cartViewUpdate:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

- (void)cartViewUpdate:(NSDictionary *)dic {
    // NSLog(@"dic = %@", dic);
    last_created = [dic objectForKey:@"last_created"];
    goodsCount = [[dic objectForKey:@"result"]integerValue];
    if (goodsCount == 0) {
        dotView.hidden = YES;
        countLabel.hidden = YES;
        UIView *view = [_view viewWithTag:123];
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        return;
    }
    label.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"result"] stringValue]];
    dotView.hidden = NO;
    countLabel.hidden = NO;
    UIView *view = [_view viewWithTag:123];
    CGRect rect = view.frame;
    rect.size.width = 108;
    view.frame = rect;
    
    [self createTimeLabel];
}


- (void)createTimeLabel{
    countLabel.hidden = NO;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)thetimer
{
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[last_created doubleValue]];
    // NSLog(@"%@", lastDate);
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:lastDate options:0];
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    //   NSLog(@"string = %@", string);
    if ([d minute] < 0 || [d second] < 0) {
        string = @"";
        
        UIView *view = [_view viewWithTag:123];
        dotView.hidden = YES;
        
        CGRect rect = view.frame;
        rect.size.width = 44;
        view.frame = rect;
        if ([theTimer isValid]) {
            [theTimer invalidate];
            
            
            
        }
    }
    countLabel.text = string;
}


#pragma mark 点击按钮进入购物车界面
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
//    if (_currentIndex == 0) {
//        scrollView.bounces = NO;
//    } else{
//        scrollView.bounces = YES;
//    }
    
    
}

#pragma mark --mmNavigationDelegate--

- (void)hiddenNavigation{
    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, -44, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 112;
    cartView.frame = rect;
    
    
}

- (void)showNavigation{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *cartView = [_view viewWithTag:123];
    CGRect rect = cartView.frame;
    rect.origin.y = SCREENHEIGHT - 156;
    cartView.frame = rect;
    //    cartView.frame = CGRectMake(15, SCREENHEIGHT - 156, 44, 44);
}

#pragma mark RootVCPushOtherVCDelegate

- (void)rootVCPushOtherVC:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 生成pageController数据。。。
- (void)creatPageData{
    NSLog(@"creatPageData");
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = _view.bounds;
    _pageVC.view.userInteractionEnabled = YES;
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    /*TodayViewController *todayVC = [[TodayViewController alloc] initWithNibName:@"TodayViewController" bundle:nil];
    todayVC.delegate = self;
    PreviousViewController *preVC = [[PreviousViewController alloc] initWithNibName:@"PreviousViewController" bundle:nil];
    preVC.delegate = self;*/
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
    _pageContentVC = @[childVC, womanVC];
    [_pageVC setViewControllers:@[childVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
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

#pragma mark --PageViewControllerDelegate--
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
                [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            }
            else{
                UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
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
                    [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
                    
                }
                else{
                    UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
                    [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
                    
                }
            }
        }
    }
    
}

#pragma mark 点击按钮进入不同的专区列表。。
- (void)buttonClicked:(NSInteger)btnTag{
    _currentIndex = btnTag - 100+1;
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            UIButton *button = (UIButton *)[self.btnView viewWithTag:btnTag];
            [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
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

- (IBAction)btnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger btnTag = button.tag;
    _currentIndex = btnTag - 100+1;
    
    for (int i = 100; i<104; i++) {
        if (btnTag == i) {
            [button setTitleColor:[UIColor rootViewButtonColor] forState:UIControlStateNormal];
            
        }else{
            UIButton *button  = (UIButton *)[self.btnView viewWithTag:i];
            [button setTitleColor:[UIColor cartViewBackGround] forState:UIControlStateNormal];
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

@end

//
//  JMCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponController.h"
#import "MMClass.h"
#import "HMSegmentedControl.h"
#import "JMUsedCouponController.h"
#import "JMExpiredCouponController.h"
#import "JMUntappedCouponController.h"
#import "JMSpecialCouponController.h"


@interface JMCouponController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) JMUntappedCouponController *untappedCouponVC;

@property (nonatomic, strong) JMExpiredCouponController *expiredCouponVC;

@property (nonatomic, strong) JMUsedCouponController *usedCouponVC;

@property (nonatomic, strong) JMSpecialCouponController *spacialVC;

@end

@implementation JMCouponController {
    NSMutableArray *_titleArr;
    NSMutableArray *flageArr;
    
    NSArray *untappedArr;
    NSArray *expiredArr;
    NSArray *usedArr;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"优惠券" selecotr:@selector(backClick:)];
    self.view.backgroundColor = [UIColor countLabelColor];
    [MBProgressHUD showLoading:@"小鹿正在加载优惠券,稍等片刻哦~!"];
    _titleArr = [NSMutableArray arrayWithObjects:@"未使用",@"购物券",@"已过期",@"已使用", nil];
    flageArr = [NSMutableArray arrayWithObjects:@0,@0,@0, nil];
    [self loadCouponData];
    [self createSegmentView];
    [self createSegement];
}

- (void)loadCouponData {
    NSArray *countArr = @[@"0",@"3",@"1"];
    for (int i = 0; i < countArr.count; i++) {
        [self loadData:countArr[i]];
    }
}
- (void)loadData:(NSString *)statusCount {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%ld",Root_URL,[statusCount integerValue]];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchStatus:statusCount responseArr:responseObject];
    } WithFail:^(NSError *error) {
        [self fetchStatus:statusCount responseArr:nil];
    } Progress:^(float progress) {
    }];
    
}
- (void)fetchStatus:(NSString *)statusCount responseArr:(NSArray *)responseArr {
    if ([statusCount isEqualToString:@"0"]) {
        flageArr[0] = @1;
        NSMutableArray *resArr = [NSMutableArray array];
        for (NSDictionary *dic in responseArr) {
            if ([dic[@"coupon_type"] integerValue] == 8) {
                [resArr addObject:dic];
            }
        }
        self.untappedCouponVC.couponArray = responseArr;
        self.spacialVC.couponArray = resArr;
        _titleArr[0] = [NSString stringWithFormat:@"未使用(%ld)",responseArr.count];
        _titleArr[1] = [NSString stringWithFormat:@"购物券(%ld)",resArr.count];
    }else if ([statusCount isEqualToString:@"3"]) {
        flageArr[1] = @1;
        self.expiredCouponVC.couponArray = responseArr;
        _titleArr[2] = [NSString stringWithFormat:@"已过期(%ld)",responseArr.count];
    }else if ([statusCount isEqualToString:@"1"]) {
        flageArr[2] = @1;
        self.usedCouponVC.couponArray = responseArr;
        _titleArr[3] = [NSString stringWithFormat:@"已使用(%ld)",responseArr.count];
    }else {
    }
    BOOL isCreateSegment = ([flageArr[0] isEqual: @1]) && ([flageArr[1] isEqual:@1]) && ([flageArr[2] isEqual:@1]);
    if (isCreateSegment == YES) {
        self.segmentedControl.sectionTitles = _titleArr;
        [MBProgressHUD hideHUD];
    }else{
        
    }
}

- (void)createSegmentView {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    self.segmentedControl.backgroundColor = [UIColor sectionViewColor];
    self.segmentedControl.sectionTitles = _titleArr;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonTitleColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 64, SCREENWIDTH, SCREENHEIGHT) animated:YES];
    }];
    [self.view addSubview:self.segmentedControl];
}
- (void)createSegement {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 4, SCREENHEIGHT);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) animated:NO];
    [self.view addSubview:self.scrollView];


    self.untappedCouponVC = [[JMUntappedCouponController alloc] init];
    self.untappedCouponVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.untappedCouponVC];
    [self.scrollView addSubview:self.untappedCouponVC.view];
    
    self.spacialVC = [[JMSpecialCouponController alloc] init];
    self.spacialVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.spacialVC];
    [self.scrollView addSubview:self.spacialVC.view];
    
    self.expiredCouponVC = [[JMExpiredCouponController alloc] init];
    self.expiredCouponVC.view.frame = CGRectMake(SCREENWIDTH * 2, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.expiredCouponVC];
    [self.scrollView addSubview:self.expiredCouponVC.view];
    
    
    self.usedCouponVC = [[JMUsedCouponController alloc] init];
    self.usedCouponVC.view.frame = CGRectMake(SCREENWIDTH * 3, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.usedCouponVC];
    [self.scrollView addSubview:self.usedCouponVC.view];
    
    
    
    
    

}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}
- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}
- (void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"seeCoupon"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"seeCoupon"];
}

@end

/**
 *
 http://m.xiaolumeimei.com/rest/v1/usercoupons/get_user_coupons?status=3
 
 UNUSED = 0
 USED = 1
 FREEZE = 2
 PAST = 3
 USER_COUPON_STATUS = ((UNUSED, u"未使用"), (USED, u"已使用"), (FREEZE, u"冻结中"), (PAST, u"已经过期"))
 */


/**
 *  //- (NSArray *)classArr {
 //    return @[@"JMUntappedCouponController",@"JMExpiredCouponController",@"JMUsedCouponController"];
 //}
 //- (NSArray *)titleArr {
 //    [SVProgressHUD showWithStatus:@"优惠券努力加载中......"];
 //    NSArray *countArr = @[@"0",@"3",@"1"];
 //    NSInteger count = 0;
 //    _titleArr = [NSMutableArray array];
 //    NSArray *tArr = @[@"未使用",@"已过期",@"已使用"];
 //    for (int i = 0; i < [self classArr].count; i++) {
 //        count = [countArr[i] integerValue];
 //        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%ld",Root_URL,count];
 //        NSURL *url = [NSURL URLWithString:string];
 //        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
 //        NSURLResponse *response = nil;
 //        NSError *error = nil;
 //        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 //        if (error != nil) {
 //
 //        }else {
 //
 //        }
 //        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 //        [_titleArr addObject:[NSString stringWithFormat:@"%@(%ld)",tArr[i],arr.count]];
 //    }
 //    [SVProgressHUD dismiss];
 //    return _titleArr;
 //}
 */


























































//
//  JMCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponController.h"
#import "HMSegmentedControl.h"
#import "JMUntappedCouponController.h"


@interface JMCouponController () {
    NSMutableArray *_itemArr;
    NSArray *_urlArr;
    NSArray *_typeArr;
}


@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;


@property (nonatomic, strong) JMUntappedCouponController *untappedCouponVC;


@end

@implementation JMCouponController
- (void)setSegmentSectionTitle:(NSArray *)segmentSectionTitle {
    _segmentSectionTitle = segmentSectionTitle;
    self.segmentControl.sectionTitles = segmentSectionTitle;
}
#pragma mark 懒加载
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 45)];
        _segmentControl.backgroundColor = [UIColor countLabelColor];
        _segmentControl.sectionTitles = _itemArr;
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 2.f;
        _segmentControl.selectionIndicatorColor = [UIColor orangeColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                        NSForegroundColorAttributeName : [UIColor orangeColor]};
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.delegate = self;
    }
    return _baseScrollView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"seeCoupon"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"seeCoupon"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"优惠券" selecotr:@selector(backClick)];
    self.view.backgroundColor = [UIColor countLabelColor];
    _itemArr = [NSMutableArray arrayWithObjects:@"未使用",@"精品券",@"已过期",@"已使用", nil];
    NSString *string1 = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%@&paging=1",Root_URL,@"0"];
    NSString *string2 = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%@&paging=1",Root_URL,@"0"];
    NSString *string3 = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%@&paging=1",Root_URL,@"3"];
    NSString *string4 = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%@&paging=1",Root_URL,@"1"];
    _urlArr = @[string1,string2,string3,string4];
    _typeArr = @[@"0",@"0",@"3",@"1"];
    
    
    [self.view addSubview:self.segmentControl];
    _segmentControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.baseScrollView];
    [self addChildController];
    [self removeToPage:0];
    
}


- (void)addChildController {
    for (int i = 0 ; i < _itemArr.count; i++) {
        JMUntappedCouponController *couponVC = [[JMUntappedCouponController alloc] init];
        couponVC.couponStatus = [_typeArr[i] integerValue];
        couponVC.payCouponVC = self;
        couponVC.itemArr = _itemArr;
        couponVC.segmentIndex = i;
        [self addChildViewController:couponVC];
        [couponVC didMoveToParentViewController:self];
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * _itemArr.count, self.baseScrollView.frame.size.height);
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    [self removeToPage:page];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    //    _lastSelectedIndex = (int)page;
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
    [self removeToPage:page];
    
}
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    JMUntappedCouponController *couponVC = self.childViewControllers[index];
    couponVC.urlString = _urlArr[index];
    couponVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:couponVC.view];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
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


























































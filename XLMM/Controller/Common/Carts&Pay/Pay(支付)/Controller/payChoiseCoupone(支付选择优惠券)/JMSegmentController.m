//
//  JMSegmentController.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSegmentController.h"
#import "HMSegmentedControl.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JMCouponModel.h"
#import "MJExtension.h"
#import "JMUsableCouponController.h"
#import "JMDisableCouponController.h"
#import "UIViewController+NavigationBar.h"

@interface JMSegmentController ()<YouhuiquanDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *usableCouponArr;

@property (nonatomic, strong) NSMutableArray *disableCouponArr;

@property (nonatomic, strong) JMUsableCouponController *usableCouponVC;

@property (nonatomic, strong) JMDisableCouponController *disableCouponVC;

@end

@implementation JMSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"使用优惠券" selecotr:@selector(backClick:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadCouponData];
}
- (NSMutableArray *)usableCouponArr {
    if (_usableCouponArr == nil) {
        _usableCouponArr = [NSMutableArray array];
    }
    return _usableCouponArr;
}
- (NSMutableArray *)disableCouponArr {
    if (_disableCouponArr == nil) {
        _disableCouponArr = [NSMutableArray array];
    }
    return _disableCouponArr;
}
- (void)loadCouponData {
    [SVProgressHUD showWithStatus:@"小鹿正在加载优惠券,稍等片刻哦~!"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/coupon_able?cart_ids=%@",Root_URL,self.cartID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchData:responseObject];
        [self createSegement];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"优惠券加载失败,请稍后重试~!"];
    }];
}
- (void)createSegement {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    self.segmentedControl.backgroundColor = [UIColor sectionViewColor];
    self.segmentedControl.layer.borderWidth = 1.;
    self.segmentedControl.layer.borderColor = [UIColor lineGrayColor].CGColor;
    NSString *usableStr = [NSString stringWithFormat:@"可用优惠券(%ld)",self.usableCouponArr.count];
    NSString *disableStr = [NSString stringWithFormat:@"不可用优惠券(%ld)",self.disableCouponArr.count];
    self.segmentedControl.sectionTitles = @[usableStr,disableStr];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont systemFontOfSize:16.]};
    self.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 64, SCREENWIDTH, SCREENHEIGHT) animated:YES];
    }];
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, SCREENHEIGHT);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) animated:NO];
    [self.view addSubview:self.scrollView];

    self.usableCouponVC = [[JMUsableCouponController alloc] init];
    self.usableCouponVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.usableCouponVC.delegate = self;
    self.usableCouponVC.isSelectedYHQ = self.isSelectedYHQ;
    self.usableCouponVC.selectedModelID = self.selectedModelID;
    [self addChildViewController:self.usableCouponVC];
    [self.scrollView addSubview:self.usableCouponVC.view];
    self.usableCouponVC.dataSource = self.usableCouponArr;
    
    self.disableCouponVC = [[JMDisableCouponController alloc] init];
    self.disableCouponVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:self.disableCouponVC];
    [self.scrollView addSubview:self.disableCouponVC.view];
    self.disableCouponVC.dataSource = self.disableCouponArr;

    
}

- (void)fetchData:(NSDictionary *)couponData {
    NSInteger code = [couponData[@"code"] integerValue];
    if (code == 0) {
        NSArray *disableArr = couponData[@"disable_coupon"];
        NSArray *usableArr = couponData[@"usable_coupon"];
        if (disableArr.count != 0) {
            for (NSDictionary *dic in disableArr) {
                JMCouponModel *couponModel = [JMCouponModel mj_objectWithKeyValues:dic];
                [self.disableCouponArr addObject:couponModel];
            }
        }else if (usableArr.count != 0) {
            for (NSDictionary *dic in usableArr) {
                JMCouponModel *couponModel = [JMCouponModel mj_objectWithKeyValues:dic];
                [self.usableCouponArr addObject:couponModel];
            }
        }else {
            return ;
        }
    }else {
        [SVProgressHUD showInfoWithStatus:couponData[@"info"]];
    }
    
    
}
- (void)updateYouhuiquanmodel:(JMCouponModel *)model {
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
        [_delegate updateYouhuiquanWithmodel:model];
    }
    
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
- (void)backClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"purchaseCoupon"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"purchaseCoupon"];
}
@end







































































































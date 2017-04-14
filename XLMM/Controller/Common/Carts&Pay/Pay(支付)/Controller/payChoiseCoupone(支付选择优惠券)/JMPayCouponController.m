//
//  JMPayCouponController.m
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMPayCouponController.h"
#import "HMSegmentedControl.h"
#import "JMUserCouponController.h"


@interface JMPayCouponController () <JMUserCouponControllerDelegate> {
    NSMutableArray *_itemArr;
    NSArray *_urlArr;
}

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@end

@implementation JMPayCouponController
- (void)setSegmentSectionTitle:(NSArray *)segmentSectionTitle {
    _segmentSectionTitle = segmentSectionTitle;
    NSString *str1 = [NSString stringWithFormat:@"可用优惠券(%@)",segmentSectionTitle[0]];
    NSString *str2 = [NSString stringWithFormat:@"不可用优惠券(%@)",segmentSectionTitle[1]];
    _segmentControl.sectionTitles = @[str1,str2];
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
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"使用优惠券" selecotr:@selector(backClick)];
    
    _itemArr = [NSMutableArray arrayWithObjects:@"可用优惠券",@"不可用优惠券", nil];
    NSString *usableUrlStr = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/coupon_able?cart_ids=%@&type=%@",Root_URL,self.cartID,@"usable"];
    NSString *disableUrlStr = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/coupon_able?cart_ids=%@&type=%@",Root_URL,self.cartID,@"disable"];
    _urlArr = @[usableUrlStr,disableUrlStr];
    [self.view addSubview:self.segmentControl];
    _segmentControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.baseScrollView];
    [self addChildController];
    [self removeToPage:0];

    
}
- (void)updateYouhuiquanmodel:(NSArray *)modelArr {
    if (_delegate && [_delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
        [_delegate updateYouhuiquanWithmodel:modelArr];
    }
}

- (void)addChildController {
    for (int i = 0 ; i < _itemArr.count; i++) {
        JMUserCouponController *couponVC = [[JMUserCouponController alloc] init];
        if (i == 0) {
            couponVC.isSelectedYHQ = self.isSelectedYHQ;
            couponVC.selectedModelID = self.selectedModelID;
            couponVC.couponNumber = self.couponNumber;
            couponVC.directBuyGoodsTypeNumber = self.directBuyGoodsTypeNumber;
            couponVC.delegate = self;
        }
        couponVC.couponStatus = i;
        couponVC.payCouponVC = self;
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
    JMUserCouponController *couponVC = self.childViewControllers[index];
    couponVC.urlString = _urlArr[index];
    couponVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:couponVC.view];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end





























































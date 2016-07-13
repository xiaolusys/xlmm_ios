//
//  JMExpiredCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMExpiredCouponController.h"
#import "MMClass.h"

@interface JMExpiredCouponController ()

@end

@implementation JMExpiredCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (NSInteger)couponCount {
    return 3;
}
- (NSString *)urlStr {
    return [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=3",Root_URL];
}
@end



















































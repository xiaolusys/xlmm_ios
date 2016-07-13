//
//  JMUsedCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUsedCouponController.h"
#import "MMClass.h"

@interface JMUsedCouponController ()

@end

@implementation JMUsedCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (NSInteger)couponCount {
    return 1;
}
- (NSString *)urlStr {
    return [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=1",Root_URL];
}
@end























































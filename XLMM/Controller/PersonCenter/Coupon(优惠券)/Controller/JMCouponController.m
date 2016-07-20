//
//  JMCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface JMCouponController ()



@end

@implementation JMCouponController {
    NSMutableArray *_titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"优惠券" selecotr:@selector(backClick:)];
    self.view.backgroundColor = [UIColor countLabelColor];
    
}
- (NSArray *)classArr {
    return @[@"JMUntappedCouponController",@"JMExpiredCouponController",@"JMUsedCouponController"];
}
- (NSArray *)titleArr {
    [SVProgressHUD showWithStatus:@"优惠券努力加载中......"];
    NSArray *countArr = @[@"0",@"3",@"1"];
    NSInteger count = 0;
    _titleArr = [NSMutableArray array];
    NSArray *tArr = @[@"未使用",@"已过期",@"已使用"];
    for (int i = 0; i < [self classArr].count; i++) {
        count = [countArr[i] integerValue];
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/get_user_coupons?status=%ld",Root_URL,count];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error != nil) {
            
        }else {
            
        }
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [_titleArr addObject:[NSString stringWithFormat:@"%@(%ld)",tArr[i],arr.count]];
    }
    [SVProgressHUD dismiss];
    return _titleArr;
}

- (void)backClick:(UIButton *)button{
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





























































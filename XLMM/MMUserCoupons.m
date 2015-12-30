
//
//  MMUserCoupons.m
//  XLMM
//
//  Created by younishijie on 15/11/2.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MMUserCoupons.h"
#import "MMClass.h"

@implementation MMUserCoupons

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createCouponValue];
        
    }
    return self;
}

- (void)createCouponValue{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons", Root_URL];
  //  NSLog(@"urlString = %@", string);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        _couponValue = 0;
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   // NSLog(@"json = %@", json);
    
    if (json == nil) {
        _couponValue = 0;
        return;
    }
    _couponValue = [[json objectForKey:@"count"] integerValue];
    //NSLog(@"_couponValue = %ld", (long)self.couponValue);
    
}



@end

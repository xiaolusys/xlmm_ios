
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
    NSString *urlString = [NSString stringWithFormat:@"%@", KUserCoupins_URL];
    NSLog(@"url = %@", urlString);
    NSInteger count = 0;
    while (true) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (data == nil) {
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //  NSLog(@"json = %@", dictionary);
        NSArray *array = [dictionary objectForKey:@"results"];
        for (NSDictionary *dic in array) {
            // 可用优惠券
            if ([[dic objectForKey:@"status"] integerValue] == 0 && [[dic objectForKey:@"poll_status"] integerValue] == 1) {
                count ++;
            }
            
        }
        
        urlString = [dictionary objectForKey:@"next"];
        if ([[dictionary objectForKey:@"next"]class] == [NSNull class]) {
//            NSLog(@"可用已用 下页为空");
            break;
        }
    }
    
    _couponValue = count;
    
}



@end

//
//  JMWithdrawShortController.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMWithdrawShortController : UIViewController
/**
 *  我的余额
 */
@property (nonatomic, assign) CGFloat myBalance;
/**
 *  提现原因
 */
@property (nonatomic, strong) NSString *descStr;

@end

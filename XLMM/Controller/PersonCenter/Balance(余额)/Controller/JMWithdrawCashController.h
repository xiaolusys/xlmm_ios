//
//  JMWithdrawCashController.h
//  XLMM
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^MoneyBlock)(CGFloat money);

@interface JMWithdrawCashController : UIViewController

@property (nonatomic, strong) NSDictionary *personCenterDict;

@property (nonatomic, assign) CGFloat myBlabce;

//@property (nonatomic,copy) MoneyBlock block;

@property (nonatomic, assign) BOOL isMaMaWithDraw;


@end

//
//  JMBillDetailController.h
//  XLMM
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBillDetailController : UIViewController

@property (nonatomic,assign) CGFloat withdrawMoney;

@property (nonatomic,assign) NSInteger surplusMoney;

@property (nonatomic,assign) NSInteger activeValue;

@property (nonatomic, assign) BOOL isActiveValue;

@property (nonatomic, assign) CGFloat withDrawF;

@property (nonatomic, strong) NSDictionary *accountDic;

@end

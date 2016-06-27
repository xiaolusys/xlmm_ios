//
//  JMRefundController.h
//  XLMM
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRefundController;
@protocol JMRefundControllerDelegate <NSObject>

- (void)Clickrefund:(JMRefundController *)click Refund:(NSString *)refund;

@end

@interface JMRefundController : UIViewController

@property (nonatomic,strong) NSDictionary *refundDic;

@property (nonatomic,weak) id<JMRefundControllerDelegate>delegate;

@end

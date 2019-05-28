//
//  JMOrderDetailController.h
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAllOrderModel.h"

@class JMOrderDetailController;
@protocol JMOrderDetailControllerDelegate <NSObject>

- (void)composeWithPopViewRefresh:(JMOrderDetailController *)orderVC;

@end

@interface JMOrderDetailController : UIViewController

@property (nonatomic, weak) id<JMOrderDetailControllerDelegate> delegate;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) JMAllOrderModel *allOrderModel;

@property (nonatomic, copy) NSString *orderTid;

@end

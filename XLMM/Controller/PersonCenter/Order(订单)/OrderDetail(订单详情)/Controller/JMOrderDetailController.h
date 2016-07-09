//
//  JMOrderDetailController.h
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DingdanModel.h"
#import "JMAllOrderModel.h"

@interface JMOrderDetailController : UIViewController

@property (nonatomic, copy) NSString *urlString;


@property (nonatomic, strong) JMAllOrderModel *allOrderModel;

@end

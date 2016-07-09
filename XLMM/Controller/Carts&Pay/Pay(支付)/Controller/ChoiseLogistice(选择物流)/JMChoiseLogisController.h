//
//  JMChoiseLogisController.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPopLogistcsModel.h"

@class JMChoiseLogisController;
@protocol JMChoiseLogisControllerDelegate <NSObject>

- (void)ClickLogistics:(JMChoiseLogisController *)click Model:(JMPopLogistcsModel *)model;

@end

@interface JMChoiseLogisController : UIViewController

@property (nonatomic,weak) id<JMChoiseLogisControllerDelegate>delegate;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger count;

@end

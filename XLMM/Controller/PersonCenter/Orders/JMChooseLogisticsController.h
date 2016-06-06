//
//  JMChooseLogisticsController.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMChooseLogisticsController;
@protocol JMChooseLogisticsControllerDelegate <NSObject>

- (void)ClickChoiseLogis:(JMChooseLogisticsController *)click Title:(NSString *)title;

@end

@interface JMChooseLogisticsController : UIViewController

@property (nonatomic,weak) id<JMChooseLogisticsControllerDelegate>delegate;


@end

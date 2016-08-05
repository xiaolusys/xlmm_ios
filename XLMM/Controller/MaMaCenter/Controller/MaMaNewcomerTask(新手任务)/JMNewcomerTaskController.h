//
//  JMNewcomerTaskController.h
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMNewcomerTaskController;
@protocol JMNewcomerTaskControllerDelegate <NSObject>

- (void)composeNewcomerTask:(JMNewcomerTaskController *)taskVC Index:(NSInteger)index;

@end

@interface JMNewcomerTaskController : UIViewController

@property (nonatomic, strong) NSArray *newsTaskArr;

@property (nonatomic, weak) id<JMNewcomerTaskControllerDelegate> delegate;

@end

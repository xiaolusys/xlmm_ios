//
//  JMPopLogistcsController.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPopLogistcsController;
@protocol JMPopLogistcsControllerDelegate <NSObject>

- (void)ClickLogistics:(JMPopLogistcsController *)click Title:(NSString *)title;

@end

@interface JMPopLogistcsController : UIViewController

@property (nonatomic,strong) NSMutableArray *dataSource;
/**
 *  用户地址ID
 */
@property (nonatomic,copy) NSString *goodsID;

@property (nonatomic,copy) NSString *logisticsStr;

@property (nonatomic,weak) id<JMPopLogistcsControllerDelegate>delegate;


@end

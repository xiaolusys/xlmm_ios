//
//  JMUserCouponController.h
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCouponModel,JMPayCouponController;
@protocol JMUserCouponControllerDelegate <NSObject>

- (void)updateYouhuiquanmodel:(NSArray *)modelArr;

@end

@interface JMUserCouponController : UIViewController

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) JMPayCouponController *payCouponVC;
@property (nonatomic, assign) NSInteger couponNumber;
@property (nonatomic, strong) NSNumber *directBuyGoodsTypeNumber;
@property (nonatomic, assign) BOOL isSelectedYHQ;
@property (nonatomic, copy) NSString *selectedModelID;
@property (assign, nonatomic) id <JMUserCouponControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger couponStatus;


@end

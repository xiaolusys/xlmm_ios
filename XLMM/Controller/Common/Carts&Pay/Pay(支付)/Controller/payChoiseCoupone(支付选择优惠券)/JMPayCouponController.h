//
//  JMPayCouponController.h
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCouponModel;
@protocol JMPayCouponControllerDelegate <NSObject>
- (void)updateYouhuiquanWithmodel:(NSArray *)modelArray;
@end

@interface JMPayCouponController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *cartID;
@property (nonatomic, assign) NSInteger couponNumber;
@property (nonatomic, strong) NSNumber *directBuyGoodsTypeNumber;
@property (nonatomic, assign) BOOL isSelectedYHQ;
@property (nonatomic, copy) NSString *selectedModelID;
@property (nonatomic, strong) NSDictionary *couponData;
@property (assign, nonatomic) id <JMPayCouponControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *segmentSectionTitle;


@end

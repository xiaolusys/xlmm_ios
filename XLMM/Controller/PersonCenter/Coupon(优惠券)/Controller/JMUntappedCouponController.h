//
//  JMUntappedCouponController.h
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPageViewBaseController.h"

//@class JMCouponModel;
//@protocol JMUsableCouponControllerDelegate <NSObject>
//
//
//- (void)updateYouhuiquanWithmodel:(JMCouponModel *)model;
//
//@end

@interface JMUntappedCouponController : JMPageViewBaseController

//@property (weak, nonatomic) id <JMUsableCouponControllerDelegate> delegate;

- (NSInteger)couponCount;

- (NSString *)urlStr;

//- (void)createUsedButton;

@end

/**
 *
 http://m.xiaolumeimei.com/rest/v1/usercoupons/get_user_coupons?status=3
 
 UNUSED = 0
 USED = 1
 FREEZE = 2
 PAST = 3
 USER_COUPON_STATUS = ((UNUSED, u"未使用"), (USED, u"已使用"), (FREEZE, u"冻结中"), (PAST, u"已经过期"))
 */

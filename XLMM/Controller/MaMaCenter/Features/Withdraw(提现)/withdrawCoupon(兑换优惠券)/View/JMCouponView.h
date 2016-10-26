//
//  JMCouponView.h
//  XLMM
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCouponView;
@protocol JMCouponViewDelegate <NSObject>

@optional
- (void)composeCouponBtn:(JMCouponView *)shareBtn Button:(UIButton *)button didClickBtn:(NSInteger)index;

@end

@interface JMCouponView : UIView

@property (nonatomic, assign) CGFloat myCouponBlance;

@property (nonatomic,weak) id<JMCouponViewDelegate> delegate;

@end

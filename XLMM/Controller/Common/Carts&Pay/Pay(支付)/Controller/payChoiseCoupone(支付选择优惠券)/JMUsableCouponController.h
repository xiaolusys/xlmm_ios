//
//  JMUsableCouponController.h
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCouponModel;
@protocol YouhuiquanDelegate <NSObject>


- (void)updateYouhuiquanmodel:(NSArray *)modelArr;

@end


@interface JMUsableCouponController : UIViewController

@property (nonatomic, assign) NSInteger couponNumber;
@property (nonatomic, strong) NSNumber *directBuyGoodsTypeNumber;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isSelectedYHQ;

@property (nonatomic, copy) NSString *selectedModelID;

@property (assign, nonatomic) id <YouhuiquanDelegate> delegate;

@end

//
//  JMSegmentController.h
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMCouponModel;
@protocol JMSegmentControllerDelegate <NSObject>


- (void)updateYouhuiquanWithmodel:(NSArray *)modelArray;

@end


@interface JMSegmentController : UIViewController<UIScrollViewDelegate>


@property (nonatomic, copy) NSString *cartID;
@property (nonatomic, assign) NSInteger couponNumber;

@property (nonatomic, assign) BOOL isSelectedYHQ;

@property (nonatomic, copy) NSString *selectedModelID;

@property (nonatomic, strong) NSDictionary *couponData;

@property (assign, nonatomic) id <JMSegmentControllerDelegate> delegate;

@end

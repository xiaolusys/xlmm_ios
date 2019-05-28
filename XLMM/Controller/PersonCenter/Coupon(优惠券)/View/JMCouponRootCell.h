//
//  JMCouponRootCell.h
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCouponModel;
@interface JMCouponRootCell : UITableViewCell


/**
 *  优惠券图片
 */
@property (nonatomic, strong) UIImageView *couponBackImage;



- (void)configData:(JMCouponModel *)couponModel Index:(NSInteger)index;

- (void)configUsableData:(JMCouponModel *)couponModel IsSelectedYHQ:(BOOL)isselectedYHQ SelectedID:(NSString *)selectedID Index:(NSInteger)index;

@end

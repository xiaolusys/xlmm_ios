//
//  JMCouponModel.h
//  XLMM
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMCouponModel : NSObject

/**
 *  优惠券编号
 */
@property (nonatomic, copy) NSString *coupon_no;
/**
 *  优惠券类型
 */
@property (nonatomic, copy) NSString *coupon_type;
/**
 *  优惠券类型说明
 */
@property (nonatomic, copy) NSString *coupon_type_display;
/**
 *  优惠券优惠金额
 */
@property (nonatomic, copy) NSString *coupon_value;
/**
 *  开始时间
 */
@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *customer;
/**
 *  结束时间
 */
@property (nonatomic, copy) NSString *deadline;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *head_img;
/**
 *
 */
@property (nonatomic, copy) NSString *couponID;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *poll_status;
/**
 *  优惠券使用场景
 */
@property (nonatomic, copy) NSString *pros_desc;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *start_use_time;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *template_id;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  满足使用的最大金额
 */
@property (nonatomic, copy) NSString *use_fee;
/**
 *  使用条件
 */
@property (nonatomic, copy) NSString *use_fee_des;

@property (nonatomic, copy) NSString *valid;

@property (nonatomic, copy) NSString *wisecrack;


@end


/**
 *  {
 "coupon_no" = yhq16071157830177ac96c;
 "coupon_type" = 1;
 "coupon_type_display" = "\U666e\U901a\U7c7b\U578b"; -- > 优惠券类型
 "coupon_value" = 30;
 created = "2016-07-11T10:16:23";  -- > 开始时间
 customer = 1;
 deadline = "2016-07-17T23:59:59"; -- > 结束时间
 "head_img" = "http://wx.qlogo.cn/mmopen/n24ek7Oc1iaXyxqzHobN7BicG5W1ljszSRWSdzaFeRkGGVwqjmQKTmicTylm8IkclpgDiaamWqZtiaTlcvLJ5z6x35wCKMWVbcYPU/0";
 id = 104387;
 nick = "meron@\U5c0f\U9e7f\U7f8e\U7f8e";  -- > 用户名称
 "poll_status" = 1;
 "pros_desc" = "\U5168\U573a\U901a\U7528"; -- > 使用场景
 "start_time" = "2016-07-11T10:16:23";
 "start_use_time" = "2016-07-11T10:16:23";
 status = 0;
 "template_id" = 83;
 title = "\U8fde\U8863\U88d9\U7cfb\U521730\U5143"; -- > 标题
 "use_fee" = 188;
 "use_fee_des" = "\U6ee1188\U53ef\U7528"; -- > 使用条件
 valid = 1;
 wisecrack = "";
 },
 */



























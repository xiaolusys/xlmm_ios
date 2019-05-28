//
//  JMMaMaExtraModel.h
//  XLMM
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMaMaExtraModel : NSObject


@property (nonatomic, copy) NSString *agencylevel;
/**
 *  当前等级
 */
@property (nonatomic, copy) NSString *agencylevel_display;
/**
 *  邀请链接
 */
@property (nonatomic, copy) NSString *invite_url;

@property (nonatomic, copy) NSString *next_agencylevel;
/**
 *  下一等级
 */
@property (nonatomic, copy) NSString *next_agencylevel_display;

@property (nonatomic, copy) NSString *next_level_exam_url;
/**
 *  剩余天数
 */
@property (nonatomic, copy) NSString *surplus_days;
/**
 *  是否可以提现 1.可以提现 0.兑换优惠券
 */
@property (nonatomic, copy) NSString *could_cash_out;
/**
 *  提现原因
 */
@property (nonatomic, copy) NSString *cashout_reason;
/**
 *  妈妈头像
 */
@property (nonatomic, copy) NSString *thumbnail;
/**
 *  2016.3.24号系统升级之前的收益
 */
@property (nonatomic, copy) NSString *his_confirmed_cash_out;

@property (nonatomic, copy) NSString *total_rank;

@end

/**
 *  "extra_info" =         {
 agencylevel = 2;
 "agencylevel_display" = VIP1;
 "cashout_reason" = "\U4e0d\U80fd\U63d0\U73b0";
 "could_cash_out" = 1;
 "invite_url" = "http://m.xiaolumeimei.com/pages/agency-invitation-res.html";
 "next_agencylevel" = 12;
 "next_agencylevel_display" = VIP2;
 "next_level_exam_url" = "http://m.xiaolumeimei.com/mall/activity/exam";
 "surplus_days" = 0;
 thumbnail = "http://wx.qlogo.cn/mmopen/n24ek7Oc1iaXyxqzHobN7BicG5W1ljszSRWSdzaFeRkGGVwqjmQKTmicTylm8IkclpgDiaamWqZtiaTlcvLJ5z6x35wCKMWVbcYPU/0";
 };
 */

//
//  JMProductSelectionListModel.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JMLevelInfoModel,JMEliteModel;
@interface JMProductSelectionListModel : NSObject

/**
 *  分类ID
 */
@property (nonatomic, copy) NSString *cid;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString *goodsID;
/**
 *  现价
 */
@property (nonatomic, copy) NSString *lowest_agent_price;
/**
 *  原价
 */
@property (nonatomic, copy) NSString *lowest_std_sale_price;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  下一等级返利佣金
 */
@property (nonatomic, copy) NSString *next_rebet_amount;
@property (nonatomic, copy) NSString *next_rebet_amount_desc;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *pic_path;
/**
 *  返利佣金
 */
@property (nonatomic, copy) NSString *rebet_amount;
@property (nonatomic, copy) NSString *rebet_amount_desc;
/**
 *  在卖人数
 */
@property (nonatomic, copy) NSString *sale_num;
@property (nonatomic, copy) NSString *sale_num_desc;
@property (nonatomic, copy) NSString *shop_products_num;

@property (nonatomic, strong) JMLevelInfoModel *level_info;

// 是否是精品商品
@property (nonatomic, assign) bool is_boutique;

@property (nonatomic, strong) JMEliteModel *elite_level_prices;


@end


@interface JMLevelInfoModel : NSObject


/**
 *  当前Vip等级
 */
@property (nonatomic, copy) NSString *agencylevel;
@property (nonatomic, copy) NSString *agencylevel_desc;
/**
 *  下一个Vip等级
 */
@property (nonatomic, copy) NSString *next_agencylevel;
@property (nonatomic, copy) NSString *next_agencylevel_desc;




@end


@interface JMEliteModel : NSObject

@property (nonatomic, copy) NSString *next_elite_level_price;
@property (nonatomic, copy) NSString *elite_level_price;


@end






/*
 "is_boutique": true,
 "elite_level_prices": {
 "next_elite_level_price": 50,
 "elite_level_price": 50
 */




/**
 *  {
 cid = 63;
 "elite_level_prices" =             {
 };
 id = 23419;
 "is_boutique" = 0;
 "level_info" =             {
 agencylevel = 2;
 "agencylevel_desc" = VIP1;
 "next_agencylevel" = 12;
 "next_agencylevel_desc" = VIP2;
 };
 "lowest_agent_price" = 69;
 "lowest_std_sale_price" = 139;
 name = "\U53ef\U7231\U72d0\U72f8\U56fe\U6848\U5957\U5934\U6bdb\U8863";
 "next_rebet_amount_desc" = "\U4f63\Uffe510";
 "pic_path" = "http://img.xiaolumeimei.com/MG_1476861929166.jpg";
 "rebet_amount_desc" = "\U4f63\Uffe58";
 "sale_num" = 4576;
 "sale_num_desc" = "4576\U4eba\U5728\U5356";
 "shop_products_num" = 10;
 }


 */






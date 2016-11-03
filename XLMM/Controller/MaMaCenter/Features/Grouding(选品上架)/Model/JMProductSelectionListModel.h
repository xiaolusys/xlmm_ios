//
//  JMProductSelectionListModel.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, strong) NSDictionary *level_info;



@end




/**
 *  {
 cid = "5-92";
 id = 20839;
 "level_info" =             {
 agencylevel = 2;
 "agencylevel_desc" = VIP1;
 "next_agencylevel" = 12;
 "next_agencylevel_desc" = VIP2;
 };
 "lowest_agent_price" = "39.9";
 "lowest_std_sale_price" = 98;
 name = "\U5341\U4e07\U4e2a\U4e3a\U4ec0\U4e488\U518c\U88c5";
 "next_rebet_amount" = 7;
 "next_rebet_amount_desc" = "\U4f637\Uffe5";
 "pic_path" = "http://img.xiaolumeimei.com/MG_1473757987036.jpg";
 "rebet_amount" = 6;
 "rebet_amount_desc" = "\U4f636\Uffe5";
 "sale_num" = 951;
 "sale_num_desc" = "951\U4eba\U5728\U5356";
 "shop_products_num" = 0;
 }

 */






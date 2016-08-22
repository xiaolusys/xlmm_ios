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
 *  现价
 */
@property (nonatomic, copy) NSString *agent_price;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSNumber *in_customer_shop;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic_path;
@property (nonatomic, copy) NSString *remain_num;
@property (nonatomic, copy) NSString *shop_product_num;
/**
 *  原价
 */
@property (nonatomic, copy) NSString *std_sale_price;

/**
 *  返现等级字典
 */
@property (nonatomic, strong) NSDictionary *level_info;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString *model_id;

@end




/**
 *  (lldb) po responseObject
 {
 count = 153;
 next = "http://staging.xiaolumeimei.com/rest/v2/products/my_choice_pro?category=0&page=2&page_size=20";
 previous = "<null>";
 results =     (
 {
 "agent_price" = "189.9";
 id = 41390;
 "in_customer_shop" = 0;
 "level_info" =             {
 agencylevel = 2;
 "agencylevel_desc" = VIP1;
 "next_agencylevel" = 12;
 "next_agencylevel_desc" = VIP2;
 "next_rebet_amount" = 0;
 "next_rebet_amount_des" = "\U4f63 \Uffe50.00";
 "rebet_amount" = 6;
 "rebet_amount_des" = "\U4f63 \Uffe56.00";
 "sale_num" = 761;
 "sale_num_des" = "761\U4eba\U5728\U5356";
 };
 name = "\U8d85\U7f8e\U5973\U88c5\U5916\U5957/\U56fe\U7247\U8272 A23*13";
 "pic_path" = "//img.alicdn.com/bao/uploaded/i4/TB1z7CKLpXXXXclXVXXXXXXXXXX_!!0-item_pic.jpg";
 "remain_num" = 40;
 "shop_product_num" = 2;
 "std_sale_price" = 498;
 },
 */







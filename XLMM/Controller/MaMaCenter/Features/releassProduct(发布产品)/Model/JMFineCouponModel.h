//
//  JMFineCouponModel.h
//  XLMM
//
//  Created by zhang on 16/11/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFineCouponModel : NSObject



@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *fineCouponModelID;
@property (nonatomic, copy) NSString *is_saleout;
@property (nonatomic, copy) NSString *lowest_agent_price;
@property (nonatomic, copy) NSString *lowest_std_sale_price;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *offshelf_time;
@property (nonatomic, copy) NSString *onshelf_time;
@property (nonatomic, copy) NSString *sale_state;
@property (nonatomic, copy) NSString *watermark_op;
@property (nonatomic, copy) NSString *web_url;









@end



/*
 {
 "category_id" = 94;
 "head_img" = "http://img.xiaolumeimei.com/MG_1454554636904taobaosns.jpg";
 id = 8148;
 "is_saleout" = 1;
 "lowest_agent_price" = "9.9";
 "lowest_std_sale_price" = "149.5";
 name = "\U8212\U9002\U67d4\U8f6f\U6447\U7c92\U7ed2\U6bdb\U6bef";
 "offshelf_time" = "2016-12-31T06:00:00";
 "onshelf_time" = "2016-11-24T22:00:00";
 "sale_state" = off;
 "watermark_op" = "";
 "web_url" = "https://m.xiaolumeimei.com/mall/product/details/8148";
 },

 
 */


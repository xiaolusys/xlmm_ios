//
//  NewCartsModel.h
//  XLMM
//
//  Created by younishijie on 15/10/19.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCartsModel : NSObject

@property (nonatomic, assign)int status;
@property (nonatomic, copy)NSString * sku_id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, assign)float price;
@property (nonatomic, assign)BOOL is_sale_out;
@property (nonatomic, copy)NSString * buyer_nick;
@property (nonatomic, assign)int num;
@property (nonatomic, copy)NSString * remain_time;
@property (nonatomic, assign)float std_sale_price;

@property (nonatomic, assign)float total_fee;
@property (nonatomic, copy)NSString * item_id;
@property (nonatomic, copy)NSString * pic_path;
@property (nonatomic, copy)NSString * sku_name;
//@property (nonatomic, copy)NSString * is_sale_out;

@property (nonatomic, assign)int ID;
@property (nonatomic, assign)int buyer_id;

@end

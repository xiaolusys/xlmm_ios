//
//  CartModel.h
//  XLMM
//
//  Created by younishijie on 15/9/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

//"status": 1,
//"sku_id": "62871",
//"title": "休闲格子连帽外套/黑色",
//"price": 79.0,
//"buyer_nick": "",
//"num": 1,
//"remain_time": "2015-09-05T17:32:43",
//"std_sale_price": 399.0,
//"total_fee": 79.0,
//"item_id": "16137",
//"pic_path": "https://mmbiz.qlogo.cn/mmbiz/yMhOQPTKhLuaf1JCLQPgPC324rXOIg8F3hmwI56ztlaf6uicDIzHaHkrRXibGxHK1r8BH8AWTLQKibknPTjiay4qtQ/0?wx_fmt=png",
//"sku_name": "大码4XL",
//"is_sale_out": false,
//"id": 51437,
//"buyer_id": 15977

@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * sku_id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * price;

@property (nonatomic, copy)NSString * buyer_nick;
@property (nonatomic, copy)NSString * num;
@property (nonatomic, copy)NSString * remain_time;
@property (nonatomic, copy)NSString * std_sale_price;

@property (nonatomic, copy)NSString * total_fee;
@property (nonatomic, copy)NSString * item_id;
@property (nonatomic, copy)NSString * pic_path;
@property (nonatomic, copy)NSString * sku_name;
@property (nonatomic, copy)NSString * is_sale_out;
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * buyer_id;
//@property (nonatomic, copy)NSString * sku_name;


@end

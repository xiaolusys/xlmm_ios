//
//  JMStoreUpModel.h
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMStoreUpModel : NSObject


@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *storeUpID;

@property (nonatomic, strong) NSDictionary *modelproduct;





@end










/**
 *  {
 created = "2016-08-06T09:19:54";
 id = 106;
 modelproduct =             {
 "head_img" = "//img.alicdn.com/imgextra/i3/2003375564/TB2vmQBqVXXXXb9XpXXXXXXXXXX_!!2003375564.jpg";
 id = 15734;
 "lowest_agent_price" = 0;
 "lowest_std_sale_price" = 0;
 name = "\U4eba\U6c14\U7206\U6b3e\U5361\U901a\U4eb2\U5b50\U88c5";
 "shelf_status" = off;
 "web_url" = "";
 };
 },

 */

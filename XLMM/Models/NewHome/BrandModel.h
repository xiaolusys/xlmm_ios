//
//  BrandModel.h
//  XLMM
//
//  Created by wulei on 5/4/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject
@property (nonatomic, strong)NSNumber *brandID;
@property (nonatomic, copy)NSString *brand_name;
@property (nonatomic, copy)NSString *brand_desc;
@property (nonatomic, copy)NSString *brand_pic;
@property (nonatomic, copy)NSString *brand_post;
@property (nonatomic, copy)NSString *brand_applink;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *end_time;

@end

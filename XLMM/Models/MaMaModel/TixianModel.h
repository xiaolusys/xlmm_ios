//
//  TixianModel.h
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TixianModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger xlmm;
@property (nonatomic, assign) float value_money;

@property (nonatomic, copy) NSString *get_cash_out_type_display;
@property (nonatomic, copy) NSString *get_status_display;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *created;

+ (instancetype)modelWithDiction:(NSDictionary *)dic;
- (instancetype)initWithDiction:(NSDictionary *)dic;

@end

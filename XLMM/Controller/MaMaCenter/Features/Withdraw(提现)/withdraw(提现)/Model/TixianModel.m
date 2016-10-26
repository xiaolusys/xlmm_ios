//
//  TixianModel.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianModel.h"

@implementation TixianModel

- (instancetype)initWithDiction:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _ID = [dic objectForKey:@"id"];
        _xlmm = [[dic objectForKey:@"xlmm"] integerValue];
        _value_money = [[dic objectForKey:@"value_money"] floatValue];
        _get_status_display = [dic objectForKey:@"get_status_display"];
        _get_cash_out_type_display = [dic objectForKey:@"get_cash_out_type_display"];
        _status = [dic objectForKey:@"status"];
        _created = [dic objectForKey:@"created"];
    
    }
    return self;
}

- (NSString *)description{
    NSString *string = [NSString stringWithFormat:@"xlmm:%ld\nvalue_money:%.2f\nget_status_display:%@\nstatus:%@\ncreate:%@\n\n", (long)self.xlmm, self.value_money, self.get_status_display, self.status, self.created];
    return string;
}

+ (instancetype)modelWithDiction:(NSDictionary *)dic{
    return [[[self class] alloc] initWithDiction:dic];
}

@end

//
//  FanceModel.m
//  XLMM
//
//  Created by younishijie on 16/1/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "FanceModel.h"

@implementation FanceModel


- (instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        _fanID = [[info objectForKey:@"id"] integerValue];
        _name = [info objectForKey:@"nick"];
        _imagelink = [info objectForKey:@"thumbnail"];
    }
    return self;
}
@end

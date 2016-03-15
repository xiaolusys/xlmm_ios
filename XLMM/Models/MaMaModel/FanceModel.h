//
//  FanceModel.h
//  XLMM
//
//  Created by younishijie on 16/1/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanceModel : NSObject

@property (nonatomic) NSInteger fanID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imagelink;

- (instancetype)initWithInfo:(NSDictionary *)info;

@end

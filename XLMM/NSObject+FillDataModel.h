//
//  NSObject+FillDataModel.h
//  XLMM
//
//  Created by younishijie on 15/9/24.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PromoteModel;

@interface NSObject (FillDataModel)

- (PromoteModel *)fillModel:(NSDictionary *)dic;
- (void)downloadDataWithURLString:(NSString *)aURL andSelector:(SEL)aSelector;

@end

//
//  JMDataManger.m
//  XLMM
//
//  Created by zhang on 17/3/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMDataManger.h"

@interface JMDataManger()

@property (nonatomic, strong) NSMutableDictionary *dataInfo;

@end

@implementation JMDataManger

+ (instancetype)sharedInstance {
    static JMDataManger *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.dataInfo = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (void)savePageInfo:(NSArray *)infoList menuId:(NSString *)menuId {
    if (menuId) {
        [_dataInfo setObject:[NSArray arrayWithArray:infoList] forKey:menuId];
    }
}

- (NSArray *)pageInfoWithMenuId:(NSString *)menuId {
    return [_dataInfo objectForKey:menuId];
}


@end

//
//  CSDropdownMenu.m
//  XLMM
//
//  Created by zhang on 17/3/18.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSDropdownMenu.h"

@implementation CSDropdownMenuIndexPath

- (instancetype)initWithCloum:(NSInteger)cloum row:(NSInteger)row {
    if (self = [super init]) {
        _cloumn = cloum;
        _row = row;
        _item = -1;
    }
    return self;
}
- (instancetype)initWithCloum:(NSInteger)cloum row:(NSInteger)row item:(NSInteger)item {
    if (self = [super init]) {
        _item = item;
    }
    return self;
}
+ (instancetype)indexPathWithCloum:(NSInteger)cloum row:(NSInteger)row {
    return [[self alloc] initWithCloum:cloum row:row];
}
+ (instancetype)indexPathWithCloum:(NSInteger)cloum row:(NSInteger)row item:(NSInteger)item {
    return [[self alloc] initWithCloum:cloum row:row item:item];
}


@end


@implementation CSDropdownMenu


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
}





@end







































































//
//  ActivityView.m
//  XLMM
//
//  Created by apple on 16/3/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        [self createImage];
    }
    return self;
}

- (void)createImage {
    self.imageV = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.imageV];
//    self.imageV.backgroundColor = [UIColor redColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

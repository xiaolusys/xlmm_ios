//
//  UILabel+CustomLabel.m
//  XLMM
//
//  Created by younishijie on 16/1/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)


- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.textColor = textColor;
        self.font = font;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end

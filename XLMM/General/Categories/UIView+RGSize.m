//
//  UIView+RGSize.m
//  YouZhi
//
//  Created by roroge on 15/3/19.
//  Copyright (c) 2015年 com.roroge. All rights reserved.
//

#import "UIView+RGSize.h"

@implementation UIView (RGSize)

- (CGFloat)cs_x {
    return self.frame.origin.x;
}
- (void)setCs_x:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)cs_y {
    return self.frame.origin.y;
}
- (void)setCs_y:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)cs_w {
    return self.frame.size.width;
}
- (void)setCs_w:(CGFloat)w {
    CGRect rect = self.frame;
    rect.size.width = w;
    self.frame = rect;
}

- (CGFloat)cs_h {
    return self.frame.size.height;
}
- (void)setCs_h:(CGFloat)h {
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
}
- (CGFloat)cs_centerX {
    return self.center.x;
}
- (void)setCs_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)cs_centerY {
    return self.center.y;
}
- (void)setCs_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)cs_max_X {
    return CGRectGetMaxX(self.frame);
}
- (void)setCs_max_X:(CGFloat)cs_max_X {
}
- (CGFloat)cs_max_Y {
    return CGRectGetMaxY(self.frame);
}
- (void)setCs_max_Y:(CGFloat)cs_max_Y {
}
- (CGSize)cs_size {
    return self.frame.size;
}
- (void)setCs_size:(CGSize)cs_size {
    CGRect frame = self.frame;
    frame.size = cs_size;
    self.frame = frame;
}
- (CGPoint)cs_origin {
    return self.frame.origin;
}
- (void)setCs_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGFloat)cs_top {
    return self.frame.origin.y;
}
- (void)setCs_top:(CGFloat)top {
    self.frame = CGRectMake(self.cs_left, top, self.cs_w, self.cs_h);
}
- (CGFloat)cs_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setCs_bottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.cs_left, bottom - self.cs_h, self.cs_w, self.cs_h);
}
- (CGFloat)cs_left {
    return self.frame.origin.x;
}
- (void)setCs_left:(CGFloat)left {
    self.frame = CGRectMake(left, self.cs_top, self.cs_w, self.cs_h);
}
- (CGFloat)cs_right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setCs_right:(CGFloat)right {
    self.frame = CGRectMake(right - self.cs_w, self.cs_top, self.cs_w, self.cs_h);
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)leftAdd:(CGFloat)add{
    CGRect frame = self.frame;
    frame.origin.x += add;
    self.frame = frame;
}
- (void)topAdd:(CGFloat)add{
    CGRect frame = self.frame;
    frame.origin.y += add;
    self.frame = frame;
}
- (void)widthAdd:(CGFloat)add {
    CGRect frame = self.frame;
    frame.size.width += add;
    self.frame = frame;
}
- (void)heightAdd:(CGFloat)add {
    CGRect frame = self.frame;
    frame.size.height += add;
    self.frame = frame;
}



@end












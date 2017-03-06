//
//  UIView+RGSize.h
//  YouZhi
//
//  Created by roroge on 15/3/19.
//  Copyright (c) 2015年 com.roroge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RGSize)

@property (nonatomic) CGFloat cs_x;
@property (nonatomic) CGFloat cs_y;
@property (nonatomic) CGFloat cs_w;
@property (nonatomic) CGFloat cs_h;

@property (nonatomic, assign) CGFloat cs_centerX;
@property (nonatomic, assign) CGFloat cs_centerY;
@property (nonatomic,assign) CGFloat cs_max_X;
@property (nonatomic,assign) CGFloat cs_max_Y;

@property (nonatomic) CGPoint cs_origin;
@property (nonatomic) CGSize cs_size;




@property (nonatomic, assign) CGFloat cs_top;
@property (nonatomic, assign) CGFloat cs_bottom;
@property (nonatomic, assign) CGFloat cs_left;
@property (nonatomic, assign) CGFloat cs_right;



@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
- (void)topAdd:(CGFloat)add;
- (void)leftAdd:(CGFloat)add;
- (void)widthAdd:(CGFloat)add;
- (void)heightAdd:(CGFloat)add;

@end

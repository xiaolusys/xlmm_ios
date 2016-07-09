//
//  JMLineView.m
//  XLMM
//
//  Created by zhang on 16/5/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLineView.h"

@implementation JMLineView


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context,0.5);//线宽
    CGContextSetRGBStrokeColor(context, 222/255.0, 223/255.0, 224/255.0, 1.0);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, 64);//起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, 64);//终点坐标
    
    CGContextMoveToPoint(context, 0, 124);//起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, 124);//终点坐标
    
    CGContextMoveToPoint(context, 0, 184);//起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, 184);//终点坐标
    
    CGContextStrokePath(context);
    
    
    
}

@end


































//
//  DotLineView.m
//  DotLineDemo
//
//  Created by younishijie on 16/3/23.
//  Copyright © 2016年 上海己美网络科技有限公司. All rights reserved.
//

#import "DotLineView.h"

@implementation DotLineView

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"init");
        _color = color;
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)setNeedsDisplay{
//    
//}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:rect];
    [shapeLayer setPosition:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
  //  [shapeLayer setPosition:CGPointZero];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:self.color.CGColor];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:@[@2, @3]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable(); // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    
    CGPathMoveToPoint(path, NULL, rect.origin.x,rect.origin.y);
    CGPathAddLineToPoint(path, NULL,rect.origin.x,rect.origin.y + rect.size.height);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
    
}


@end

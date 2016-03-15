//
//  ArrowView.m
//  ArrowView
//
//  Created by linaicai on 14-5-26.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

#import "ArrowView.h"

//箭头的高度
#define Arror_height 8
//圆角度数
#define radius 5.0

//箭头的位置
#define Arror_Left 50   //当箭头在左边时，箭头离最顶部的距离
#define Arror_Right 60  //当箭头在右边，箭头离最顶部的距离
#define Arror_Top 250    //当箭头在顶部时，箭头离最左边的距离
#define Arror_Bottom 150 //当箭头在底部时，箭头离最左边的距离

//填充色
#define backgroundColor [UIColor orangeColor]

//动画时间
#define DurationTime 0.5


@implementation ArrowView

- (instancetype)initWithFrame:(CGRect)frame style:(UIArrowViewSytle)style height:(CGFloat)height
{
    
    self.style=style;
    self.height = height;
    
    return [self initWithFrame:frame];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
   
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)getDrawPath_ArrowLeft:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    
	CGFloat minx = CGRectGetMinX(rrect)+Arror_height,
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect);
    
    CGContextMoveToPoint(context, minx,Arror_Left+Arror_height);
    CGContextAddLineToPoint(context,minx-Arror_height, Arror_Left);
    CGContextAddLineToPoint(context,minx, Arror_Left-Arror_height);
    
    CGContextAddArcToPoint(context, minx, miny, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, Arror_Left+Arror_height, radius);
    CGContextClosePath(context);

}
- (void)getDrawPath_ArrowRight:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    
	CGFloat minx = CGRectGetMinX(rrect),
    maxx = CGRectGetMaxX(rrect)-Arror_height;
	CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect);
    
    
    CGContextMoveToPoint(context, maxx, Arror_Right+Arror_height);
    CGContextAddLineToPoint(context,maxx+Arror_height, Arror_Right);
    CGContextAddLineToPoint(context,maxx,Arror_Right-Arror_height);
    
    CGContextAddArcToPoint(context, maxx, miny, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, minx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, maxx, Arror_Right+Arror_height, radius);
    CGContextClosePath(context);

}
- (void)getDrawPath_ArrowTop:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    
	CGFloat minx = CGRectGetMinX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    
    maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, Arror_Top+Arror_height, miny+Arror_height);
    CGContextAddLineToPoint(context,Arror_Top, miny);
    CGContextAddLineToPoint(context,Arror_Top-Arror_height, miny+Arror_height);
    
    CGContextAddArcToPoint(context, minx, miny+Arror_height, minx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, miny+Arror_height, Arror_Top, miny+Arror_height, radius);
    CGContextClosePath(context);

}
- (void)getDrawPath_ArrowBottom:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, Arror_Bottom+Arror_height, maxy);
    CGContextAddLineToPoint(context,Arror_Bottom, maxy+Arror_height);
    CGContextAddLineToPoint(context,Arror_Bottom-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);

}

- (void)getDrawPath_ArrowBottom:(CGContextRef)context arrowBottom:(CGFloat)bottom;
{
    CGRect rrect = self.bounds;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, bottom+Arror_height, maxy);
    CGContextAddLineToPoint(context,bottom, maxy+Arror_height);
    CGContextAddLineToPoint(context,bottom-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    
}
-(void)drawInContext:(CGContextRef)context height:(CGFloat)bottom
{
	
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    switch (self.style) {
        case ArrowView_Left:{
            [self getDrawPath_ArrowLeft:context];
            break;
        }
        case ArrowView_Right:{
            [self getDrawPath_ArrowRight:context];
            break;
        }
        case ArrowView_Top:{
            [self getDrawPath_ArrowTop:context];
            break;
        }
        case ArrowView_Bottom:{
            [self getDrawPath_ArrowBottom:context arrowBottom:bottom];
            break;
        }
            
        default:{
            
            break;
        }
    }
    CGContextFillPath(context);
   
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    [self drawInContext:UIGraphicsGetCurrentContext() height:self.height];
    //设置阴影颜色，透明度，偏移量
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    self.alpha = 0.8;
    
   

}
- (void)hidArrowView:(BOOL)animated
{
    if (animated) {
            //开始动画
        [UIView beginAnimations:nil context:nil];
            //设定动画持续时间
        [UIView setAnimationDuration:DurationTime];
            //动画的内容
         [self setAlpha:0.0];
            //动画结束
        [UIView commitAnimations];
    }
    else
    {
         [self setAlpha:0.0];
    }
}
- (void)showArrowView:(BOOL)animated
{
    if (animated) {
            //开始动画
        [UIView beginAnimations:@"show" context:nil];
            //设定动画持续时间
        [UIView setAnimationDuration:DurationTime];
            //动画的内容
        [self setAlpha:1.0];
            //动画结束
        [UIView commitAnimations];
    }
    else
    {
         [self setAlpha:1.0];
    }

}
- (void)dismissArrowView:(BOOL)animated
{
    if (animated) {
            //开始动画
        [UIView beginAnimations:nil context:nil];
            //设定动画持续时间
        [UIView setAnimationDuration:DurationTime];
            //动画的内容
        [self removeFromSuperview];
            //动画结束 
        [UIView commitAnimations];
    }
    else
    {
        [self removeFromSuperview];
    }
}
- (void)addUIButtonWithTitle:(NSArray *)title
{
    for (NSInteger i=0; i<title.count; i++) {
        //这里的按钮只有标题，您可以自行添加按钮图片，大小自己调整
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(15*i+i*60, 15,60 , 60)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        [button setTag:i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
-(IBAction)clickButton:(id)sender
{
    UIButton *button=(UIButton *)sender;
    self.selectBlock(button);
    [self hidArrowView:YES];
}
@end

//
//  CountdownView.m
//  XLMM
//
//  Created by younishijie on 16/1/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CountdownView.h"
#import "UIColor+RGBColor.h"
#import "UILabel+CustomLabel.h"

#define PI 3.14159265358979323846  

@implementation CountdownView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
   
    UIImage *image = [UIImage imageNamed:@"countdowmBackImage.png"];
    
    [image drawInRect:self.bounds];

 
  
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*写文字*/
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
   // UIFont  *font = [UIFont boldSystemFontOfSize:15.0];//设置
//    [@"画圆：" drawInRect:CGRectMake(10, 20, 80, 20) withFont:font];
//    [@"画线及孤线：" drawInRect:CGRectMake(10, 80, 100, 20) withFont:font];
//    [@"画矩形：" drawInRect:CGRectMake(10, 120, 80, 20) withFont:font];
//    [@"画扇形和椭圆：" drawInRect:CGRectMake(10, 160, 110, 20) withFont:font];
//    [@"画三角形：" drawInRect:CGRectMake(10, 220, 80, 20) withFont:font];
//    [@"画圆角矩形：" drawInRect:CGRectMake(10, 260, 100, 20) withFont:font];
//    [@"画贝塞尔曲线：" drawInRect:CGRectMake(10, 300, 100, 20) withFont:font];
//    [@"图片：" drawInRect:CGRectMake(10, 340, 80, 20) withFont:font];
    
    /*画圆*/
    //边框圆
    [[UIColor orangeThemeColor] set];
    CGPoint center = self.center;
    NSLog(@"%@", NSStringFromCGPoint(center));
    
    CGContextSetRGBStrokeColor(context,245/255.0,166/255.0,35/255.0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 3.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, 125, 125, 106.5, -PI/6.0*5, 0.8*PI, 1); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    self.alpha = 1;
    
  
    [self initCircleView];
    
    [self initLabel];

    
}

- (void)initCircleView{
    bigCircleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    bigCircleView.alpha = 0.3;
    bigCircleView.backgroundColor = [UIColor orangeThemeColor];
    bigCircleView.center = CGPointMake(32, 72);
    bigCircleView.layer.cornerRadius = 8;
    [self addSubview:bigCircleView];
    littleCircleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    littleCircleView.backgroundColor = [UIColor orangeThemeColor];
    littleCircleView.center = bigCircleView.center;
    littleCircleView.layer.cornerRadius = 5;
    [self addSubview:littleCircleView];
}

- (void)initLabel{
    UIFont *font = [UIFont systemFontOfSize:12];
    UIColor *color = [UIColor blackColor];
    number3Label = [[UILabel alloc] initWithFrame:CGRectMake(240, 120, 10, 10) font:font textColor:color text:@"3"] ;
    number9Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 10, 10) font:font textColor:color text:@"9"];
    number6Label = [[UILabel alloc] initWithFrame:CGRectMake(120, 240, 10, 10) font:font textColor:color text:@"6"];
    number12Label = [[UILabel alloc] initWithFrame:CGRectMake(118, 0, 14, 10) font:font textColor:color text:@"12"];
    number12Label.textColor = [UIColor orangeThemeColor];
    [self addSubview:number3Label];
    [self addSubview:number6Label];
    [self addSubview:number9Label];
    [self addSubview:number12Label];
    
  
    
}




@end

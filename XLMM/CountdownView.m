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

@implementation CountdownView{
    UIBezierPath *path;
    NSDate *todate;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
     
        [self initCircleView];
        [self initLabel];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
  
    UIImage *image = [UIImage imageNamed:@"countdowmBackImage.png"];
    [image drawInRect:self.bounds];
    
    UIBezierPath * path0 = [[UIBezierPath alloc] init];
    [[UIColor orangeThemeColor]set];
    CGFloat startAngle, endAngle;
    
    
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int hour = (int)[comps hour];
    int minute = (int)[comps minute];
    
    int summinete = hour * 60 + minute;
    
   
    
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setMinute:0];
    [endTime setSecond:0];
    
    
    if (hour < 10) {
        [self updateCircleViewWithCenter:(CGPointMake(32, 72))];
        startAngle = PI * 7/6.0;
        [endTime setHour:10];
    } else if (hour >= 10 && hour < 12){
        
         [self updateCircleViewWithCenter:(CGPointMake(125, 19))];
        startAngle = PI * 3/2.0;
        [endTime setHour:12];
        
    } else if (hour >= 12 && hour < 14){
         [self updateCircleViewWithCenter:(CGPointMake(217, 72))];
        startAngle = PI * 11/6.0;
        [endTime setHour:14];
        
    } else if (hour >= 14 && hour < 16){
         [self updateCircleViewWithCenter:(CGPointMake(216, 180))];
        startAngle = PI * 1/6.0;
        [endTime setHour:16];
        
        
    } else if (hour >= 16 && hour < 18){
         [self updateCircleViewWithCenter:(CGPointMake(125, 231))];
        startAngle = PI *1/2.0;
        [endTime setHour:18];
        
    } else if (hour >= 18){
        bigCircleView.hidden = YES;
        littleCircleView.hidden = YES;
    }
    // 设置endAngle。。。
    endAngle = PI * summinete / 360.0 - PI * 0.5;
    
    todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date

    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
   
    
    //用来得到具体的时差
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;
    
    
    string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour], (long)[d minute], (long)[d second]];
    
    timeLabel.text = string;

    
    [path0 addArcWithCenter:CGPointMake(125, 125) radius:106.5 startAngle:startAngle endAngle:endAngle clockwise:NO];
    path0.lineWidth = 4;
    [path0 stroke];

    
}

- (void)updateCircleViewWithCenter:(CGPoint)center{
    bigCircleView.center = center;
    littleCircleView.center = center;
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
    topLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 90, 30) font:[UIFont systemFontOfSize:22] textColor:[UIColor countLabelColor]text:@"倒计时"];
    [self addSubview:topLabel];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 200, 40)];
    timeLabel.textColor = [UIColor orangeThemeColor];
    timeLabel.text = @"       ";
    timeLabel.font = [UIFont systemFontOfSize:33];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 150, 200, 20) font:[UIFont systemFontOfSize:14] textColor:[UIColor countLabelColor] text:@"开始今天第一轮特卖"];
    [self addSubview:infoLabel];
  
   
}

- (void)updateTimeView{
   // NSLog(@"更新数据");
    
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
 
    
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;
    
  
        string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour], (long)[d minute], (long)[d second]];
    
    timeLabel.text = string;
}




@end

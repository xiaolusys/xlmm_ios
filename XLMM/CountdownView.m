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
    [path0 addArcWithCenter:CGPointMake(125, 125) radius:106.5 startAngle:-PI *5/6.0 endAngle:arc4random()%100/100.0 * PI clockwise:NO];
    path0.lineWidth = 4;
    [path0 stroke];

    
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
    NSLog(@"更新数据");
    
    [self drawRect:self.frame];
    
    
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
    int nextday = day + 1;
    
    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:nextday];
    [endTime setHour:10];
    [endTime setMinute:0];
    [endTime setSecond:0];
    
    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;
    
  
        string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour], (long)[d minute], (long)[d second]];
    
    timeLabel.text = string;
}




@end

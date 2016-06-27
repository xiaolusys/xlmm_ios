//
//  MaMaChartTableViewCell.m
//  XLMM
//
//  Created by 张迎 on 16/1/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaChartTableViewCell.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "MMClass.h"

@implementation MaMaChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabel];
//        [self addSubview:[self chart2:self.chartData]];
    }
    return self;
}

- (void)createLabel {
    self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, [UIScreen mainScreen].bounds.size.width - 150, 30)];
    self.orderNum.text = @"";
    self.orderNum.textColor = [UIColor textDarkGrayColor];
    self.orderNum.font = [UIFont systemFontOfSize:14];
    self.orderNum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.orderNum];
}

- (void)createChart:(NSMutableArray *)chartData {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 100)];
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, 100);
    scrollView.contentOffset = CGPointMake(0, 0);
    [self addSubview:scrollView];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    
    [scrollView addSubview:[self chart2:chartData]];
}

-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 7;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    
    //    lineChart.labelForIndex = ^(NSUInteger item) {
    //         return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    //    };
    //
    //    lineChart.labelForValue = ^(CGFloat value) {
    //        return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%.f €", value];
    //    };
    
    self.tag = 14;
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 1.0;
    
    [self.lineChart setChartData:chartData];
    return self.lineChart;
}



- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

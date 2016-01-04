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

@implementation MaMaChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabel];
        [self addSubview:[self chart2]];
    }
    return self;
}

- (void)createLabel {
    self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, [UIScreen mainScreen].bounds.size.width - 150, 30)];
    self.orderNum.text = @"今日订单3  今日收入6.6";
    self.orderNum.textColor = [UIColor colorWithRed: 98/256.0 green: 98/256.0 blue:98/256.0 alpha:1.0];
    self.orderNum.font = [UIFont systemFontOfSize:14];
    self.orderNum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.orderNum];
}

-(FSLineChart*)chart2 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i=0;i<7;i++) {
        chartData[i] = [NSNumber numberWithFloat:(float)i / 30.0f + (float)(rand() % 100) / 200.0f];
    }
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(10, 35, [UIScreen mainScreen].bounds.size.width - 20, 100)];
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

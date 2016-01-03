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
        [self addSubview:[self chart2]];
    }
    return self;
}

-(FSLineChart*)chart2 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i=0;i<7;i++) {
        chartData[i] = [NSNumber numberWithFloat:(float)i / 30.0f + (float)(rand() % 100) / 200.0f];
    }
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 1;
    lineChart.horizontalGridStep = 6;
    lineChart.color = [UIColor fsOrange];
    lineChart.fillColor = nil;
    
    //    lineChart.labelForIndex = ^(NSUInteger item) {
    //         return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    //    };
    //
    //    lineChart.labelForValue = ^(CGFloat value) {
    //        return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%.f €", value];
    //    };
    
    lineChart.bezierSmoothing = NO;
    
    [lineChart setChartData:chartData];
    return lineChart;
}



- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

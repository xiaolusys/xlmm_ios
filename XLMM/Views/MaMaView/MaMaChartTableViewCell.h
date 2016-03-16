//
//  MaMaChartTableViewCell.h
//  XLMM
//
//  Created by 张迎 on 16/1/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSLineChart;

@interface MaMaChartTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *orderNum;
@property (nonatomic, strong)FSLineChart *lineChart;

- (void)createChart:(NSMutableArray *)chartData;
@end
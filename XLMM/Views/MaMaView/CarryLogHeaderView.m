//
//  CarryLogHeaderView.m
//  XLMM
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CarryLogHeaderView.h"

@implementation CarryLogHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)yearLabelAndTotalMoneyLabelText:(NSString *)year
                                  total:(NSString *)total {
//    NSString *string = [year substringToIndex:10];
    self.yearLabel.text = year;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总收益%@", total];
}

- (void)shareYearLabelAndTotalMoneyLabelText:(NSString *)year
                                  total:(NSString *)total {
    NSString *str = [year substringToIndex:7];
    self.yearLabel.text = str;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总收益%@", total];
}

- (void)activeHeaderViewYearAndDay:(NSString *)year
                             total:(NSString *)total {
    self.yearLabel.text = year;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"日活跃%@", total];
}

@end

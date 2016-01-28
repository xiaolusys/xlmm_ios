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
    self.yearLabel.text = year;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总收益%@", total];
}

@end
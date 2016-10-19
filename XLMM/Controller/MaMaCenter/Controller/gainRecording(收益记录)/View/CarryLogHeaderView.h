//
//  CarryLogHeaderView.h
//  XLMM
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarryLogHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

- (void)yearLabelAndTotalMoneyLabelText:(NSString *)year
                                  total:(NSString *)total;
- (void)shareYearLabelAndTotalMoneyLabelText:(NSString *)year
                                       total:(NSString *)total;
- (void)activeHeaderViewYearAndDay:(NSString *)year
                             total:(NSString *)total;
@end

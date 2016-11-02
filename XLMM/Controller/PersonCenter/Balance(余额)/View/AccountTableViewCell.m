//
//  AccountTableViewCell.m
//  XLMM
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "AccountModel.h"

@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataOfCell:(AccountModel *)accountM {
    //budget_type 0收入1支出
    self.statusLabel.text = accountM.get_status_display;
    self.timeLabel.text = accountM.budget_date;
    self.sourceLabel.text = accountM.desc;
    
    if ([accountM.budget_type boolValue]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"- %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor textDarkGrayColor];
    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor orangeThemeColor];
    }
    
}
@end

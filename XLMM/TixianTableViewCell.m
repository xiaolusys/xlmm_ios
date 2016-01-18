//
//  TixianTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianTableViewCell.h"

@implementation TixianTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillModel:(TixianModel *)model{
    self.timeLabel.text = model.created;
    self.infoLabel.text = model.get_status_display;
    self.jineLabel.text= [NSString stringWithFormat:@"%.2f", model.value_money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

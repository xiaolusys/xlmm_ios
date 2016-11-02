//
//  HuoyuezhiTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/3/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HuoyuezhiTableViewCell.h"
#import "HuoyuezhiModel.h"

@implementation HuoyuezhiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataOfCell:(HuoyuezhiModel *)activeM {
    self.timeLabel.text = [NSString jm_subWithHourAndMinute:activeM.created];
    self.statusLabel.text = activeM.status_display;
    self.desLabel.text = activeM.value_description;
    self.carryLabel.text = [NSString stringWithFormat:@"＋%@", activeM.value_num];
}




@end

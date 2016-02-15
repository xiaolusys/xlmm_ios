//
//  MaMaShareSubsidiesViewCell.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaShareSubsidiesViewCell.h"
#import "ShareClickModel.h"
#import "CarryLogModel.h"


@implementation MaMaShareSubsidiesViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCell:(CarryLogModel *)clickModel {
    NSMutableString *timestext= [NSMutableString stringWithString:clickModel.created];
    NSRange range;
    range = [timestext rangeOfString:@"T"];
    [timestext replaceCharactersInRange:range withString:@" "];
    self.click_time.text = timestext;
}

@end

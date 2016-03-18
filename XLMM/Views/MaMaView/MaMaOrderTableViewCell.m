//
//  MaMaOrderTableViewCell.m
//  XLMM
//
//  Created by 张迎 on 16/1/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaOrderTableViewCell.h"
#import "MaMaOrderModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+RGBColor.h"


@implementation MaMaOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataOfCell:(MaMaOrderModel *)orderM {
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:orderM.sku_img] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.imageV.layer.borderWidth = 0.5;
   self.purchaser.text = orderM.contributor_nick;
//    self.purchaser.text = orderM.linkname;
    self.purchaser.font = [UIFont systemFontOfSize:13];
    
    self.rebate.text = [NSString stringWithFormat:@"+%.2f", [orderM.carry_num floatValue]];
    
    self.orderStatic.text = orderM.status_display;
    self.orderStatic.font = [UIFont systemFontOfSize:12];
   

    self.times.text = [self dealDate:orderM.created];
    self.times.font = [UIFont systemFontOfSize:12];
}

- (NSString *)dealDate:(NSString *)str {
    NSArray *strarray = [str componentsSeparatedByString:@"T"];
    NSString *hour = strarray[1];
    NSString *time = [hour substringToIndex:5];
    return time;
}

@end

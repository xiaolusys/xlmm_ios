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
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:orderM.pic_path]];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
    self.imageV.layer.borderWidth = 0.5;
//    self.purchaser.text = orderM.wxordernick;
    self.purchaser.text = @"购买人：小鹿美美";
    self.purchaser.font = [UIFont systemFontOfSize:13];
    
    self.rebate.text = [NSString stringWithFormat:@"%@", orderM.rebeta_cash];
//    self.rebate.textColor = [UIColor orangeColor];
    self.fanyong.text = @"反佣";
    self.fanyong.font = [UIFont systemFontOfSize:13];
    
    self.orderStatic.text = orderM.get_status_display;
    self.orderStatic.font = [UIFont systemFontOfSize:12];
    
    self.times.text = [NSString stringWithFormat:@"今天 %@", orderM.time_display];
    self.times.font = [UIFont systemFontOfSize:12];
}

@end

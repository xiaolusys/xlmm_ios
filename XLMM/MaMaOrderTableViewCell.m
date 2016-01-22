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
    self.imageV.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.imageV.layer.borderWidth = 0.5;
//    self.purchaser.text = orderM.wxordernick;
    self.purchaser.text = @"小公举购买";
    self.purchaser.font = [UIFont systemFontOfSize:13];
    
    self.rebate.text = [NSString stringWithFormat:@"%.2f", [orderM.rebeta_cash floatValue]];
    
    self.orderStatic.text = orderM.get_status_display;
    self.orderStatic.font = [UIFont systemFontOfSize:12];
   
    NSMutableString *timestext= [NSMutableString stringWithString:orderM.shoptime];
    NSRange range;
    range = [timestext rangeOfString:@"T"];
    [timestext replaceCharactersInRange:range withString:@" "];
    range = NSMakeRange(0, 10);
    [timestext deleteCharactersInRange:range];
    range = NSMakeRange(timestext.length - 4, 3);
    [timestext deleteCharactersInRange:range];
   
    self.times.text = timestext;
    self.times.font = [UIFont systemFontOfSize:12];
}

@end

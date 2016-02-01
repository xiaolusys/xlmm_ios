//
//  FensiTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/1/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "FensiTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Encrypto.h"
#import "NSString+URL.h"
#import "UIColor+RGBColor.h"

@implementation FensiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillData:(FanceModel *)model{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[model.imagelink URLEncodedString]]];
    self.picImageView.layer.cornerRadius = 8;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.picImageView.layer.masksToBounds = YES;
    self.name.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

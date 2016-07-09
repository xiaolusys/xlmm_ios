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
#import "FanceModel.h"
#import "VisitorModel.h"

@implementation FensiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)fillData:(FanceModel *)model{
    if (model.fans_thumbnail.length == 0) {
        self.picImageView.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[model.fans_thumbnail JMUrlEncodedString]]];
    }
    
    self.picImageView.layer.cornerRadius = 30;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.picImageView.layer.masksToBounds = YES;
    self.name.text = model.fans_nick;
    
    self.desLabel.text = model.fans_description;
    self.timeLabel.text = [self dealTime:model.created];
    
}

- (void)fillVisitorData:(VisitorModel *)model {
    if (model.visitor_img.length == 0) {
        self.picImageView.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[model.visitor_img JMUrlEncodedString]]];
    }
    
    self.picImageView.layer.cornerRadius = 30;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.picImageView.layer.masksToBounds = YES;
    self.name.text = model.visitor_nick;
    
    self.desLabel.text = model.visitor_description;

    self.timeLabel.text = [self dealDate:model.created];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)dealTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *year = arr[0];
    NSString *time = [year substringFromIndex:5];
    return time;
}

- (NSString *)dealVisitorTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *year = arr[1];
    NSString *time = [year substringToIndex:5];
    return time;
}

- (NSString *)dealDate:(NSString *)str {
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:str];
    [String1 replaceCharactersInRange:NSMakeRange(10, 1) withString:@" "];
    
    NSString *string2 = [NSString stringWithFormat:@"%@",String1];
    NSString *string3 = [string2 substringWithRange:NSMakeRange(5,11)];
    return string3;
}

@end




















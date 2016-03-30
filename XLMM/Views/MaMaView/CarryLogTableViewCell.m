//
//  CarryLogTableViewCell.m
//  XLMM
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CarryLogTableViewCell.h"
#import "CarryLogModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
@interface CarryLogTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end


@implementation CarryLogTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCarryModel:(CarryLogModel *)carryModel
                  type:(NSInteger)type {
    NSInteger carry_type = [carryModel.carry_type integerValue];
    self.photoImageV.layer.cornerRadius = 22;
    self.photoImageV.layer.masksToBounds = YES;

    if (type == 0) {
        //全部
        if (carry_type == 1) {
            //返现
            self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
        }else if (carry_type == 2) {
            //佣金
            self.photoImageV.image = [UIImage imageNamed:@"mamayong"];
        }else if (carry_type == 3) {
            //奖金
            self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
        }
        self.sourceLabel.text = [self dateDeal:carryModel.created];
    }else if(type == 1) {
        //佣金
        [self.photoImageV sd_setImageWithURL:[NSURL URLWithString:[carryModel.contributor_img URLEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        self.sourceLabel.text = carryModel.contributor_nick;
    }else if(type == 2) {
        //点击
        self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
        self.sourceLabel.text = [self dateDeal:carryModel.created];
        
    }else if(type == 3) {
        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
        self.sourceLabel.text = [self dateDeal:carryModel.created];
    }

    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [carryModel.carry_value floatValue]];
    self.status.text = carryModel.status_display;
    self.desLabel.text = carryModel.carry_description;
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSString *string = [str substringWithRange:NSMakeRange(11, 5)];
    return string;
}

@end

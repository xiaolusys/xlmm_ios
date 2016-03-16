//
//  CarryLogTableViewCell.m
//  XLMM
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "CarryLogTableViewCell.h"
#import "CarryLogModel.h"

@interface CarryLogTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

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
    }else if(type == 1) {
        //佣金
        self.photoImageV.image = [UIImage imageNamed:@"mamayong"];
    }else if(type == 2) {
        //点击
        self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
        
    }else if(type == 3) {
        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
    }
//    if ([carryModel.log_type isEqualToString:@"rebeta"]) {
//        //佣金
//        self.photoImageV.image = [UIImage imageNamed:@"mamayong"];
//    }else if ([carryModel.log_type isEqualToString:@"click"]) {
//        //分享点击
//        self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
//    }else if ([carryModel.log_type isEqualToString:@"recruit"]){
//        //奖金
//        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
//    }else if ([carryModel.log_type isEqualToString:@"subsidy"]){
//        //提成
//        self.photoImageV.image = [UIImage imageNamed:@"mamati"];
//    }else if ([carryModel.log_type isEqualToString:@"thousand"] || [carryModel.log_type isEqualToString:@"activity"]){
//        //千元提成和参加活动收益
//        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
//    }else if ([carryModel.log_type isEqualToString:@"ordred"]) {
//        //订单红包
//        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
//    }else if ([carryModel.log_type isEqualToString:@"buy"]){
//        //支出
//        self.photoImageV.image = [UIImage imageNamed:@"mamazhi"];
//    }else if ([carryModel.log_type isEqualToString:@"fans_carry"]){
//        //粉丝购买
//        self.photoImageV.image = [UIImage imageNamed:@"mamafens"];
//    }else if ([carryModel.log_type isEqualToString:@"group_bonus"]){
//        //团队新增成员奖金
//        self.photoImageV.image = [UIImage imageNamed:@"mamatuan"];
//    } 
//    
//    if ([carryModel.carry_type isEqualToString:@"in"]) {
//        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [carryModel.value_money floatValue]];
//    }else {
//        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", [carryModel.value_money floatValue]];
//    }

    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [carryModel.carry_value floatValue]];
    self.sourceLabel.text = [self dateDeal:carryModel.created];
    self.desLabel.text = carryModel.carry_description;
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSString *string = [str substringWithRange:NSMakeRange(11, 8)];
    return string;
}

@end
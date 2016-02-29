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

- (void)fillCarryModel:(CarryLogModel *)carryModel {
    if ([carryModel.log_type isEqualToString:@"rebeta"]) {
        //佣金
        self.photoImageV.image = [UIImage imageNamed:@"mamayong"];
    }else if ([carryModel.log_type isEqualToString:@"click"]) {
        //分享点击
        self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
    }else if ([carryModel.log_type isEqualToString:@"recruit"]){
        //奖金
        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
    }else if ([carryModel.log_type isEqualToString:@"subsidy"]){
        //提成
        self.photoImageV.image = [UIImage imageNamed:@"mamati"];
    }else if ([carryModel.log_type isEqualToString:@"thousand"]){
        //千元提成
    }else if ([carryModel.log_type isEqualToString:@"ordred"]) {
        //订单红包
    }
    
    if ([carryModel.carry_type isEqualToString:@"in"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [carryModel.value_money floatValue]];
    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", [carryModel.value_money floatValue]];
    }
    self.sourceLabel.text = carryModel.get_log_type_display;
    self.desLabel.text = carryModel.desc;
    
    
}

@end

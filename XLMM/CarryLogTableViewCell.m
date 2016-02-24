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
        self.sourceLabel.text = @"订单佣金";
        self.desLabel.text = [NSString stringWithFormat:@"哇！好厉害，今日成功了订单交易"];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.value_money floatValue]];
    }else if ([carryModel.log_type isEqualToString:@"click"]) {
        //分享点击
        self.photoImageV.image = [UIImage imageNamed:@"mamafan"];
        self.sourceLabel.text = @"分享返现";
        self.desLabel.text = [NSString stringWithFormat:@"美女，又有用户点击了你的分享！"];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.value_money floatValue]];
    }else if ([carryModel.log_type isEqualToString:@"recruit"]){
        //奖金
        self.photoImageV.image = [UIImage imageNamed:@"mamajiang"];
        self.desLabel.text = [NSString stringWithFormat:@"恭喜您获奖了"];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.value_money floatValue]];
    }else if ([carryModel.log_type isEqualToString:@"subsidy"]){
        //提成
        self.photoImageV.image = [UIImage imageNamed:@"mamati"];
        self.desLabel.text = [NSString stringWithFormat:@"您的提成多了噢"];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.value_money floatValue]];
    }
    
    
}

@end

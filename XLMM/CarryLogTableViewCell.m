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
        self.desLabel.text = [NSString stringWithFormat:@"今日成功推进%d个订单交易", [carryModel.type_count intValue]];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.sum_value floatValue]];
    }else {
        self.photoImageV.image = [UIImage imageNamed:@"mamabu"];
        self.desLabel.text = [NSString stringWithFormat:@"今日共有%d个用户点击的你的分享", [carryModel.type_count intValue]];
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f", [carryModel.sum_value floatValue]];
    }
    
    
}

@end

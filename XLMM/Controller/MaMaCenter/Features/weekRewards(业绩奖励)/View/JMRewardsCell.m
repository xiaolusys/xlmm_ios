//
//  JMRewardsCell.m
//  XLMM
//
//  Created by zhang on 16/8/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRewardsCell.h"

@interface JMRewardsCell ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label5;

@property (nonatomic, strong) UILabel *onelabel;

@end

@implementation JMRewardsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.onelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    [self.contentView addSubview:self.onelabel];
    self.onelabel.numberOfLines = 0;
    self.onelabel.textAlignment = NSTextAlignmentLeft;
    self.onelabel.font = [UIFont systemFontOfSize:12.];
    self.onelabel.text = @"奖励项目";
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, SCREENWIDTH - 100, 60)];
    [self.contentView addSubview:rightView];
    
    NSArray *accountArr = @[@"目标数",@"完成数",@"奖金",@"状态"];
    NSInteger count = accountArr.count;
    for (int i = 0; i < count; i++) {
        UILabel *accountLabel = [UILabel new];
        [rightView addSubview:accountLabel];
        accountLabel.textAlignment = NSTextAlignmentCenter;
        accountLabel.font = [UIFont systemFontOfSize:12.];
        accountLabel.tag = 100 + i;
        accountLabel.text = accountArr[i];
        accountLabel.textColor = [UIColor buttonTitleColor];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@((SCREENWIDTH - 100) / 4));
            make.height.mas_equalTo(@(35));
            make.centerY.equalTo(rightView.mas_centerY);
            make.centerX.equalTo(rightView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)count + 0));
        }];
    }

    
    self.label1 = (UILabel *)[self.contentView viewWithTag:100];
    self.label2 = (UILabel *)[self.contentView viewWithTag:101];
    self.label3 = (UILabel *)[self.contentView viewWithTag:102];
    self.label4 = (UILabel *)[self.contentView viewWithTag:103];
    
    
    self.label4.textColor = [UIColor buttonEnabledBackgroundColor];
    
    
    
}

- (void)setPersonDic:(NSDictionary *)personDic {
    _personDic = personDic;
    NSDictionary *missionDic = personDic[@"mission"];
    self.onelabel.text = [NSString stringWithFormat:@"%@",missionDic[@"name"]];
    self.label1.text = [NSString stringWithFormat:@"%@",personDic[@"target_value"]];
    self.label2.text = [NSString stringWithFormat:@"%ld",[personDic[@"finish_value"] integerValue]];
    CGFloat awardAmount = [personDic[@"award_amount"] floatValue];
    self.label3.text = [NSString stringWithFormat:@"%.2f",awardAmount];
    self.label4.text = [NSString stringWithFormat:@"%@",personDic[@"status_name"]];
    
    
}

- (void)setTeamDic:(NSDictionary *)teamDic {
    _teamDic = teamDic;
    NSDictionary *missionDic = teamDic[@"mission"];
    self.onelabel.text = [NSString stringWithFormat:@"%@",missionDic[@"name"]];
    self.label1.text = [NSString stringWithFormat:@"%@",teamDic[@"target_value"]];
    self.label2.text = [NSString stringWithFormat:@"%ld",[teamDic[@"finish_value"] integerValue]];
    CGFloat awardAmount = [teamDic[@"award_amount"] floatValue];
    self.label3.text = [NSString stringWithFormat:@"%.2f",awardAmount];
    self.label4.text = [NSString stringWithFormat:@"%@",teamDic[@"status_name"]];
    
}





@end


/**
 *  {
 "award_amount" = 30;
 "finish_time" = "<null>";
 "finish_value" = 0;
 id = 173013;
 "mama_id" = 44;
 mission =             {
 "award_amount" = 3000;
 id = 1;
 "kpi_type" = count;
 name = "\U65b0\U589e\U4e0b\U5c5e\U5988\U5988\U4efb\U52a1A";
 "target_value" = 1;
 };
 status = staging;
 "status_name" = "\U8fdb\U884c\U4e2d";
 "target_value" = 1;
 "year_week" = "2016-38";
 },

 */





























































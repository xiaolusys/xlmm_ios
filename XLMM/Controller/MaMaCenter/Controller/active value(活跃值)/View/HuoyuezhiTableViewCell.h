//
//  HuoyuezhiTableViewCell.h
//  XLMM
//
//  Created by younishijie on 16/3/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HuoyuezhiModel;

@interface HuoyuezhiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carryLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

- (void)fillDataOfCell:(HuoyuezhiModel *)activeM;
@end

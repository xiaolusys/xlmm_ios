//
//  MaMaShareSubsidiesViewCell.h
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareClickModel;
@class CarryLogModel;
@interface MaMaShareSubsidiesViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *click_time;
@property (weak, nonatomic) IBOutlet UILabel *click_way;
@property (weak, nonatomic) IBOutlet UILabel *click_money;

- (void)fillCell:(CarryLogModel *)clickModel;
- (void)fillShareSubsidiesCell:(CarryLogModel *)clickModel;
@end

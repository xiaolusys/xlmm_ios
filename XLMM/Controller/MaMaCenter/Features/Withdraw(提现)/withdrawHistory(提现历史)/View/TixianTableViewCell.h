//
//  TixianTableViewCell.h
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TixianModel.h"

@interface TixianTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianTypeLabel;


- (void)fillModel:(TixianModel *)model;
@end

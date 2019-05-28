//
//  JMEarningRecordCell.h
//  XLMM
//
//  Created by zhang on 17/3/2.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarryLogModel,JMEarningModel;
@interface JMEarningRecordCell : UITableViewCell

- (void)configModel:(CarryLogModel *)model Index:(NSInteger)index;
- (void)configEarningModel:(JMEarningModel *)model;


@end

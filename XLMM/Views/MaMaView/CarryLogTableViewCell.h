//
//  CarryLogTableViewCell.h
//  XLMM
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarryLogModel;

@interface CarryLogTableViewCell : UITableViewCell

- (void)fillCarryModel:(CarryLogModel *)carryModel
                  type:(NSInteger)type;
@end

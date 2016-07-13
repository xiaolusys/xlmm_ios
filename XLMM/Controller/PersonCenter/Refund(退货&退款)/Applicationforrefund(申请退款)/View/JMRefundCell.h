//
//  JMRefundCell.h
//  XLMM
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAppForRefundModel.h"
#import "JMContinuePayModel.h"

@interface JMRefundCell : UITableViewCell

- (void)configWithModel:(JMAppForRefundModel *)model Index:(NSInteger)index;

- (void)configWithPayModel:(JMContinuePayModel *)model Index:(NSInteger)index;

@end

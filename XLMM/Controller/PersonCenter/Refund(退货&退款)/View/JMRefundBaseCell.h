//
//  JMRefundBaseCell.h
//  XLMM
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMRefundBaseCellIdentifier;

@class JMRefundModel;

@interface JMRefundBaseCell : UITableViewCell

- (void)configRefund:(JMRefundModel *)refundModel;
- (void)configRefundDetail:(JMRefundModel *)refundModel;

@end

//
//  JMHomeActiveCell.h
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMHomeActiveModel.h"

extern NSString *const JMHomeActiveCellIdentifier;

@interface JMHomeActiveCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *activeDic;

@property (nonatomic, strong) JMHomeActiveModel *model;

@end

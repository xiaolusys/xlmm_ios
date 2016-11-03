//
//  JMFetureFansCell.h
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanceModel.h"

@class JMFetureFansModel;
@class JMVisitorModel;
@interface JMFetureFansCell : UITableViewCell

// 未来粉丝
- (void)fillData:(JMFetureFansModel *)model;
// 我的访客
- (void)fillVisitorData:(JMVisitorModel *)model;
// 今日粉丝
- (void)configNowFnas:(FanceModel *)model;
@end

//
//  JMEarningsRankCell.h
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMEarningsRankModel;
@class JMMaMaTeamModel;
@interface JMEarningsRankCell : UITableViewCell


- (void)config:(JMEarningsRankModel *)model Index:(NSInteger)index;

- (void)configTeamModel:(JMMaMaTeamModel *)model Index:(NSInteger)index;

@end

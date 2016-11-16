//
//  JMCartHistoryCell.h
//  XLMM
//
//  Created by zhang on 16/11/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMCartHistoryCellIdentifier;

@class CartListModel;

@protocol JMCartHistoryCellDelegate <NSObject>


- (void)tapActionHistory:(CartListModel *)model;
- (void)addCart:(CartListModel *)model;



@end

@interface JMCartHistoryCell : UITableViewCell

@property (nonatomic, weak) id <JMCartHistoryCellDelegate> delegate;

@property (nonatomic, strong) CartListModel *cartModel;

@end

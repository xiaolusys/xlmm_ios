//
//  JMProductSelectListCell.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMProductSelectionListModel.h"

@class JMProductSelectListCell;
@protocol JMProductSelectListCellDelegate <NSObject>

- (void)composeProductSelectionList:(JMProductSelectListCell *)selectList addButton:(UIButton *)button;

@end

@interface JMProductSelectListCell : UITableViewCell


- (void)configListCell:(JMProductSelectionListModel *)model;

- (void)fillMyChoice:(JMProductSelectionListModel *)product;

@property (nonatomic, copy) NSString *pdtID;

@property (nonatomic, weak) id<JMProductSelectListCellDelegate> delegate;

@property (nonatomic, strong) JMProductSelectionListModel *listModel;

@property (nonatomic, strong) UILabel *statusLabel;

@end

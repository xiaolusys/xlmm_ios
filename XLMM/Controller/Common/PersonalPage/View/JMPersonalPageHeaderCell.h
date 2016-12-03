//
//  JMPersonalPageHeaderCell.h
//  XLMM
//
//  Created by zhang on 16/11/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPersonalPageHeaderCell;
@protocol JMPersonalPageHeaderCellDelegate <NSObject>

- (void)composeActionView:(JMPersonalPageHeaderCell *)cell Button:(UIButton *)button;

@end


@interface JMPersonalPageHeaderCell : UICollectionViewCell

@property (nonatomic, weak) id <JMPersonalPageHeaderCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *dict;







@end

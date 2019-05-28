//
//  JMHomeCategoryCell.h
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMHomeCategoryCellIdentifier;

@class JMHomeCategoryCell;
@protocol JMHomeCategoryCellDelegate <NSObject>

- (void)composeCategoryCellTapView:(JMHomeCategoryCell *)categoryCellView ParamerStr:(NSDictionary *)paramerString;

@end

@interface JMHomeCategoryCell : UITableViewCell

//@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, weak) id<JMHomeCategoryCellDelegate>delegate;


@end




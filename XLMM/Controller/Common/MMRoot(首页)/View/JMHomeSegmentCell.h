//
//  JMHomeSegmentCell.h
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMHomeSegmentCellIdentifier;

@interface JMHomeSegmentCell : UITableViewCell


//@property (nonatomic, strong) UIScrollView *segmentScrollView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *allDataSource;

@end

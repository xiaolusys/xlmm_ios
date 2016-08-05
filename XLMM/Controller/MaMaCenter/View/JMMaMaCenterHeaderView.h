//
//  JMMaMaCenterHeaderView.h
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMMaMaCenterModel;
@class JMMaMaCenterHeaderView;
@protocol JMMaMaCenterHeaderViewDelegate <NSObject>

@optional
- (void)composeMaMaCenterHeaderView:(JMMaMaCenterHeaderView *)headerView Index:(NSInteger)index;


@end

@interface JMMaMaCenterHeaderView : UIView

+ (instancetype)enterHeaderView;

@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;

@property (nonatomic, strong) NSArray *mamaResults;

@property (nonatomic, weak) id<JMMaMaCenterHeaderViewDelegate>delegate;


@end

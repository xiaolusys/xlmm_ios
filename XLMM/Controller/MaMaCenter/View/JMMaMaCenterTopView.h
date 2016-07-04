//
//  JMMaMaCenterTopView.h
//  XLMM
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMaMaCenterModel.h"

@class JMMaMaCenterTopView;
@protocol JMMaMaCenterTopViewDelegate <NSObject>

- (void)composeBackPageup:(JMMaMaCenterTopView *)backPageup Index:(NSInteger)index;

- (void)composeTapBackPageup:(JMMaMaCenterTopView *)backPageup Tap:(UITapGestureRecognizer *)tap;

@end

@interface JMMaMaCenterTopView : UIImageView

@property (nonatomic, weak) id<JMMaMaCenterTopViewDelegate>delegate;

@property (nonatomic, strong) JMMaMaCenterModel *centerModel;

@end

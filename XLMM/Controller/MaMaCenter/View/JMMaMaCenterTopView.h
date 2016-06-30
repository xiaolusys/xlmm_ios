//
//  JMMaMaCenterTopView.h
//  XLMM
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMMaMaCenterTopView;
@protocol JMMaMaCenterTopViewDelegate <NSObject>

- (void)composeBackPageup:(JMMaMaCenterTopView *)backPageup Index:(NSInteger)index;

@end

@interface JMMaMaCenterTopView : UIImageView

@property (nonatomic, weak) id<JMMaMaCenterTopViewDelegate>delegate;

@end

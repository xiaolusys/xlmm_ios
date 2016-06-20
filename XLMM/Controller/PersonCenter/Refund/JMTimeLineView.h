//
//  JMTimeLineView.h
//  XLMM
//
//  Created by zhang on 16/6/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMTimeLineView : UIView {
    CGFloat viewWidth;
}

@property (nonatomic, assign) CGFloat viewWidth;

- (id)initWithTimeArray:(NSArray *)time andTimeDesArray:(NSArray *)timeDes andCurrentStatus:(NSInteger)status andFrame:(CGRect)frame;


@end

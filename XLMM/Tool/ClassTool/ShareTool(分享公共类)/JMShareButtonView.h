//
//  JMShareButtonView.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMShareButtonView;
@protocol JMShareButtonViewDelegate <NSObject>

@optional
- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index;

@end

@interface JMShareButtonView : UIView

@property (nonatomic,weak) id<JMShareButtonViewDelegate> delegate;


@end
